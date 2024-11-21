#### Setup ####
# load Libraries
library(lubridate)
library(dplyr)
library(readr)
library(here)

# load Data
raw_data <- read_csv(here("data", "raw_data", "NPRI-INRP_ReleasesRejets_1993-present.csv"), 
                     locale = locale(encoding = "ISO-8859-1"),
                     show_col_types = FALSE)



#### Clean Data ####
# clean columns
map_cleaned_data <- raw_data %>%
  select(
    year = `Reporting_Year / Année`,
    province = PROVINCE,
    NPRI_id = `NPRI_ID / No_INRP`,
    facility = `Facility_Name / Installation`,
    substance = `Substance Name (English) / Nom de substance (Anglais)`,
    emit_way = `Group (English) / Groupe (Anglais)`,
    quantity = `Quantity / Quantité`,
    unit = `Units / Unités`
  )

# unified unit
map_cleaned_data <- map_cleaned_data %>%
  mutate(
    # Convert quantity to grams based on the unit
    quantity = case_when(
      unit == "grams" ~ quantity,
      unit == "kg" ~ quantity * 1e3,
      unit == "tonnes" ~ quantity * 1e6,
      unit == "g TEQ" ~ quantity,
      TRUE ~ NA_real_
    ),
    # Update all units to "grams"
    unit = "grams"
  )

# data aggregation
map_cleaned_data <- map_cleaned_data %>%
  group_by(
    year,
    province,
    NPRI_id,
    facility,
    substance,
    emit_way,
    unit
  ) %>%
  summarize(
    quantity = sum(quantity, na.rm = TRUE),  # Sum the quantities, ignoring NAs
    .groups = "drop"  # Ungroup after summarizing
  )

#### Save Data ####
write_csv(map_cleaned_data, here("data", "analysis_data", "map_cleaned_data.csv"))
