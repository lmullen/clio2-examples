# The functions that we want to use are in the `dplyr` and `tidyr` packages for
# the most part. But since all of these packages work together, it is simplest
# just to load the `tidyverse`.
library(tidyverse)
library(historydata)

# dplyr gives us verbs to deal with data. Here is the data we are going to use.
data("paulist_missions")
paulist_missions

# 1. select(): lets us pick the columns we want.
paulist_missions %>%
  select(city, state, confessions, converts)

paulist_missions %>%
  select(-mission_number, -volume, -page)

paulist_missions %>%
  select(city, state, starts_with("date_"))

# 2. filter(): lets us select the rows we want according to some conditional
# expression. Remember, a conditional expression returns TRUE/FALSE values.
paulist_missions %>%
  filter(confessions > 10000)

paulist_missions %>%
  filter(state == "VA")

paulist_missions %>%
  filter(is.na(mission_number))

# 3. arrange(): lets us sort according to a column
paulist_missions %>%
  select(church, date_start, confessions, converts) %>%
  arrange(confessions)

paulist_missions %>%
  select(church, date_start, confessions, converts) %>%
  arrange(desc(converts))

# 4. mutate(): lets us add new columns based on existing columns
paulist_missions %>%
  select(church, date_start, confessions, duration_days) %>%
  mutate(confessions_per_day = confessions / duration_days)

# Getting the year from a date
library(lubridate)
paulist_missions %>%
  select(church, date_start) %>%
  mutate(year = year(date_start),
         month = month(date_start),
         day = day(date_start))

# 5. summarize() and group_by(): lets us boil data down to one row
paulist_missions %>%
  summarize(confessions_total = sum(confessions, na.rm = TRUE))

# But often we want to get one row per category. Group by lets us do that
paulist_missions %>%
  group_by(state) %>%
  summarize(confessions_total = sum(confessions, na.rm = TRUE))

# We can also count the number of rows using the `n()` function.
paulist_missions %>%
  group_by(state) %>%
  summarize(missions = n(),
            confessions = sum(confessions, na.rm = TRUE))

# Grouping and count is done so frequently that there is a shortcut
paulist_missions %>%
  count(state)

# 6. pivot_longer(): Go from wide data to long (i.e., tidy) data
data("dijon_prices_wide")
dijon_prices_wide

dijon_prices_wide %>%
  pivot_longer(c(-commodity, -measure), names_to = "year", values_to = "price")


# 7. pivot_wider(): Go from long (i.e., tidy) data to wide data
dijon_prices %>%
  select(-citation, -citation_date) %>%
  filter(year <= 1572) %>%
  filter(str_detect(commodity, "wine")) %>%
  pivot_wider(names_from = year, values_from = price)

# 8. left_join(): Join two different tables together via a key
library(europop)
data("europop")
data("city_coords")
europop
city_coords

europop %>%
  filter(year == 1500,
         population > 0,
         region == "Spain") %>%
  left_join(city_coords)

# More explicitly
europop %>%
  filter(year == 1500,
         population > 0,
         region == "Spain") %>%
  left_join(city_coords, by = c("city" = "city"))
