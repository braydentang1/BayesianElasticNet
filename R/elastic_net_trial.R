library(tidyverse)
library(recipes)
library(rstan)
library(bayestestR)

my_stan_model <- stan_model(file = "elastic_net.stan")

set.seed(200350623)

df <- tibble(
  y = rnorm(100),
  x1 = rnorm(100, 5, 3),
  x2 = rnorm(100, 10, 3)
)

my_recipe <- recipe(y ~., data = df) %>%
  step_center(all_predictors()) %>%
  step_scale(all_predictors())

params <- recipes::prep(my_recipe, df)

train <- juice(params)

data_list <- list(
  x = as.matrix(train[, !names(train) %in% c("y")]),
  y = as.numeric(train$y),
  lambda_one = 3,
  lambda_two = 0.01,
  N = nrow(train),
  K = 2)

samples <- sampling(
      my_stan_model,
      data = data_list,
      iter = 11000, 
      refresh = 11000, 
      control = list(adapt_delta = 0.9999999)
      )
    
all_samples <- extract(samples)