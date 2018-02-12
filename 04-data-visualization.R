library(tidyverse) # loads dplyr and ggplot2
library(historydata)
data("methodists")
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
       caption = "Clio 2, spring 2018") +
  scale_x_continuous(breaks = seq(0, 1200, by = 100)) +
  scale_y_continuous(breaks = seq(0, 600, by = 100))


# Bar plots and histograms

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
