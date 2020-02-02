library(tidyverse)
library(textreuse)
library(tokenizers)
library(pryr)

# Hashing always produces the same results for the same string, but tries to
# get different results for different strings
hash_string(c("1 string", "2 string"))
hash_string(c("1 string", "2 string"))

# We can tokenize a large text and hash it
tokens <- tokenize_ngrams(mobydick, n = 5, simplify = TRUE)
hashes <- hash_string(tokens)

# This results in significant space savings
object_size(mobydick)
object_size(tokens)
object_size(hashes)

# But there are fewer unique hashes than tokens because there is are collisions
tokens %>% unique %>% length()
hashes %>% unique %>% length()

# Table of hashes and tokens
md_table <- tibble(tokens = tokens, hashes = hashes) %>%
  arrange(hashes) %>%
  distinct()

collisions <- md_table %>%
  group_by(hashes) %>%
  filter(n() > 1)

# These strings collide
hash_string("first whaling port tombstones staring")
hash_string("like flexible bows bent round")
