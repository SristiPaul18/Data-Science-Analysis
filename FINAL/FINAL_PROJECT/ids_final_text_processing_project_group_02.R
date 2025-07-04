library(rvest)           
library(dplyr)        
library(stringr)          
library(purrr)           
library(readr)            
library(udpipe)          
library(qdapDictionaries)  
library(stringi)           
library(stopwords)        
library(tidyverse) 

categories <- list(
  Bangladesh = list(
    url = "https://www.newagebd.net/articlelist/41/bangladesh", 
    title_selector = ".h5-lg, .h3-lg a"
  ),
  Business = list(
    url = "https://www.newagebd.net/articlelist/29/business-economy",
    title_selector = ".grippy-host a, .h3-lg a, .h5-lg a, .h2-lg a"
  ),
  Entertainment = list(
    url = "https://www.newagebd.net/articlelist/27/entertainment",
    title_selector = ".h3-lg a, .h5-lg"
  ),
  Health = list(
    url = "https://www.newagebd.net/articlelist/10/health", 
    title_selector = ".h5-lg, .h3-lg a"
  ),
  Science_Tech = list(
    url = "https://www.newagebd.net/articlelist/12/science-n-technology", 
    title_selector = ".h3-lg a, .h5-lg"
  ),
  Sports = list(
    url = "https://www.newagebd.net/articlelist/22/sports", 
    title_selector = ".h5-lg, .h3-lg a"
  ),
  World = list(
    url = "https://www.newagebd.net/articlelist/31/world", 
    title_selector = ".h5-lg"
  )
)

max_pages <- 25
max_articles <- 125
all_articles <- data.frame(CATEGORY = character(),
                           TITLE = character(), 
                           DATE = character(), 
                           DESCRIPTION = character(),
                           LINK = character(), 
                           stringsAsFactors = FALSE)

for (category_name in names(categories)) 
{
  info <- categories[[category_name]]
  base_url <- info$url
  selector <- info$title_selector
  seen_titles <- character()
  page_num <- 1
  
  message("Starting Category: ", category_name)
  
  while (page_num <= max_pages & length(seen_titles) < max_articles) {
    url <- paste0(base_url, "?page=", page_num)
    message("Fetching ", "from ", category_name, " ->", " Page ", page_num)
    
    tryCatch({
      webpage <- read_html(url)
      articles <- html_elements(webpage, selector)
      message("Found ", length(articles), " Articles. ")
      
      if (length(articles) == 0) {
        message("No Articles found on Page ", page_num, " for ", category_name)
        break
      }
      
      titles <- html_text(articles, trim = TRUE)
      links <- html_attr(articles, "href")
      valid_idx <- !is.na(links) & titles != ""
      titles <- titles[valid_idx]
      links <- links[valid_idx]
      full_links <- ifelse(startsWith(links, "http"), links, paste0("https://www.newagebd.net", links))
      
      page_articles <- data.frame(TITLE = titles, LINK = full_links, stringsAsFactors = FALSE)
      new_articles <- page_articles %>% filter(!TITLE %in% seen_titles) %>% distinct(TITLE, .keep_all = TRUE)
      
      if (nrow(new_articles) == 0) {
        message("No New Unique Articles on Page ", page_num, " for ", category_name)
        break
      }
      
      space_left <- max_articles - length(seen_titles)
      if (nrow(new_articles) > space_left) {
        new_articles <- new_articles[1:space_left, ]
      }
      
      for (i in 1:nrow(new_articles)) {
        article_url <- new_articles$LINK[i]
        article_title <- new_articles$TITLE[i]
        tryCatch({
          article_page <- read_html(article_url)
          date <- article_page %>% html_element("#content time") %>% html_text(trim = TRUE)
          desc <- article_page %>% html_elements("#content p") %>% html_text(trim = TRUE) %>% paste(collapse = "\n")
          df_new <- data.frame(CATEGORY = category_name,
                               DATE = date,
                               TITLE = article_title, 
                               DESCRIPTION = desc,
                               LINK = article_url, 
                               stringsAsFactors = FALSE)
          
          all_articles <<- bind_rows(all_articles, df_new)
          seen_titles <<- c(seen_titles, article_title)
          message("Article Added to ", category_name, " -> ", article_title)
        }, error = function(e) {
          message("Failed to fetch content for: ", article_url)
        })
      }
      message("=========================================================================================")
      message("Completed Page ", page_num, " for Category ", category_name)
      message("=========================================================================================")
      
      if (length(seen_titles) >= max_articles) {
        message("Reached ", max_articles, " articles for category ", category_name)
        break
      }
      
      page_num <- page_num + 1
      Sys.sleep(0.5)
    }, error = function(e) {
      message("Error Reading ", url, ": ", conditionMessage(e))
      break
    })
  }
  
  message("Finished Scraping ", category_name, " Category with ", length(seen_titles), " Articles.")
}

