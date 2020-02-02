library(tidyverse)
library(textreuse)
library(tokenizers)

url <- "http://lincolnmullen.com/files/field-code-sample.zip"
download.file(url, "field-code-sample.zip")
unzip("field-code-sample.zip")

minhash <- minhash_generator(n = 240, seed = 84829)
lsh_threshold(240, 80)

corpus <- TextReuseCorpus(dir = "field-code-sample",
                          tokenizer = tokenizers::tokenize_ngrams,
                          n = 5, simplify = TRUE,
                          minhash_func = minhash, keep_tokens = TRUE)

# Warnings are inconsequential and expected
warnings()

doc_ny <- corpus[["NY1850-019700"]]
doc_ca <- corpus[["CA1851-004550"]]

content(doc_ny) == content(doc_ca)
intersect(tokens(doc_ny), tokens(doc_ca))
intersect(hashes(doc_ny), hashes(doc_ca))

microbenchmark(jaccard_similarity(doc_ny, doc_ca), unit = "eps")

# Make comparisons pairwise
cf_sample <- pairwise_compare(sample(corpus, 20), jaccard_similarity)
cf_sample %>% round(2) %>% View

# The line below will take a long time to run
pairwise_compare(corpus, jaccard_similarity)

buckets <- lsh(corpus, bands = 80)
candidates <- lsh_candidates(buckets)
candidates %>% View

# Now run the many fewer comparisons
cf <- lsh_compare(candidates_original, corpus, jaccard_similarity)
View(cf)

# Helper  function
get_code <- function(x) { stringr::str_extract(x, "\\w{2}\\d{4}") }

matches <- cf %>%
  mutate(code_a = get_code(a),
         code_b = get_code(b)) %>%
  filter(code_a != code_b,
         score > 0.1) %>%
  group_by(a) %>%
  top_n(1, score)
View(matches)

# Local alignment
align_local(doc_ny, doc_ca)
align_local(corpus[["NY1850-006610"]], corpus[["CA1851-000120"]])
