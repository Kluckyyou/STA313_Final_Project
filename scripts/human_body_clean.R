library(dplyr)
library(tidyr)
data <- read.csv("C:/Users/q2900/Downloads/NPRI-INRP_ReleasesRejets_1993-present.csv", fileEncoding = "latin1")
cleaned_data <- data %>%
  select(
    Reporting_Year,             
    PROVINCE,   
    Facility_Nam,               
    `Substance.Name..English.`,  
    Quantity,                   
    Units,                       
    Estimation_Method            
  )
cleaned_data <- cleaned_data %>%
  drop_na()

#Choose top 15 substance
top_substances <- data %>%
  group_by(`Substance.Name..English.`) %>%
  summarize(Count = n()) %>%
  arrange(desc(Count)) %>%
  slice(1:15) 
print(top_substances)


substances_of_interest <- c(
  "PM2.5 - Particulate Matter <= 2.5 Micrometers",
  "PM10 - Particulate Matter <= 10 Micrometers",
  "Nitrogen oxides (expressed as nitrogen dioxide)",
  "Volatile Organic Compounds (VOCs)",
  "Carbon monoxide",
  "Sulphur dioxide",
  "Lead (and its compounds)",
  "Manganese (and its compounds)",
  "Zinc (and its compounds)",
  "Toluene",
  "Methanol",
  "Ammonia (total)"
)
filtered_data <- cleaned_data %>%
  filter(`Substance.Name..English.` %in% substances_of_interest)
write_csv(human_body_data, "human_body_data.csv")
