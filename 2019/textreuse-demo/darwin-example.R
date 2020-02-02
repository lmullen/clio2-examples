library(tidyverse)
library(textreus)
library(tokenizers)

first <- c("This is the first sentence. I am a concluding sentence.")
second <- c("This is the first sentence. This sentence was added in the second edition. I am a concluding sentence.")

darwin <- tibble(edition = 1:2, text = c(first, second))

darwin %>%
  mutate(sentence = tokenize_sentences(text)) %>%
  select(-text) %>%
  unnest(sentence) %>%
  group_by(edition) %>%
  mutate(sentence_n = 1:n(),
         hash = hash_string(sentence)) %>%
  ungroup() %>%
  mutate(repeated = duplicated(hash),
         original_ed = if_else(repeated, edition - 1L, edition)) %>% View
