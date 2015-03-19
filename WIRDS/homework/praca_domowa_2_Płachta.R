library(dplyr)
library(tidyr)
library(ggplot2)
library(openxlsx)

dane <- readWorkbook(xlsxFile = "C:/Users/Szymon/Desktop/Zeszyt1.xlsx", sheet = 1)

dane_liniowy <- dane %>% 
  gather(rok, y, r2002,r2011)

ggplot(data = dane_liniowy,
       aes(x=rok, 
           y=y,
           colour = Kategoria,
           group = Kategoria)) + 
  geom_point(size = 4) +
  geom_line() + 
  theme_bw() + 
  xlab('Rok spisu') + 
  ylab('Udzia³ (%)') +
  ggtitle('Udzia³ . . . ') +
  geom_text(aes(label=Kategoria), hjust=-0.2, vjust=0, size =4)+
  geom_text(aes(label=y), hjust=1.9, vjust=0, size =4)
