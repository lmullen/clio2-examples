library(tidyverse)
library(modelr)
library(parsnip)
library(dials)
library(tidymodels)

# Example from https://r4ds.had.co.nz/model-basics.html

# Sample data
sim1

# Guessing at a model
ggplot(sim1, aes(x, y)) +
  geom_abline(intercept = 5, slope = 1, color = "red") +
  geom_point()

# An example of a model as a function
model_guess <- function(x, slope, intercept) {
  y = slope * x + intercept
  return(y)
}
model_guess(x = 5, slope = 2, intercept = 3)

# The best model that is a line
ggplot(sim1, aes(x, y)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = "lm", se = FALSE)

# Training the model with R
sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)
summary(sim1_mod)

# More data we might care about
unknown <- tibble(x = c(4, 10, 5, 6, 7), y = rep(NA_real_, 5))
unknown

predict(sim1_mod, unknown)
model_guess(unknown$x, slope = 2.051533, intercept = 4.220822)

# --------------------------------------------
# An supervised classifications
# --------------------------------------------

training <- read_csv("apb-training.csv") %>%
  mutate(match = as.factor(match))
testing <- read_csv("apb-testing.csv") %>%
  mutate(match = as.factor(match))

# What does the data look like?
ggplot(training, aes(x = tokens, y = tfidf, color = match)) +
  geom_point(alpha = 0.5, shape = 1) +
  theme_bw()

data_recipe_all <- recipe(match ~ ., data = training) %>%
  step_center(all_numeric()) %>%
  step_scale(all_numeric()) %>%
  prep(training = training, retain = TRUE)

training_normalized <-  bake(data_recipe_all, new_data = training)
testing_normalized <-  bake(data_recipe_all, new_data = testing)

logistic_spec <- logistic_reg(mode = "classification") %>%  set_engine("glm")

model <- logistic_spec %>%
  fit(match ~ tokens, data = training_normalized)

# Accuracy on training data
results <- training_normalized %>%
  mutate(pred_class = predict(model, training_normalized, type = "class")$.pred_class,
         pred_probs = predict(model, training_normalized, type = "prob")$.pred_quotation) %>%
select(match, starts_with("pred_"), everything())
results

# Measure the results
results %>% conf_mat(truth = match, estimate = pred_class)
results %>% roc_auc(truth = match, pred_probs)


# Testing data
results_testing <- testing_normalized %>%
  mutate(pred_class = predict(model, testing_normalized, type = "class")$.pred_class,
         pred_probs = predict(model, testing_normalized, type = "prob")$.pred_quotation) %>%
select(match, starts_with("pred_"), everything())

results_testing

results_testing %>% conf_mat(truth = match, estimate = pred_class)
results_testing %>% roc_auc(truth = match, pred_probs)