write.csv(all_articles[, c("CATEGORY", "TITLE", "DATE", "DESCRIPTION", "LINK")],
          "D:/UNIVERSITY/10TH  SEMESTER, 2024-2025, SPRING/INTRODUCTION TO DATA SCIENCE/
          ids_final_project_group_02_news_raw.csv",
          row.names = FALSE)


model <- udpipe_download_model(language = "english")
ud_model <- udpipe_load_model(model$file_model)

expand_contractions <- function(text) 
{
  contractions <- qdapDictionaries::contractions
  for (i in seq_len(nrow(contractions))) {
    pattern <- paste0("\\b", contractions$contraction[i], "\\b")
    text <- gsub(pattern, contractions$expanded[i], text, ignore.case = TRUE)
  }
  return(text)
}

remove_emojis <- function(text) 
{
  text <- stri_replace_all_regex(text, "[\\p{So}\\p{Cn}]+", "")
  text <- gsub("[:;=8][-o*']?[)D(pP]", "", text)
  return(text)
}


process_text <- function(text) 
{
  text <- iconv(text, from = "UTF-8", to = "UTF-8", sub = " ")
  text <- tolower(text)
  text <- expand_contractions(text)
  text <- remove_emojis(text)
  text <- str_remove_all(text, "http[s]?://\\S+")
  text <- str_replace_all(text, "[-–—]", " ")
  text <- str_replace_all(text, "[^a-z\\s]", " ") 
  text <- str_squish(text)
  
  annotation <- udpipe_annotate(ud_model, x = text)
  
  df <- as.data.frame(annotation)
  df <- df[df$upos %in% c("NOUN", "PROPN", "ADJ"), ]
  
  lemmas <- tolower(df$lemma)
  lemmas <- lemmas[!lemmas %in% stopwords("en")]
  lemmas <- lemmas[!grepl("\\d", lemmas)]
  lemmas <- lemmas[nchar(lemmas) > 2]
  lemmas <- lemmas[grepl("^[a-z]+$", lemmas)]
  
  cleaned_text <- paste(lemmas, collapse = ", ")
  return(cleaned_text)
}

raw_data <- read.csv("D:/UNIVERSITY/10TH  SEMESTER, 2024-2025, SPRING/INTRODUCTION TO DATA SCIENCE/ids_final_project_group_02_news_raw.csv", stringsAsFactors = FALSE)
head(raw_data, 1)

cleaned <- character(length(raw_data$DESCRIPTION))

for (i in seq_along(raw_data$DESCRIPTION)) 
{
  cleaned[i] <- process_text(raw_data$DESCRIPTION[i])
  if (i %% 15 == 0) cat("Processed row", i, "\n")
}

raw_data$CLEANED_DESCRIPTION <- cleaned

write.csv(raw_data, "D:/UNIVERSITY/10TH  SEMESTER, 2024-2025, SPRING/INTRODUCTION TO DATA SCIENCE/ids_final_project_group_02_news_cleanL.csv", row.names = FALSE)
