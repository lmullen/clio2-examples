# How to read a CSV file into a data frame

# The readr package gives us a better way to read data than the built-in
# function. Note that this package is loaded when you run `library(tidyverse)`.
library(readr)
library(tibble) # For nicer printing

# We are assuming that the file is in the same directory as our current working
# directory.

# We can let readr guess the types of the columns.
prices <- read_csv("dijon-prices.csv")

# Here is the data with the column types
prices

# We can also specify exactly what kind of types of data we want
prices2 <- read_csv("dijon-prices.csv", col_types = "ccid")
