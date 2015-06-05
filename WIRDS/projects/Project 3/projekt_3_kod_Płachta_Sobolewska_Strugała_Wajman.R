# < biblioteki ---------------------------------------------------------------

library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)
library(scales)
library(gridExtra)
library(reshape2)

windowsFonts(
  A=windowsFont("Segoe Print"))

# < filtrowanie danych -------------------------------------------------------------------

# matematyka 2014 -------------------------------------------------------------------\

matury2014 <- matury %>%
  filter(rok == '2014', plec != 'NA', wojewodztwo != 'NA', oke != 'NA', matura_nazwa == c('matematyka podstawowa', 'matematyka rozszerzona'))
matury2014$plec <- factor(matury2014$plec,
                          levels = c("k", "m"),
                          labels = c("kobieta", "mê¿czyzna"))

# matematyka 2010-2014 ---------------------------------------------------------------\

matma <- matury %>%
  filter(plec != 'NA', wojewodztwo != 'NA', oke != 'NA', matura_nazwa == c('matematyka podstawowa', 'matematyka rozszerzona'))

# < ³adowanie przefiltrowanych danych ----------------------------------------------------

load(file = "D:/Studia/IV/WIRDS/project/matury_mat.rda")
load(file = "D:/Studia/IV/WIRDS/project/matury2014mat.rda")

# < Wykres 1: wg OKE ------------------------------------------------------------

p1 <- matury2014 %>% 
  count(wyniki_matur,oke) %>%
  group_by(oke) %>%
  mutate(procent = n/sum(n)) %>%
  ggplot(data =., aes ( x = wyniki_matur, y = procent, fill = oke)) +
  geom_bar(stat = 'identity', position ='identity', col ='black') +
  theme_bw() +
  geom_abline(intercept = 14.5, slope = -1, colour = 'black', size = 0.5) +
  facet_wrap(~oke, ncol = 4) +
  coord_flip() +
  scale_y_continuous("Odsetek maturzystów", labels = percent) +
  xlab("Wynik [pkt]") +
  theme(legend.position = "none", 
        title = element_text(size = 18, family = "A"), 
        axis.title.x = element_text(size = 15, family = "A"),
        axis.title.y = element_text(size = 15, family = "A"),
        axis.text.y = element_text(size = 12, family = "A"),
        axis.text.x = element_text(size = 12, family = "A"),
        strip.text.x = element_text(size = 15, family = "A"),
        strip.background = element_rect(fill = "#a6cee3")) + 
  ggtitle('Wyniki matury z matematyki w 2014 roku') +
  scale_fill_manual(values=c("#e41a1c", "#377eb8", "#4daf4a", "#984ea3", "#ff7f00", "#ffff33", "#a65628", "#f781bf"))  

# < Wykres 2: Œrednie wg lat --------------------------------------------------------

wglat <- group_by(matma, rok)
sred <- summarise(wglat,mean(wyniki_matur))
as.factor(sred$rok)
p2 <- ggplot(data = sred, aes(x = rok, y = sred$`mean(wyniki_matur)`, fill = rok)) +
  geom_bar(stat = 'identity', colour = 'black') + coord_flip() +
  theme_bw() +
  xlab("Rok") +
  ylab("Œredni wynik matury [pkt.]") +
  theme(legend.position = "none", 
        title = element_text(size = 15, family = "A"), 
        axis.title.x = element_text(size = 13, family = "A"),
        axis.title.y = element_text(size = 13, family = "A"),
        axis.text.y = element_text(size = 11, family = "A"),
        axis.text.x = element_text(size = 11, family = "A")) + 
  ggtitle("Œredni wynik z matury z matematyki w latach 2010-2015")

# < Wykres 3: Mozaikowy 1 ----------------------------------------------------------

# Dodanie zmiennej 'zdawalnosc' oraz nadanie etykiet --------------------\

matma$zdawalnosc <- ifelse(matma$wyniki_matur >= 15, 'zdana', 'niezdana')
as.factor(matma$zdawalnosc)
matma$plec <- factor(matma$plec,
                     levels = c("k", "m"),
                     labels = c("kobieta", "mê¿czyzna"))

# Tabele ----------------------------------------------------------------\

# Tabela 0: wg typu szko³y ---------------------------]

tab00 <- table(matma$typ_szkoly)
wgtypu0 <- round(prop.table(tab00),4)*100

# Tabele 1: wg zdawalnoœci i typu szko³y ---------]

tab11 <- table(matma$zdawalnosc, matma$typ_szkoly)

# Wektory procentowe wg p³ci i typu szko³y -----------] 

NZ <- round(tab11[1,]/tab00,4)*100  # osoby, które nie zda³y
Z <- round(tab11[2,]/tab00,4)*100   # osoby, które zda³y

# Tabela zbiorcza ------------------------------------]

data.frame(typ = c('LO','LOU','LP','T','TU'), wgs = wgtypu[1:5], nz = NZ, z = Z) 
# przerzucone do excela 
df0 <- readWorkbook(xlsxFile = "D://Studia/IV/WIRDS/project/DF.xlsx", sheet = 2)

# Rysowanie wykresu ------------------------------------------------------------------\

df0$xmax <- cumsum(df0$wgtypu)
df0$xmin <- df0$xmax - df0$wgtypu
df0$wgtypu <- NULL

dfm0 <- melt(df0, id = c("typ", "xmin", "xmax"))

