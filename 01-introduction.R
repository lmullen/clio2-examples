# An example of variables and values
a = 10
b = 20
a = b

# What does `a` equal now?
print(a)

# Loading a package that is already installed
library(tidyverse)

# Installing a package from CRAN
install.packages("remotes")
library(remotes)

# Installing a package from GitHub
remotes::install_github("ropensci/historydata")
library(historydata)

# Getting help
?presbyterians

# Printing a data frame
presbyterians

# Viewing a data frame
View(presbyterians)

# Another summary view of a data frame
glimpse(presbyterians)

# Making a simple plot
ggplot(presbyterians, aes(x = year, y = members, color = denomination)) +
  geom_point() +
  geom_line() +
  labs(title = "Presbyterian membership over time")

# Can you modify the plot so it shows churches rather than members?


# Let's try another dataset
View(dijon_prices)

# What commodities are in the dataset?
unique(dijon_prices$commodity)

# That's a lot of commodities. Let's try just one.
wheat <- dijon_prices %>%
  filter(commodity == "best wheat")

View(wheat)

ggplot(wheat, aes(x = year, y = price)) +
  geom_line() + geom_point() +
  labs(title = "Prices for best wheat in Dijon")

# Can you modify the plot to be a different commodity?

