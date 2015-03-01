### get eurostat data
library(devtools)
install_github('rOpenGov/eurostat')
library(eurostat)
library(countrycode)
library(lubridate)
library(stringi)
library(ggvis)

toc <- getEurostatTOC()
head(toc)
grepEurostatTOC("buildings", type = "dataset")
grepEurostatTOC("buildings", type = "table")

d <- grepEurostatTOC("constru", type = "table")

## House price index (2010 = 100) - quarterly data - teicp270
## House price index - deflated  - tipsho10

## tables
## Construction cost of new residential buildings - teiis510
## House price index (2010 = 100) - quarterly data  - teicp270

### datasets
## House price index (2010 = 100) - prc_hpi_a, prc_hpi_q, prc_hpi_inw, ei_hppi_q

### teicp270 - no data for Poland?
tmp <- get_eurostat('teicp270')
tmp$country <- countrycode(tmp$geo,'iso2c','country.name')
tmp <- tmp %>%
  dplyr::filter(country == 'Poland',
                unit == 'I2010_NSA') %>%
  ggvis(x=~time,y=~value) %>%
  layer_lines()

### check other
## typpurch - TOTAL - total, new_dw - new dwellings, exst_dw - existing dwellings
## unit - INX_Q - quarterly index, RCH_A - , RCH_Q - quarterly rate of change

# House Price Indices (HPIs) measure inflation in the residential property market. The HPI captures price changes of all kinds of residential property purchased by households (flats, detached houses, terraced houses, etc.), both new and existing. Only market prices are considered, self-build dwellings are therefore excluded. The land component of the residential property is included.
# These indices are the result of the work that National Statistical Institutes (NSIs) have been doing mostly within the framework of the Owner-Occupied Housing (OOH) pilot project coordinated by Eurostat
# HPIs are available for EU Member States, Iceland and Norway. In addition to the individual country series Eurostat produces indices for the euro-area (17 countries) and for the EU27.
# The national HPIs are produced by National Statistical Institutes, while the country-group aggregates are computed by Eurostat, by aggregating the national indices.
# The data that is released quarterly on Eurostat's website include price indices themselves as well as their rates of change compared to the same quarter of the previous year.

hpi <- get_eurostat('prc_hpi_q') %>% 
  tbl_df() %>%
  mutate(country = countrycode(hpi$geo,'iso2c','country.name'))


###  Residential construction - annual data, % of GDP

ci_gdp <- get_eurostat('tipsna50') %>%
  tbl_df() %>%
  mutate(country = countrycode(geo,'iso2c','country.name'))


