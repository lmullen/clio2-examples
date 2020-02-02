# An example of variables and values
a = 10
b = 20
a = b

# What does `a` equal now?
print(a)

# Loading a package that is already installed
library(tidyverse)

# Installing a package from CRAN
install.packages("devtools")
library(devtools)

# Installing a package from GitHub
devtools::install_github("ropensci/historydata")
library(historydata)

# Getting help
?presbyterians

# Printing a data frame
presbyterians

# Viewing a data frame
View(presbyterians)

# Another summary view of a data frame
glimpse(presbyerians)

# Making a simple plot
ggplot(presbyterians, aes(x = year, y = members, color = denomination)) +
  geom_point() +
  geom_line() + 
  labs(title = "Presbyterian membership over time")

# Can you modify the plot so it shows churches rather than members?

# Can you modify the plot so that it shows the number of members per church?

# There is another dataset called `us_national_population`. Can you plot it over time?

# Harder: There is another dataset called `us_state_populations`. Can you plot them over time?
