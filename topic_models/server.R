library(topicmodels)
library(tidytext)
library(dplyr)

data('AssociatedPress')
# convert to a tibble with columns
# document (id), term, count (within each document)
ap <- tidy(AssociatedPress)
n_docs <- AssociatedPress$nrow

# for each term, compute the number of documents it
# appears in 
term_document_counts <- ap %>% 
  group_by(term) %>% count() %>% 
  rename(document_count = n) %>%
  ungroup()

# find words which appear in at least 5% of the documents
final_terms <- term_document_counts %>% 
  filter(document_count >= 0.05 * n_docs)

# get final document term matrix
ap_final_dtm <- ap %>%
  filter(term %in% final_terms$term) %>%
  cast_dtm(document, term ,count)


server <- function(input, output, session){
  lda_model_reactive <- reactive({
    LDA(ap_final_dtm, k = input$n_topics, control = list(seed=124, alpha=0.1) )
  })
  
  output$lda_vis <- LDAvis::renderVis({
    lda_model <- lda_model_reactive()
    post <- posterior(lda_model)
    mat <- lda_model@wordassignments
    
    lda_json <- LDAvis::createJSON(
      phi = post[["terms"]], 
      theta = post[["topics"]],
      vocab = colnames(post[["terms"]]),
      doc.length = slam::row_sums(mat, na.rm = TRUE),
      term.frequency = slam::col_sums(mat, na.rm = TRUE),
      R = input$n_terms_display
    )
    
    lda_json
  })
}
  


