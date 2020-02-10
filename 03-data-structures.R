# Data structures

# Some preliminary setup which we need not concern ourselves with now
library(tidyverse)
library(historydata)
years <- sarna %>%
  filter(estimate == "population_high") %>%
  pull(year)
jewish_pop <- sarna %>%
  filter(estimate == "population_high") %>%
  pull(value)
names(jewish_pop) <- years
sim <- matrix(round(runif(25), 2), nrow = 5)
colnames(sim) <- letters[1:5]
rownames(sim) <- letters[1:5]
data("early_colleges")
data("sarna")

# Vectors
# ----------------------------------------------------------------
# A sample vector
jewish_pop

# Get the first value
jewish_pop[1]

# Get the tenth value


# How many values are there?
length(jewish_pop)

# How do I get the last value?


# Get the named value for 1800
jewish_pop["1800"]

# Is the population greater than 1,000,000
jewish_pop > 1e6

# Years where the population was greater than 1,000,000
jewish_pop[jewish_pop > 1e6]

# Get the years where the population is less than 100,000

# Matrices
# ----------------------------------------------------------------
#A sample matrix
sim

# The first two rows and the first two columns
sim[1:2, 1:2]

# Get just the third column


# Get just fourth and fifth columns and rows


# What is the difference here?
sim[, 2, drop = FALSE]

# Get a value in a cell
sim[[2, 2]]


# Data frame
# ---------------------------------------------------------------
# A sample data frame
early_colleges

# Get the college name, three ways
early_colleges[ , 1]
early_colleges[ , "college"]
early_colleges$college

# Was the college founded in or before 1700?
early_colleges$established <= 1700

# Data frame of colleges founded before 1700
early_colleges[early_colleges$established <= 1700, ]

# Create a dataframe of colleges for a particular denomination


# Create a dataframe of colleges for a particular state


# Create a dataframe of colleges for a particular state and denomination


# Lists
# --------------------------------------------------------------
# A sample list

clio2 <- list(
  course_num = 697,
  prefix = "HIST",
  title = "Computational History",
  students = c("Alice", "Bob", "Cathy", "David")
)

# Subsetting the list various ways
clio2[3]
clio2[[3]]
clio2$title
clio2[1:3]
clio2$students
clio2$students[1:2]

# Create a list to describe yourself

