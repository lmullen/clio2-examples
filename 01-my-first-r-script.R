library(tidyverse)
library(historydata)
data("dijon_prices")

dijon_prices

View(dijon_prices)

unique(dijon_prices$commodity)

dijon_prices %>% 
  filter(commodity == "best wheat") %>% 
  View

# Filter the table for a different commodity

best_wheat <- dijon_prices %>% 
  filter(commodity == "best wheat") 

# Create a variable for a different commodity

ggplot(best_wheat, aes(x = year, y = price)) +
  geom_line() + geom_point() +
  labs(title = "Prices for best wheat in Dijon")

# Make a plot for a different commodity

two_wheats <- dijon_prices %>% 
  filter(commodity %in% c("best wheat", "good wheat"))

ggplot(two_wheats, aes(x =year, y = price, color = commodity)) +
  geom_line() + geom_point()

# Make a plot for all the wines

two_wheats %>% 
  spread(commodity, price) %>% 
  ggplot(aes(x = `best wheat`, y = `good wheat`)) +
  geom_point() + geom_smooth(method = "lm")
