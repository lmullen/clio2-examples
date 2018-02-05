# Normally we would load the tidyverse like this
# library(tidyverse)

# But the functions we are going to use are from dplyr, so we are going to load
# just that package. We also need history data and readr.
library(dplyr)
library(readr)
library(historydata)

# dplyr gives us verbs to deal with data. Here is the data we are going to use.
data("paulist_missions")
paulist_missions

# 1. select: lets us pick the columns we want.
paulist_missions %>%
  select(city, state, confessions, converts)

# 2. filter: lets us select the rows we want according to some conditional
# expression.
paulist_missions %>%
  filter(confessions > 10000)

# 3. arrange: lets us sort according to a column
paulist_missions %>%
  select(church, date_start, confessions, converts) %>%
  arrange(desc(converts))

# 4. mutate: lets us add new columns based on existing columns
paulist_missions %>%
  select(church, date_start, confessions, duration_days) %>%
  mutate(confessions_per_day = confessions / duration_days)

# 5. summarize and group_by: lets us boil data down to one row per data frame
paulist_missions %>%
  summarize(confessions_total = sum(confessions, na.rm = TRUE))

# But often we want to get one row per category. Group by lets us do that
paulist_missions %>%
  group_by(state) %>%
  summarize(confessions_total = sum(confessions, na.rm = TRUE))

# Let's try to read in the data we created. Fill in the quotation marks with the
# path to your file. If the file is in R's working directory, the path is just
# the filename.
mydata <- read_csv("")