dfm01 <- ddply(dfm0, .(typ), transform, ymax = cumsum(value))
dfm01 <- ddply(dfm01, .(typ), transform,
              ymin = ymax - value)

dfm01$xtext <- with(dfm01, xmin + (xmax - xmin)/2)
dfm01$ytext <- with(dfm01, ymin + (ymax - ymin)/2)

p3 <- ggplot(dfm01, aes(ymin = ymin, 
                       ymax = ymax,
                       xmin = xmin, 
                       xmax = xmax, 
                       fill = variable)) +
  geom_rect(colour = I("black")) +
  geom_text(aes(x = xtext, y = 103,
                label = paste(typ)), size = 6, family = "A") +
  geom_text(aes(x = xtext, y = ytext,
                label = paste(round(value,0), "%", sep = "")), size = 6, family = "A") + 
  xlab("Odsetek osób zdaj¹cych maturê wed³ug typu szko³y") +
  ylab("Odsetek osób zdaj¹cych maturê wed³ug zdawalnoœci") +
  theme_bw() + 
  theme(legend.title = element_blank(), 
        title = element_text(size = 18, family = "A"), 
        axis.title.x = element_text(size = 15, family = "A"),
        axis.title.y = element_text(size = 15, family = "A"),
        axis.text.y = element_text(size = 12, family = "A"),
        axis.text.x = element_text(size = 12, family = "A"), 
        legend.text = element_text(size = 12, family = "A"),
        legend.position = "bottom") +
  scale_fill_manual(values=c("#1a9641","#d7191c"),
                    labels = c("osoby, które zda³y", "osoby, które nie zda³y")) +
  ggtitle('Zdawalnoœæ matury z matematyki w latach 2010-2014 wed³ug typu szko³y') 

# < Wykres 4: Mozaikowy 2 ----------------------------------------------------------

# Filtrowanie wed³ug p³ci -----------------------------------------------\

matma_k <- matma %>%
  filter(plec == 'kobieta')
matma_m <- matma %>%
  filter(plec == 'mê¿czyzna')

# Tabele ----------------------------------------------------------------\

# Tabela 0: wg typu szko³y ---------------------------]

tab0 <- table(matma$typ_szkoly)
wgtypu <- round(prop.table(tab0),4)*100

# Tabele 1 i 2: wg zdawalnoœci i typu szko³y ---------]

tab1 <- table(matma_m$zdawalnosc, matma_m$typ_szkoly)
tab2 <- table(matma_k$zdawalnosc, matma_k$typ_szkoly)

# Wektory procentowe wg p³ci i typu szko³y -----------] 

MNZ <- round(tab1[1,]/tab0,4)*100  # mê¿czyŸni, którzy nie zdali
MZ <- round(tab1[2,]/tab0,4)*100   # mê¿czyŸni, którzy zdali
KNZ <-round(tab2[1,]/tab0,4)*100   # kobiety, które nie zda³y
KZ <- round(tab2[2,]/tab0,4)*100   # kobiety, które zda³y

# Tabela zbiorcza ------------------------------------]

data.frame(typ = c('LO','LOU','LP','T','TU'), wgs = wgtypu[1:5], mz = MZ, mnz = MNZ, kz = KZ, knz = KNZ) 
# przerzucone do excela 
df <- readWorkbook(xlsxFile = "D://Studia/IV/WIRDS/project/DF.xlsx", sheet = 1)

# Rysowanie wykresu ------------------------------------------------------------------\

df$xmax <- cumsum(df$wgtypu)
df$xmin <- df$xmax - df$wgtypu
df$wgtypu <- NULL

dfm <- melt(df, id = c("typ", "xmin", "xmax"))

dfm1 <- ddply(dfm, .(typ), transform, ymax = cumsum(value))
dfm1 <- ddply(dfm1, .(typ), transform,
                ymin = ymax - value)

dfm1$xtext <- with(dfm1, xmin + (xmax - xmin)/2)
dfm1$ytext <- with(dfm1, ymin + (ymax - ymin)/2)

p4 <- ggplot(dfm1, aes(ymin = ymin, 
                      ymax = ymax,
                      xmin = xmin, 
                      xmax = xmax, 
                      fill = variable)) +
  geom_rect(colour = I("black")) +
  geom_text(aes(x = xtext, y = 103,
                label = paste(typ)), size = 6, family = "A") +
  geom_text(aes(x = xtext, y = ytext,
                label = paste(round(value,0), "%", sep = "")), size = 6, family = "A") + 
  scale_fill_manual(values=c("#1a9641","#a6d96a", 
                             "#fdae61","#d7191c"), 
                    labels = c("mê¿czyŸni, którzy zdali", "kobiety, które zda³y", "mê¿czyŸni, którzy nie zdali", "kobiety, które nie zda³y")) +
  xlab("Odsetek osób zdaj¹cych maturê wed³ug typu szko³y") +
  ylab("Odsetek osób zdaj¹cych maturê wed³ug p³ci i zdawalnoœci") +
  theme_bw() +
  theme(legend.title = element_blank(), 
        title = element_text(size = 18, family = "A"), 
        axis.title.x = element_text(size = 15, family = "A"),
        axis.title.y = element_text(size = 15, family = "A"),
        axis.text.y = element_text(size = 12, family = "A"),
        axis.text.x = element_text(size = 12, family = "A"),
        legend.text = element_text(size = 10, family = "A"),
        legend.position = "bottom") +
  ggtitle('Zdawalnoœæ matury z matematyki w latach 2010-2014 wed³ug p³ci i typu szko³y') 
  

