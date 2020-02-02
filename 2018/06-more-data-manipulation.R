library(tidyverse)
library(historydata)
data("dijon_prices")
data("dijon_prices_wide")
data("us_state_populations")
data("judges_appointments")
data("judges_people")

# tidyr verbs
# ---------------------------------------------------------
## Format for using gather(). Uncomment the lines below
# dijon_prices_wide %>%
#   gather(COLUMN_NAMES, key = "", value = "", convert = LOGICAL)

## Format for using spread(). Uncomment the lines below.
## Try putting the years across the top then the states across the top
# us_state_populations %>%
#   spread(key = KEY, value = POPULATION)

# joins
# ---------------------------------------------------------
data("judges_appointments")
data("judges_people")
judges_appointments
judges_people

## Use a left join
scotus <- c(3001, 1256, 2362, 865, 255, 26, 2243, 3289, 3125)
judges_people %>%
  filter(judge_id %in% scotus) %>%
  left_join(judges_appointments)
