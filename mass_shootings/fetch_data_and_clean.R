library(dplyr)

# download the data
URL <- 'https://docs.google.com/spreadsheets/d/e/2PACX-1vQBEbQoWMn_P81DuwmlQC0_jr2sJDzkkC0mvF6WLcM53ZYXi8RMfUlunvP1B5W0jRrJvH-wc-WGjDB1/pub?gid=0&single=true&output=csv'
df <- read.csv(URL)

# clean and filter out observations
df <- df %>%
  mutate(type = tolower(type)) %>%
  filter(
    # exclude data with no latitude
    # and longitude
    latitude != '-', longitude != '-'
  )

# save csv
write.csv(df,file='mass_shootings.csv')
