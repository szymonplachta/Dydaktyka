library(XLConnect)
library(dplyr)
library(ggplot2)
fName <- "C:/Users/Szymon/Desktop/gospodarstwa.xls"
wb <- loadWorkbook(fName)
gos <- readWorksheet(wb, sheet = "gospodarstwa")
gos$woj <- factor(gos$woj,
                  levels = c("02", "04", "06", "08", "10", "12", "14", "16", "18", "20",
                             "22", "24", "26", "28", "30", "32"),
                  labels = c("dolnoœl¹skie", "kujawsko-pomorskie", "lubelskie", "lubuskie", "³ódzkie",
                             "ma³opolskie", "mazowieckie", "opolskie", "podkarpackie", "podlaskie",
                             "pomorskie", "œl¹skie", "œwiêtokrzyskie", "warmiñsko-mazurskie",
                             "wielkopolskie", "zachodniopomorskie"))
gos %>% 
  count(klm,woj) %>%
  group_by(woj) %>%
  mutate(proc = n/sum(n)) %>%
  ggplot(data = ., aes(x = " ", y = proc, group = klm, fill = klm)) +
  xlab("województwo") +
  geom_bar(stat = 'identity', col='black') +
  facet_wrap(~woj, ncol=1) + 
  coord_flip()
