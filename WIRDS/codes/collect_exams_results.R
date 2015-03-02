### download data on Matury

### load package
library(ZPD)
library(XML)

### tables
tabs <- readHTMLTable('http://zpd.ibe.edu.pl/doku.php?id=czesci_egzaminu', 
                      which=2,
                      stringsAsFactors=F) 
names(tabs)[1] <- 'rodzaj_egzaminu'

tabs <- tabs %>%
  filter(rodzaj_egzaminu == 'matura') %>%
  #filter(grepl('mat|fiz|geo|pol|inf|ang',prefiks))
  filter(grepl('mat',prefiks))

###
matura <- list()
for (i in 1:nrow(tabs)) {
  src <- polacz()
  wyniki <- pobierz_wyniki_egzaminu(src, 
                                    'matura', 
                                    tabs[[i,3]], 
                                    tabs[[i,2]], T)
  uczniowie <-  pobierz_uczniow(src)
  uczniowieTesty <- pobierz_dane_uczniowie_testy(src)
  szkoly <- pobierz_szkoly(src)
  mat <- inner_join(wyniki, uczniowie) %>% 
    inner_join(uczniowieTesty) %>% 
    inner_join(szkoly)
  matura[[i]] <- mat %>% collect()
  save(matura, file = 'WIRDS/datasets/matury_kraj.RData')
}

matury_matematyka_podstaowa <- rbind_all(math_basic)





