# Informacje o zbiorze
Maciej Beręsewicz  
3 Mar 2015  


```r
library(dplyr)
load('/Users/MaciejBeresewicz/Documents/Projects/RProjects/Dydaktyka/WIRDS/datasets/matury_kraj.RData')
matury <- tbl_df(matury)
```

Informacje o zbiorze (**UWAGA** zbiór jest duży i zawiera 2479224 wierszy)


```r
dim(matury)
```

```
## [1] 2479224      28
```

```r
glimpse(matury)
```

```
## Observations: 2479224
## Variables:
## $ id_szkoly             (int) 23631, 23634, 26465, 72818, 26472, 26476...
## $ rok                   (dbl) 2010, 2010, 2010, 2010, 2010, 2010, 2010...
## $ id_obserwacji         (int) 3480446, 3475104, 3475111, 3547150, 3475...
## $ id_testu              (int) 1401, 1401, 1401, 1401, 1401, 1401, 1401...
## $ plec                  (chr) "k", "k", "k", "k", "k", "k", "k", "k", ...
## $ rocznik               (int) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ id_cke                (chr) "226510895040", "653813865831", "3567515...
## $ dysleksja             (lgl) FALSE, FALSE, FALSE, FALSE, FALSE, FALSE...
## $ laureat               (lgl) FALSE, FALSE, FALSE, FALSE, FALSE, FALSE...
## $ pop_podejscie         (chr) "2008-2009", "2008-2009", "2008-2009", "...
## $ oke                   (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ zrodlo                (chr) "cke", "cke", "cke", "cke", "cke", "cke"...
## $ typ_szkoly            (chr) "LP", "LO", "T", "LOU", "T", "T", "LO", ...
## $ publiczna             (lgl) TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TR...
## $ dla_doroslych         (lgl) FALSE, TRUE, FALSE, NA, FALSE, FALSE, FA...
## $ specjalna             (lgl) FALSE, FALSE, FALSE, NA, FALSE, FALSE, F...
## $ przyszpitalna         (lgl) FALSE, FALSE, FALSE, NA, FALSE, FALSE, F...
## $ artystyczna           (chr) NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ id_szkoly_oke         (chr) "040501-01230", "040501-05119", "040504-...
## $ pna                   (chr) "87-400", "87-400", "87-410", "88-100", ...
## $ wielkosc_miejscowosci (int) 12978, 12978, 4205, 76192, 9361, 0, 3682...
## $ matura_miedzynarodowa (lgl) FALSE, FALSE, FALSE, NA, FALSE, FALSE, F...
## $ teryt_szkoly          (chr) "040501", "040501", "040504", "040701", ...
## $ wojewodztwo           (chr) "kujawsko-pomorskie", "kujawsko-pomorski...
## $ rodzaj_gminy          (chr) "miejska", "miejska", "miejsko-wiejska",...
## $ matura_nazwa          (chr) "geografia podstawowa", "geografia podst...
## $ ID                    (int) 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1...
## $ wyniki_matur          (dbl) 9, 18, 9, 7, 10, 6, 7, 10, 7, 11, 9, 8, ...
```

Szczegółowe informacje o zbiorze można znaleźć na stronie: http://zpd.ibe.edu.pl/doku.php
Jakie matury znajdują się w zbiorze danych?


```r
matury %>% count(matura_nazwa)
```

```
## Source: local data frame [6 x 2]
## 
##              matura_nazwa       n
## 1    geografia podstawowa  219994
## 2   geografia rozszerzona  151366
## 3  informatyka podstawowa    9770
## 4 informatyka rozszerzona    8210
## 5   matematyka podstawowa 1804150
## 6  matematyka rozszerzona  285734
```

Oraz za jakie lata


```r
matury %>% count(rok)
```

```
## Source: local data frame [5 x 2]
## 
##    rok      n
## 1 2010 501984
## 2 2011 513143
## 3 2012 513247
## 4 2013 492554
## 5 2014 458296
```

Informacje o zmiennych


* id_szkoly             - identyfikator szkoły
* rok                   - rok
* id_obserwacji         - numer obserwacji
* id_testu              - numer testu
* plec                  - płeć ucznia
* rocznik               - rok urodzenia
* id_cke                - identyfikator centralnej komisji edukacyjnej
* dysleksja             - czy uczeń jest dyslektykiem?
* laureat               - czy uczeń jest laureatem?
* pop_podejscie         - czy uczeń poprawiał egzami?
* oke                   - identyfikator okręgowej komisji egzaminacyjnej
* zrodlo                - źródło danych
* typ_szkoly            - typ szkoły 
* publiczna             - czy jest to szkoła publiczna?
* dla_doroslych         - czy jest to szkoła dla dorosłych?
* specjalna             - czy jest to szkoła specjalna?
* przyszpitalna         - czy jest to szkoła przyszpitalna?
* artystyczna           - czy jest to szkoła artystyczna?
* id_szkoly_oke         - identyfikator szkoły
* pna                   - kod pocztowy szkoły
* wielkosc_miejscowosci - wielkość miejscowości (liczba mieszkańców)
* matura_miedzynarodowa - czy była to matura międzynarodowa?
* teryt_szkoly          - kod teryt szkoły (można użyć do wskazania powiatów, województw)
* wojewodztwo           - nazwa województwa
* rodzaj_gminy          - typ gminy
* matura_nazwa          - nazwa matury
* ID                    - identyfikator rekordu (nie jest potrzebny)
* wyniki_matur          - suma punktów uzyskanych przez danego ucznia
