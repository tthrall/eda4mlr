##
# oecd_bli.R
#   Prepare OECD Better Life Index data set for `eda4mldata` package
##

library(dplyr)
library(here)
library(readr)
library(tibble)
library(tidyselect)

# Read cached BLI data
oecd_bli <- readr::read_csv(
  here::here("data-raw", "oecd_bli_2015.csv"),
  show_col_types = FALSE
)

# Add country codes
country_codes <- tibble::tribble(
  ~country,           ~code,
  "Australia",        "AUS",
  "Austria",          "AUT",
  "Belgium",          "BEL",
  "Brazil",           "BRA",
  "Canada",           "CAN",
  "Chile",            "CHL",
  "Czech Republic",   "CZE",
  "Denmark",          "DNK",
  "Estonia",          "EST",
  "Finland",          "FIN",
  "France",           "FRA",
  "Germany",          "DEU",
  "Greece",           "GRC",
  "Hungary",          "HUN",
  "Iceland",          "ISL",
  "Ireland",          "IRL",
  "Israel",           "ISR",
  "Italy",            "ITA",
  "Japan",            "JPN",
  "Korea",            "KOR",
  "Luxembourg",       "LUX",
  "Mexico",           "MEX",
  "Netherlands",      "NLD",
  "New Zealand",      "NZL",
  "Norway",           "NOR",
  "Poland",           "POL",
  "Portugal",         "PRT",
  "Russia",           "RUS",
  "Slovak Republic",  "SVK",
  "Slovenia",         "SVN",
  "Spain",            "ESP",
  "Sweden",           "SWE",
  "Switzerland",      "CHE",
  "Turkey",           "TUR",
  "United Kingdom",   "GBR",
  "United States",    "USA"
)

oecd_bli <- oecd_bli |>
  dplyr::rename(country = Country) |>
  dplyr::left_join(country_codes, by = "country") |>
  dplyr::select(code, country, tidyselect::everything())

# Indicator metadata
oecd_bli_indicators <- tibble::tribble(
  ~code,       ~category,                ~indicator,                                    ~unit,       ~description,
  "CG_SENG",   "Civic Engagement",       "Stakeholder Engagement",                      "AVSCORE",   "Extent to which people can engage with government in rule-making",
  "CG_VOTO",   "Civic Engagement",       "Voter Turnout",                               "PC",        "Percent of registered voters who voted in recent elections",
  "EQ_AIRP",   "Environmental Quality",  "Air Pollution",                               "MICRO_M3",  "Concentration of PM2.5 particulate matter (micrograms per cubic meter)",
  "EQ_WATER",  "Environmental Quality",  "Water Quality",                               "PC",        "Percent satisfied with water quality",
  "ES_EDUA",   "Education",              "Educational Attainment",                      "PC",        "Percent aged 25-64 with at least upper-secondary education",
  "ES_EDUEX", "Education",              "Expected Years of Education",                 "YR",        "Expected years of schooling",
  "ES_STCS",   "Education",              "Student Cognitive Skills",                    "AVSCORE",   "PISA scores in reading, mathematics, and science",
  "HO_BASE",   "Housing",                "Dwellings without Basic Facilities",          "PC",        "Percentage of dwellings that lack basic sanitary facilities",
  "HO_HISH",   "Housing",                "Housing Expenditure",                         "PC",        "Percentage of household income spent on housing",
  "HO_NUMR",   "Housing",                "Rooms per Person",                            "RATIO",     "Number of rooms per person in dwelling",
  "HS_LEB",    "Health",                 "Life Expectancy at Birth",                    "YR",        "Average number of years a person can expect to live",
  "HS_SFRH",   "Health",                 "Self-Reported Health",                        "PC",        "Percentage who report being in good or very good health",
  "IW_HADI",   "Income and Wealth",      "Household Adjusted Disposable Income",        "USD",       "Average household income after taxes",
  "IW_HNFW",   "Income and Wealth",      "Household Net Financial Wealth",              "USD",       "Household net financial wealth (assets minus liabilities)",
  "JE_EMPL",   "Jobs",                   "Employment Rate",                             "PC",        "Percentage of people aged 15-64 in paid employment",
  "JE_LMIS",   "Jobs",                   "Labour Market Insecurity",                    "PC",        "Expected loss of earnings if someone becomes unemployed",
  "JE_LTUR",   "Jobs",                   "Long-Term Unemployment Rate",                 "PC",        "Percentage unemployed for 12+ months",
  "JE_PEARN",  "Jobs",                   "Personal Earnings",                           "USD",       "Average annual earnings per full-time employee",
  "PS_FSAFEN", "Personal Safety",        "Feeling Safe Walking Alone at Night",         "PC",        "Percentage who feel safe",
  "PS_REPH",   "Personal Safety",        "Homicide Rate",                               "RATIO",     "Deaths per 100,000 people",
  "SC_SNTWS",  "Social Connections",     "Support Network Quality",                     "PC",        "Percentage who believe they have someone to rely on in times of need",
  "SW_LIFS",   "Subjective Well-Being",  "Life Satisfaction",                           "AVSCORE",   "Average self-evaluation on a scale from 0 to 10",
  "WL_EWLH",   "Work-Life Balance",      "Employees Working Long Hours",                "PC",        "Percentage of employees working 50+ hours per week",
  "WL_TNOW",   "Work-Life Balance",      "Time Devoted to Leisure and Personal Care",  "HOUR",      "Hours per day spent on leisure, personal care, eating, and sleeping"
)

# Save to package data directory
usethis::use_data(oecd_bli, overwrite = TRUE)
usethis::use_data(oecd_bli_indicators, overwrite = TRUE)

##
#  EOF
##
