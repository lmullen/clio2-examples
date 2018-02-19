# Clio 2 week 5 in-class notes

library(tidyverse)
library(historydata)
library(ggthemes)
library(stringr)
library(RColorBrewer)

us_state_populations <- us_state_populations %>%
  mutate(territory = str_detect(state, "Territory"))

# An example of making a presentation ready graphic
# ---------------------------------------------------------
ggplot(us_state_populations,
       aes(x = year, y = population, color = territory)) +
  geom_line(aes(group = state), alpha = 0.8) +
  scale_x_continuous(breaks = seq(1800, 2000, by = 25)) +
  scale_y_log10(breaks = scales::log_breaks(n = 9),
                labels = scales::comma) +
  scale_color_brewer(type = "qual",
                     name = NULL,
                     labels = c("State", "Territory")) +
  geom_smooth(se = FALSE, color = "red") +
  labs(title = "U.S. state populations",
       subtitle = "Some are big and some are small. They all get bigger and seldom shrink, if ever.",
       x = NULL,
       y = "Population",
       caption = "Source: NHGIS") +
  annotate(geom = "text", x = 1880, y = 10000,
           label = "Territories are represented separately",
           hjust = 0) +
  annotate(geom = "text", x = 1980, y = 30e6,
           label = "California is a juggernaut",
           hjust = 1) +
  annotation_logticks() +
  theme_bw() +
  theme(legend.position = "bottom")

# A different approach
# ---------------------------------------------------------
new_england <- us_state_populations %>%
  filter(state %in% c("Massachusetts", "Vermont", "New Hampshire",
                      "Maine", "Connecticut", "Rhode Island"))

new_england_labels <- new_england %>%
  group_by(state) %>%
  top_n(1, population)

ggplot(new_england,
       aes(x = year, y = population, group = state)) +
  geom_line() +
  geom_text(data = new_england_labels,
            aes(x = 2012, y = population, label = state),
            hjust = 0) +
  scale_x_continuous(limits = c(1790, 2050),
                     breaks = seq(1800, 2010, by = 25)) +
  labs(title = "New England state populations")


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

# Get just the SCOTUS appointments and count the presidential appointments
judges_appointments %>%
  filter(str_detect(court_name, "Supreme Court of the United States")) %>%
  count(president_name, sort = TRUE)

# Can you count the appointments by race to the judiciary? You will have to
# bring in the information about the judges from the `judges_people` table using
# `left_join(by = c("COLUMN NAMES")`.
