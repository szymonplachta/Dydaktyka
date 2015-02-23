# WIRDS: wprowadzenie do tidyr
Maciej Beręsewicz  
20 Jan 2015  

## Pakiet tidyr

Celem prezentacji jest wprowadzenie do nowego pakietu [tidyr](https://github.com/hadley/tidyr). Dodatkowo wykorzystywać będziemy potokowe przetwarzanie danych, które poznaliśmy przy okazji korzystania z pakietu [magrittr](http://cran.r-project.org/web/packages/magrittr/index.html) oraz [dplyr](https://github.com/hadley/dplyr).

## Wprowadzenie do tidyr

Hadley Wickham zaproponował pojęcie "tidy data" jako danych przygotowanych specjalnie do przeprowadzania analiz. Szczegóły można znaleźć w poniższym [artykule](http://www.jstatsoft.org/v59/i10/paper).

![](http://www.jstatsoft.org/v59/i10/paper)

## Podstawowe funkcje 

- gather - funkcja do przetworzenia zbioru do typu "long"
- spread - funkcja do przetworzenia zbioru do typu "wide"
- separate - funkcja do zastąpienia danej kolumny przez utworzone na podstawie jej rozdzielenia
- extract - funkcja do wyciągania z kolumny wartości według określonego wyrażenia regularnego
- extract_numeric - funkcja do wyciągania wartości numerycznych z określonej kolumny
- expand - funkcja do tworzenia wszystkich możliwych kombinacji zmiennych
- unite - funkcja do sklejania kolumn

## Przygotowanie danych (1)

Zajmiemy się ponownie przykładem danych pochodzących z badania [Diagnoza Społeczna](www.diagnoza.com), które są dostępne w pakiecie Diagnoza stworzonym przez dr hab. Przemysława Biecka.


```r
install.packages(devtools)
library(devtools)
install_github('pbiecek/Diagnoza')
```


```r
library(Diagnoza)
library(dplyr)
library(tidyr)
gosp <- tbl_df(gospodarstwa)
dim(gosp)
```

```
## [1] 23804  2161
```

## Przygotowanie danych (2)

Wybierzemy taki sam podzbiór danych, jak w przypadku wprowadzenia do pakietu dplyr.


```r
gosp_subset <- gosp %>%
                select(numer_gd, starts_with('WAGA'), 
                       contains('ekw'), contains('woje')) %>%
                mutate_each(funs(as.numeric(.) ), everything()) 
gosp_subset
```

```
## Source: local data frame [23,804 x 22]
## 
##    numer_gd WAGA_GD_2000 WAGA_GD_2003 WAGA_GD_2005 WAGA_GD_2007
## 1         1    0.8441222     0.000000     0.000000    0.0000000
## 2         2    1.2796800     1.251585     1.112111    0.3304216
## 3         3    1.0427392     0.640080     0.666600    0.0000000
## 4         4    1.2796800     1.251585     1.112111    1.5144856
## 5         5    1.2796800     0.000000     0.000000    0.0000000
## 6         6    0.4910772     1.083564     1.112111    1.7968025
## 7         7    1.1785853     1.083564     1.112111    0.6655304
## 8         8    0.7591435     0.725805     0.816585    0.2238430
## 9         9    1.0264100     0.891540     1.112111    0.0000000
## 10       10    1.3996500     1.251585     0.000000    1.8356900
## ..      ...          ...          ...          ...          ...
## Variables not shown: WAGA_GD_2009 (dbl), WAGA_GD_2011 (dbl), WAGA_GD_2013
##   (dbl), WAGA_GD_2007_2009 (dbl), WAGA_GD_2007_2011 (dbl),
##   WAGA_GD_2009_2011 (dbl), WAGA_GD_2011_2013 (dbl), WAGA_GD_2009_2013
##   (dbl), adoch_m_00_ekwb (dbl), bdoch_m_00_ekwb (dbl), cdoch_m_00_ekwb
##   (dbl), ddoch_m_00_ekwb (dbl), fdoch_r_osoba_ekw (dbl), fdoch_m_osoba_ekw
##   (dbl), gdoch_r_osoba_ekw (dbl), gdoch_m_osoba_ekw (dbl), WOJEWODZTWO
##   (dbl)
```

## Przykład układu danych typu wide (szeroki)

Dane typu wide charakteryzują się następującymi własnościami:
- każdy rekord oznacza jednostkę / działanie
- kolumny oznaczają zmienne / charakterystyki


```r
dane_wide <- data.frame(A = 1:5, Dochod_2010 = rnorm(5), Dochod_2011 = rnorm(5))
dane_wide
```

```
##   A  Dochod_2010 Dochod_2011
## 1 1 -0.614192551 -0.94228725
## 2 2  0.376351877 -2.03331455
## 3 3 -1.002291169 -0.38129620
## 4 4 -0.007740204  0.47000872
## 5 5  1.812011753  0.01801184
```

## Przykład układu danych typu long (długi)

Dane typu long charakteryzują się następującymi własnościami:
- jeden lub więcej rekordów dotyczy jednej jednostki / działania
- kolumny oznaczają identyfikatory jednostek (np. grupy)
- jest jedna kolumna ze zmienną oraz druga, która zawiera wartości tej zmiennej


```r
dane_long <- data.frame(A = rep(1:5,each = 2), 
                        Zmienna = rep(c('Dochod_2010','Dochod_2011'),5),
                        Wartosc = rnorm(10))
dane_long
```

```
##    A     Zmienna     Wartosc
## 1  1 Dochod_2010 -0.08218355
## 2  1 Dochod_2011  1.40449142
## 3  2 Dochod_2010  1.06570714
## 4  2 Dochod_2011  0.12449847
## 5  3 Dochod_2010 -1.03712808
## 6  3 Dochod_2011 -0.23710199
## 7  4 Dochod_2010  0.37867995
## 8  4 Dochod_2011  0.80997322
## 9  5 Dochod_2010 -0.47493504
## 10 5 Dochod_2011  0.72713636
```

## Podstawowe funkcje - gather (1)

Funkcja gather ma następujące argumenty

- data - zbiór wejściowy (typu wide), w przypadku przetwarzania potokowego pomijamy ten argument lub zapisujemy data = .
- key - zmienna, która zawierać będzie nazwy kolumn (zmiennych)
- value - zmienna, która zawierać będzie wartości kolumn (zmiennych)
- ... - trzy kropki oznaczają przekazywanie zmiennych, które może odbywać się następująco
    + zmienna_1:zmienna_n - wskazujemy, które zmienne chcemy wstawić do zmiennej key
    + -id_1, -id_2 - wskazujemy, które zmienne wykluczamy z włączenia do zmiennej key i zostają one automatycznie stworzone zmiennymi identyfikującymi
- na.rm - (logiczny) określamy czy chcemy aby w zmiennej zostały braki danych
- convert - (logiczny) określamy czy chcemy aby zmienne zostały przetworzone do tego samego typu (np. numeric, integer, logical)

## Podstawowe funkcje - gather (2)

Funkcja gather umożliwa przejście ze zbioru typu wide na zbiór typu long. Załóżmy, że chcemy otrzymać zbiór w którym znajdować się będą identyfikatory jednostek, zmienna określająca dochód ekwiwalentny oraz zmienna określająca wartość tego dochodu.


```r
gosp_subset %>%
  select(numer_gd,contains('ekw')) %>%
  gather(Dochod, Wartosc_Dochodu, -numer_gd)
```

```
## Source: local data frame [190,432 x 3]
## 
##    numer_gd          Dochod Wartosc_Dochodu
## 1         1 adoch_m_00_ekwb        429.4479
## 2         2 adoch_m_00_ekwb        663.2065
## 3         3 adoch_m_00_ekwb        755.2870
## 4         4 adoch_m_00_ekwb        555.5556
## 5         5 adoch_m_00_ekwb       1049.3827
## 6         6 adoch_m_00_ekwb        714.9066
## 7         7 adoch_m_00_ekwb        236.8788
## 8         8 adoch_m_00_ekwb        337.6097
## 9         9 adoch_m_00_ekwb       1001.9724
## 10       10 adoch_m_00_ekwb        370.3704
## ..      ...             ...             ...
```

## Podstawowe funkcje - gather (3)

Jest to równoznaczne


```r
gosp_subset %>%
  select(numer_gd,contains('ekw')) %>%
  gather(Dochod, Wartosc_Dochodu, adoch_m_00_ekwb:gdoch_m_osoba_ekw)
```

```
## Source: local data frame [190,432 x 3]
## 
##    numer_gd          Dochod Wartosc_Dochodu
## 1         1 adoch_m_00_ekwb        429.4479
## 2         2 adoch_m_00_ekwb        663.2065
## 3         3 adoch_m_00_ekwb        755.2870
## 4         4 adoch_m_00_ekwb        555.5556
## 5         5 adoch_m_00_ekwb       1049.3827
## 6         6 adoch_m_00_ekwb        714.9066
## 7         7 adoch_m_00_ekwb        236.8788
## 8         8 adoch_m_00_ekwb        337.6097
## 9         9 adoch_m_00_ekwb       1001.9724
## 10       10 adoch_m_00_ekwb        370.3704
## ..      ...             ...             ...
```

## Podstawowe funkcje - spread (1)

Funkcja gather ma następujące argumenty:

- data - zbiór wejściowy (typu long), w przypadku przetwarzania potokowego pomijamy ten argument lub zapisujemy data = .
- key - zmienna, która zawiera nazwy nowo tworzonych kolumn (zmiennych)
- value - zmienna, która zawiera wartości nowo tworzonych kolumn kolumn (zmiennych)
- fill - określenie w jaki sposób mają być reprezentowane braki danych  
- drop - (logiczny) określamy czy zmienne mają zachować etykiety (factor levels)
- convert - (logiczny) określamy czy chcemy aby zmienne zostały przetworzone do tego samego typu (np. numeric, integer, logical)

## Podstawowe funkcje - spread (2)

Celem jest stworzenie tabeli, w której wiersze odnosić się będą do gospodarstwa domowego natomiast kolumny będą to kolejne numery województw. Tabela wypełniona będzie wartościami zawartymi w zmiennej WAGA_GD_2013.


```r
gosp_subset %>%
  filter(!is.na(WOJEWODZTWO) & !is.na(WAGA_GD_2013)) %>%
  select(numer_gd,WOJEWODZTWO,WAGA_GD_2013) %>%
  spread(key = WOJEWODZTWO,value = WAGA_GD_2013, fill=0)
```

```
## Source: local data frame [12,355 x 17]
## 
##    numer_gd        1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16
## 1         2 0.458628 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 2        12 0.242965 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 3        25 0.643736 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 4        33 0.417609 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 5        46 1.251777 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 6        56 0.955127 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 7        58 0.490031 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 8        59 0.415261 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 9        62 0.302394 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## 10       71 4.322222 0 0 0 0 0 0 0 0  0  0  0  0  0  0  0
## ..      ...      ... . . . . . . . . .. .. .. .. .. .. ..
```

## Podstawowe funkcje - separate (1)

Funkcja separate służy do zastąpienia istniejacej kolumny nowymi, które powstały na podstawie podziału wejściowej kolumny. Najczęściej z taką sytuacją mamy do czynienia w przypadku gdy kolumny są typu znakowego/napisami.

Funkcja separate ma następujące argumenty:
- data - zbiór wejściowy
- col - kolumna, która ma zostać rozdzielona
- into - wektor z nazwami kolumn, które mają powstać w wyniku podziału zmiennej określonej w col
- sep - separator według, którego chcemy podzielić daną kolumnę
- remove - (logiczna) czy chcemy usunąć rozdzielaną kolumnę ze zbioru danych 
- extra - co zrobić jeżeli liczba kolumn nie zgadza się z liczbą założoną w argumencie into

## Podstawowe funkcje - separate (2)

Poniżej przykład jak działa funkcja separate:


```r
df <- data.frame(x = c("a.b", "a.d", "b.c"))
df %>% separate(x, c("A", "B"))
```

```
##   A B
## 1 a b
## 2 a d
## 3 b c
```

```r
df <- data.frame(x = c("a_b_c", "a_d_d", "b_c_g"))
df %>% separate(x, c("A", "B","C"),'_')
```

```
##   A B C
## 1 a b c
## 2 a d d
## 3 b c g
```

## Podstawowe funkcje - separate (3)

Przetestujmy teraz działanie funkcji na podstawie danych z Diagnozy Społeczniej


```r
gosp_subset %>%
  select(numer_gd,WAGA_GD_2000:WAGA_GD_2013) %>%
  gather(Weight,Value,-numer_gd)
```

```
## Source: local data frame [166,628 x 3]
## 
##    numer_gd       Weight     Value
## 1         1 WAGA_GD_2000 0.8441222
## 2         2 WAGA_GD_2000 1.2796800
## 3         3 WAGA_GD_2000 1.0427392
## 4         4 WAGA_GD_2000 1.2796800
## 5         5 WAGA_GD_2000 1.2796800
## 6         6 WAGA_GD_2000 0.4910772
## 7         7 WAGA_GD_2000 1.1785853
## 8         8 WAGA_GD_2000 0.7591435
## 9         9 WAGA_GD_2000 1.0264100
## 10       10 WAGA_GD_2000 1.3996500
## ..      ...          ...       ...
```

## Podstawowe funkcje - separate (4)

Rozdzielmy teraz kolumnę weight na trzy nowe kolumny


```r
gosp_subset %>%
  select(numer_gd,WAGA_GD_2000:WAGA_GD_2013) %>%
  gather(Weight,Value,-numer_gd) %>%
  separate(Weight,c('Weight','GD','YEAR'),sep = '_')
```

```
## Source: local data frame [166,628 x 5]
## 
##    numer_gd Weight GD YEAR     Value
## 1         1   WAGA GD 2000 0.8441222
## 2         2   WAGA GD 2000 1.2796800
## 3         3   WAGA GD 2000 1.0427392
## 4         4   WAGA GD 2000 1.2796800
## 5         5   WAGA GD 2000 1.2796800
## 6         6   WAGA GD 2000 0.4910772
## 7         7   WAGA GD 2000 1.1785853
## 8         8   WAGA GD 2000 0.7591435
## 9         9   WAGA GD 2000 1.0264100
## 10       10   WAGA GD 2000 1.3996500
## ..      ...    ... ..  ...       ...
```

## Podstawowe funkcje - extract_numeric

W pakiecie znajduje się również funkcja do ekstrakcji numerów z kolumn. Poniżej przykład z funkcji separate.


```r
gosp_subset %>%
  select(numer_gd,WAGA_GD_2000:WAGA_GD_2013) %>%
  gather(Weight,Value,-numer_gd) %>%
  mutate(Year = extract_numeric(Weight))
```

```
## Source: local data frame [166,628 x 4]
## 
##    numer_gd       Weight     Value Year
## 1         1 WAGA_GD_2000 0.8441222 2000
## 2         2 WAGA_GD_2000 1.2796800 2000
## 3         3 WAGA_GD_2000 1.0427392 2000
## 4         4 WAGA_GD_2000 1.2796800 2000
## 5         5 WAGA_GD_2000 1.2796800 2000
## 6         6 WAGA_GD_2000 0.4910772 2000
## 7         7 WAGA_GD_2000 1.1785853 2000
## 8         8 WAGA_GD_2000 0.7591435 2000
## 9         9 WAGA_GD_2000 1.0264100 2000
## 10       10 WAGA_GD_2000 1.3996500 2000
## ..      ...          ...       ...  ...
```

## Więcej informacji

- http://cran.r-project.org/web/packages/tidyr/vignettes/tidy-data.html
- http://stackoverflow.com/questions/tagged/r+tidyr?sort=active&pageSize=50


