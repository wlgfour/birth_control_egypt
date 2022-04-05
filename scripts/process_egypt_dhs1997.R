url <- 'https://dhsprogram.com/pubs/pdf/FR167/FR167.pdf'
pdffile <- 'inputs/egypt_1997.pdf'

download.file(url, pdffile)


library(pdftools)
library(tidyverse)

eg_1997 <- pdf_text(pdffile)
egypt <- tibble(raw_data = eg_1997)

header <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(6:8)

urban_rural <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(10:12)

residence <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(15:21)

age <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(24:30)

living_children <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(33:37)

education <- egypt |>
  slice(22) |>
  separate_rows(raw_data, sep = "\\n", convert = FALSE) |>
  slice(39:44)
