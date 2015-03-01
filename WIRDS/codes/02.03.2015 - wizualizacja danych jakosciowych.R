### lecture on 02.03.2015

# wczytanie pakietów ------------------------------------------------------
library(dplyr)
library(ggplot2)
library(ggvis)
library(tidyr)
library(XLConnect)
library(scales)

# wczytanie danych --------------------------------------------------------

wb <- loadWorkbook('WIRDS/datasets/gospodarstwa.xls')
gosp <- readWorksheet(wb,'gospodarstwa')
vars <- readWorksheet(wb,'opis cech')
vars_labels <- readWorksheet(wb,'opis wariantów cech')

gosp <- tbl_df(gosp)


# podsumowania ------------------------------------------------------------

gosp %>% count(woj) 
gosp %>% count(woj,sort=T)

gosp %>% count(woj,klm,sort=T) 

# podstawowe wykresy w R --------------------------------------------------
gosp$woj %>% 
  table() %>% 
  barplot()

# podstawowe wykresy w ggplot2 --------------------------------------------
ggplot(data=gosp,
       aes(x = woj)) + 
  geom_bar()

ggplot(data=gosp,
       aes(x = reorder(woj,woj,length))) + 
  geom_bar()

ggplot(data=gosp,
       aes(x = as.factor(klm))) + 
  geom_bar() + 
  facet_wrap(~woj)

ggplot(data=gosp,
       aes(x = as.factor(klm))) + 
  geom_bar() + 
  facet_grid(~woj)

ggplot(data=gosp,
       aes(x = as.factor(d63))) + 
  geom_bar() + 
  facet_wrap(~woj)


# sytuacja materialna -----------------------------------------------------
gosp %>%
  mutate(d61 = factor(x = d61,
                      levels = 1:5,
                      labels = c('Bardzo dobra',
                                 'Raczej dobra',
                                 'Przeciętna',
                                 'Raczej zła',
                                 'Zła'),
                      ordered = T)) %>% 
  count(woj,d61) %>%
  mutate(p = n/sum(n)) %>% 
  ggplot(data = .,
         aes(x = woj,
             y = p,
             fill = d61)) +
  geom_bar(stat = 'identity',
           colour = 'black') + 
  scale_y_continuous(labels = percent) +
  scale_fill_brewer(palette = 'Greens') + 
  theme_bw() +
  coord_flip()



