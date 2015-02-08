library("dplyr")
library("tidyr")
library("magrittr")

summary(mtcars)
mtcars %>% summary()
mtcars %>% summary(.)

mtcars %>% .$carb %>% summary()
mtcars %>% .$am %>% table() %>% barplot()

mtcars %>% 
  sapply(.,class) %>% 
  unique()

mtcars %>% tbl_df()

mtcars %>% mutate(mgp2=mpg*2)

mtcars <- mtcars

mtcars %>%
  tbl_df() %>%
  select(mpg,qsec:gear,-am) %>%
  filter(mpg > mean(mpg), vs == 1) %>%
  group_by(gear) %>%
  summarise(mpg = mean(mpg),
            n = n())

mtcars %>%
  tbl_df() %>%
  mutate_each(funs(.*2),mpg:qsec)

mtcars %>%
  tbl_df() %>%
  group_by(gear) %>%
  summarise_each(funs(min,max),mpg:qsec)

mtcars %>%
  tbl_df() %>% 
  count(gear,wt = mpg) %>%
  arrange(desc(n))


mtcars %>%
  tbl_df() %>%
  summarise_each(funs(min,max),mpg:qsec) %>%
  gather(Lodowka,Zawartosc)

mtcars %>%
  tbl_df() %>%
  group_by(gear,am) %>%
  summarise_each(funs(min,max),mpg:qsec) %>%
  gather(Lodowka,Zawartosc,-gear,-am)

mtcars %>%
  tbl_df() %>%
  group_by(am,gear) %>%
  summarise_each(funs(min,max),mpg:qsec) %>%
  gather(Lodowka,Zawartosc,mpg_min:qsec_max) %>%
  separate(col = Lodowka,
           into = c('Zm','Stat'),
           sep='_') %>%
  spread(key = Stat,value = Zawartosc) %>%
  select(am:Zm,min,max)

  




