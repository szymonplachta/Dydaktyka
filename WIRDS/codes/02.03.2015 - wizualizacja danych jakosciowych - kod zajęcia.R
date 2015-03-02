#### podstawowe polecenia
select()
filter()
mutate()
summarise()
arrange()

group_by()

###
library(dplyr)
gosp <- tbl_df(gosp)

gosp %>%
  select(klm)

gosp %>%
  select(-klm)

gosp %>%
  select(klm) %>%
  group_by(klm) %>%
  summarise(N = n())

gosp %>% 
  count(klm)

### 
gosp %>%
  filter(woj == '30') %>%
  count(klm)

###
gosp %>%
  filter(woj == '30') %>%
  mutate(dochg2 =  dochg * 2) %>%
  summarise(m = mean(dochg2))

###
gosp %>%
  filter(woj == '30') %>%
  mutate(dochg2 =  dochg * 2) %>%
  group_by(klm) %>%
  summarise(m = mean(dochg2))

###
wynik <- gosp %>%
  filter(woj == '30') %>%
  mutate(dochg2 =  dochg * 2) %>%
  group_by(klm) %>%
  summarise(m = mean(dochg2))


# ggplot2 ---------------
library(ggplot2)

gosp <- gosp %>%
  mutate(klm = factor( x = klm,
                       levels = 6:1,
                       labels = c('Wieś',
                                  '<20',
                                  '[20,100)',
                                  '[100,200)',
                                  '[200,500)',
                                  '>=500'),
                       ordered = T))

ggplot( data = gosp,
        aes( x = klm)) + 
  geom_bar() 

ggplot( data = gosp,
        aes( x = klm, fill=klm)) + 
  geom_bar() 


ggplot( data = gosp,
        aes( x = klm)) + 
  geom_bar() +
  facet_wrap(~woj)

ggplot( data = gosp,
        aes( x = klm)) + 
  geom_bar() +
  facet_wrap(~woj,ncol=3)


# procenty -------

gosp %>%
  count(klm) %>%
  mutate(procent = n / sum(n)) %>%
  ggplot( data = .,
          aes ( x = klm,
                y = procent)) +
  geom_bar(stat = 'identity')


gosp %>%
  count(klm) %>%
  mutate(procent = n / sum(n)) %>%
  ggplot( data = .,
          aes ( x = klm,
                y = procent)) +
  geom_point()

wykres <- gosp %>%
  count(klm) %>%
  mutate(procent = n / sum(n)) %>%
  ggplot( data = .,
          aes ( x = klm,
                y = procent,
                size = procent)) +
  geom_point()

plot(wykres)
  
wykres + 
  ggtitle('Udział respondentów według klasy wielkości miejscowości') +
  xlab('Klasa wielkości miejscowości') + 
  ylab('Procent obserwacji') +
  theme_bw()

library(ggthemes)

wykres + 
  ggtitle('Udział respondentów według klasy wielkości miejscowości') +
  xlab('Klasa wielkości miejscowości') + 
  ylab('Procent obserwacji') +
  theme_gdocs()

#### 

gosp %>%
  count(klm) %>%
  mutate(procent = n / sum(n)) %>%
  ggplot( data = .,
          aes ( x = klm,
                y = procent)) +
  geom_bar(stat = 'identity') +
  coord_flip()

gosp %>%
  count(klm) %>%
  mutate(procent = n / sum(n)) %>%
  ggplot( data = .,
          aes ( x = reorder(klm,-procent,mean), 
                y = procent)) +
  geom_bar(stat = 'identity') +
  coord_flip()


### druga propozycja
gosp %>%
  count(klm,woj) %>%
  group_by(woj) %>%
  mutate(procent = n/sum(n)) %>%
  ggplot(data = .,
         aes(x = woj,
             y = procent)) + 
  geom_bar(stat='identity') + 
  facet_wrap(~klm)

### pierwsza propozycja
gosp %>%
  count(klm,woj) %>%
  group_by(woj) %>%
  mutate(procent = n/sum(n)) %>%
  ggplot(data = .,
         aes(x = klm,
             y = procent,
             group = woj,
             fill = woj)) + 
  geom_bar(stat='identity',
           position = 'dodge',
           col = 'black') 

### propozycja 3

gosp %>%
  count(klm,woj) %>%
  group_by(woj) %>%
  mutate(procent = n/sum(n)) %>%
  ggplot(data = .,
         aes(x = woj,
             y = procent,
             group = klm,
             fill = klm)) +
  geom_bar(stat = 'identity',
           col='black') +
  coord_flip()


gosp %>%
  count(klm,woj) %>%
  group_by(woj) %>%
  mutate(procent = n/sum(n)) %>%
  ggplot(data = .,
         aes(x = woj,
             y = procent,
             group = klm,
             fill = klm)) +
  geom_bar(stat = 'identity',
           col='black') +
  facet_wrap(~woj, ncol=1) + 
  coord_flip()



















