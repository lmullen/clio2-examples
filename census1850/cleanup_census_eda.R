library(tidyverse)
library(mullenMisc)
library(sf)
library(units)

shp <- read_sf("census1850/nhgis0055_shapefile_tl2008_us_county_1850/US_county_1850_conflated.shp")
areas <- st_area(shp)
units(areas) <- "km^2"
area <- as.numeric(areas)
st_geometry(shp) <- NULL
shp$area_sq_km <- area
shp <- shp %>%
  select(GISJOIN, area_sq_km)

raw1 <- read_csv("census1850/nhgis0054_csv/nhgis0054_ds9_1850_county.csv",
                 col_types = cols(
                   .default = col_integer(),
                   GISJOIN = col_character(),
                   STATE = col_character(),
                   STATEA = col_character(),
                   COUNTY = col_character(),
                   COUNTYA = col_character(),
                   AREANAME = col_character()
                 ))
raw2 <- read_csv("census1850/nhgis0054_csv/nhgis0054_ds10_1850_county.csv",
                 col_types = cols(
                   .default = col_integer(),
                   GISJOIN = col_character(),
                   STATE = col_character(),
                   STATEA = col_character(),
                   COUNTY = col_character(),
                   COUNTYA = col_character(),
                   AREANAME = col_character()
                 ))

# One file has 10 more counties than the other
raw_all <- left_join(raw2, raw1) %>%
  gather(-GISJOIN, -YEAR, -STATE, -STATEA, -COUNTY, -COUNTYA, -AREANAME,
         key = "key", value = "value")

# codebook1 <- parse_nhgis_codebook("census1850/nhgis0054_csv/nhgis0054_ds9_1850_county_codebook.txt")
# codebook2 <- parse_nhgis_codebook("census1850/nhgis0054_csv/nhgis0054_ds10_1850_county_codebook.txt")

# codebook_raw <- bind_rows(codebook1, codebook2)
# write_csv(codebook_raw, "census1850/codebook_cleaned.csv")

codebook <- read_csv("census1850/census_1850_codebook.csv") %>%
  select(code, col_name)

census_1850 <- raw_all %>%
  left_join(codebook, by = c("key" = "code")) %>%
  select(-key) %>%
  spread(col_name, value) %>%
  left_join(shp, by = "GISJOIN") %>%
  select(GISJOIN, YEAR, STATE, STATEA, COUNTY, COUNTYA, AREANAME, area_sq_km,
         population_total, starts_with("population_"),
         starts_with("nativity_"),
         starts_with("farms_"), starts_with("livestock_"), starts_with("crops_"),
         starts_with("learning_"), starts_with("students"),
         starts_with("churches_"),
         starts_with("births_"), starts_with("marriages_"), starts_with("deaths_"),
         starts_with("sex_"), starts_with("age_"), starts_with("sexage_"),
         everything()) %>%
  filter(!is.na(population_total) & !is.na(area_sq_km))

write_csv(census_1850, "census1850/census_1850_data.csv")
