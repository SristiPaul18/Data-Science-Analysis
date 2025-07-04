library(readr)
library(tm)
library(topicmodels)
library(stopwords)
library(slam)

news_data <- read_csv("D:/UNIVERSITY/10TH  SEMESTER, 2024-2025, SPRING/INTRODUCTION TO DATA SCIENCE/ids_final_project_group_02_news_cleanL.csv")

dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.98)
dtm <- dtm[row_sums(dtm) > 0, ]
rownames(dtm) <- paste0("Doc_", seq_len(nrow(dtm)))

num_topics <- 10
lda_model <- LDA(dtm, k = num_topics, control = list(seed = 1234))

top_words <- terms(lda_model, 10)
View(top_words)  

term_probs <- posterior(lda_model)$terms

for (topic in 1:num_topics) 
{
  cat(sprintf("Topic %d:\n", topic))
  top_terms <- sort(term_probs[topic, ], decreasing = TRUE)[1:10]
  for (term in names(top_terms)) {
    cat(sprintf("  \"%s\" — %.4f\n", term, top_terms[term]))
  }
  cat("\n")
}

doc_topic_probs <- posterior(lda_model)$topics
term_topic_probs <- posterior(lda_model)$terms
doc_term_probs <- doc_topic_probs %*% term_topic_probs
View(doc_term_probs)  