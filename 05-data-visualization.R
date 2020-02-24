library(tidyverse) # loads dplyr and ggplot2
library(historydata)
library(RColorBrewer)
library(ggthemes)
data("methodists")
methodists <- as_tibble(methodists)
methodists

# Scatter plots: quantitative vs quantitative

## A smaller dataset
va <- methodists %>%
  filter(conference == "Virginia",
         year >= 1800, year <= 1810)

## The most basic plot
ggplot(va, aes(x = members_white, y = members_black)) +
  geom_point()

## With color
ggplot(va, aes(x = members_white, y = members_black, color = district)) +
  geom_point()

## Try that plot with shapes instead of colors

## With a fixed aesthetic
ggplot(va, aes(x = members_white, y = members_black, color = district)) +
  geom_point(size = 2, shape = 1)

## With labels and an appropriate coordinate system
ggplot(va, aes(x = members_white, y = members_black, color = district)) +
  geom_point() +
  coord_equal() +
  labs(x = "Number of white members",
       y = "Number of black members",
       title = "Virginia Methodists, 1800-1810",
       subtitle = "Membership totals by race, showing disparities in membership",
       color = "District",
       caption = "Clio 2, spring 2020") +
  scale_x_continuous(breaks = seq(0, 1200, by = 100)) +
  scale_y_continuous(breaks = seq(0, 600, by = 100))


# Bar plots and histograms (counts and distributions)

## geom_bar does counts
methodists_1820 <- methodists %>%
  filter(year == 1820)

ggplot(methodists_1820, aes(x = conference)) +
  geom_bar()

## geom_col uses values already in the data
methodists_alexandria <- methodists %>%
  filter(conference == "Baltimore", district == "Alexandria",
         year == 1805)

ggplot(methodists_alexandria, aes(x = meeting, y = members_total)) +
  geom_col()

## geom_histogram shows distributions
ggplot(methodists_1820, aes(x = members_total)) +
  geom_histogram()

## so does geom_freqpoly
ggplot(methodists_1820, aes(x = members_total)) +
  geom_freqpoly()

# Line plots
by_year <- methodists %>%
  group_by(year, conference) %>%
  summarize(members_total = sum(members_total, na.rm = TRUE),
            members_white = sum(members_white, na.rm = TRUE),
            members_black = sum(members_black, na.rm = TRUE)) %>%
  mutate(percent_black = members_black / members_total,
         percent_white = members_white / members_total)

# Regular line plot (notice `group` aesthetic to get multiple lines)
ggplot(by_year, aes(x = year, y = members_total, group = conference)) +
  geom_line()

# With a facet
ggplot(by_year, aes(x = year, y = members_total)) +
  geom_line() +
  facet_wrap(~conference, ncol = 4, scales = "free_y")

# Try a plot with the percentage of black members


# An example of making a presentation ready graphic
# ---------------------------------------------------------
us_state_populations <- us_state_populations %>%
  mutate(territory = str_detect(state, "Territory"))

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
