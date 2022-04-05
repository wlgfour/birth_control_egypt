#### Preamble ####
# Purpose: Read the 1997 DHS survery from egypt and extract the full-page table
#          about birth control. Clean the data, and save approapraite subsets
#          of the table to the outputs directory.
# Author: William Gerecke
# Email: wlgfour@gmail.com
# Date: 4/2/2022
# Prerequisites: R software
# Notes: This script has a line to download the pdf report, but there is a bug
# so the line is commented out.



# data paths
url <- 'https://dhsprogram.com/pubs/pdf/FR167/FR167.pdf'
pdffile <- 'inputs/egypt_1997.pdf'

# downlaod the pdf. it stores it as a weird format, so manually donwloading is
# more reliable
#download.file(url, pdffile)


library(pdftools)
library(tidyverse)
library(stringr)
library(tidyr)
library(dplyr)

# load the pdf
eg_1997 <- pdf_text(pdffile)
egypt <- tibble(raw_data = eg_1997)

# get the header of the table
header <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(6:8)

# manual transcription of header columns
header_cols = c(
  "Background Characteristics",
  "Any Method 1988", "Any Method 1992", "Any Method 1995", "Any Method 1997",
  "Pill 1988", "Pill 1992", "Pill 1995", "Pill 1997",
  "IUD 1988", "IUD 1992", "IUD 1995", "IUD 1997",
  "Injectables 1988", "Injectables 1992", "Injectables 1995", "Injectables 1997")


# process the rows of the larger table so that they can be parsed
etable <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(11:44) |>
  mutate(raw_data = str_replace_all(raw_data, "A", ".4") |>
           str_replace_all("[~,]", ".") |>
           str_replace_all("^[ ]+", ".") |>
           str_replace_all("([a-zA-Z]) ([a-zA-Z])", "\\1.\\2")) |>
  separate(col = raw_data, 
           into = header_cols, 
           sep = "[ ]+", 
           remove = FALSE,
           fill = "right"
  ) |>
  drop_na()

write.csv(file='inputs/raw_table.csv', etable, row.names = FALSE)


# parse the sub-tables

urban_rural <- etable |>
  slice(1:2) |>
  subset(select=-raw_data)
urban_rural_long <- urban_rural |>
  gather('method_year', 'percentage', header_cols[2:length(header_cols)]) |>
  separate(method_year, c('Method', 'Year'), sep=' 1') |>
  mutate(Year = paste('1', Year, sep=''))

residence <- etable |>
  slice(3:9) |>
  subset(select=-raw_data)
residence$`Background Characteristics` <-
  c('Urban Governates',
    'Lower Egypt', 'Lower Urban', 'Lower Rural',
    'Upper Egypt', 'Upper Urban', 'Upper Rural')
residence_long <- residence |>
  gather('method_year', 'percentage', header_cols[2:length(header_cols)]) |>
  separate(method_year, c('Method', 'Year'), sep=' 1') |>
  mutate(Year = paste('1', Year, sep=''))

age <- etable |>
  slice(10:16) |>
  subset(select=-raw_data)
age_long <- age |>
  gather('method_year', 'percentage', header_cols[2:length(header_cols)]) |>
  separate(method_year, c('Method', 'Year'), sep=' 1') |>
  mutate(Year = paste('1', Year, sep=''))

living_children <- etable |>
  slice(17:21) |>
  subset(select=-raw_data)
living_children_long <- living_children |>
  gather('method_year', 'percentage', header_cols[2:length(header_cols)]) |>
  separate(method_year, c('Method', 'Year'), sep=' 1') |>
  mutate(Year = paste('1', Year, sep=''))

education <- etable |>
  slice(22:27) |>
  mutate(`Background Characteristics` = c('No Education', 'Some Primary', 'Some Secondary', 'Higher')) |>
  subset(select=-raw_data)
education_long <- education |>
  gather('method_year', 'percentage', header_cols[2:length(header_cols)]) |>
  separate(method_year, c('Method', 'Year'), sep=' 1') |>
  mutate(Year = paste('1', Year, sep=''))


# write the tables to the outputs directory
write.csv(file='outputs/wide/urban_rural.csv', urban_rural, row.names = FALSE)
write.csv(file='outputs/wide/residence.csv', residence, row.names = FALSE)
write.csv(file='outputs/wide/age.csv', age, row.names = FALSE)
write.csv(file='outputs/wide/living_children.csv', living_children, row.names = FALSE)
write.csv(file='outputs/wide/education.csv', education, row.names = FALSE)

# write the long tables to the outputs directory
write.csv(file='outputs/long/urban_rural.csv', urban_rural_long, row.names = FALSE)
write.csv(file='outputs/long/residence.csv', residence_long, row.names = FALSE)
write.csv(file='outputs/long/age.csv', age_long, row.names = FALSE)
write.csv(file='outputs/long/living_children.csv', living_children_long, row.names = FALSE)
write.csv(file='outputs/long/education.csv', education_long, row.names = FALSE)

