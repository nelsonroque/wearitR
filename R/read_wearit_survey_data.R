# @export
read_wearit_survey <- function(fn) {
  # read in survey data with all headers ----
  raw_df <- read_csv(fn, skip = 0)
  
  # Beeped_Survey_1_key <- read_csv("Downloads/wear_it_data_v2/Beeped_Survey_1_key.csv", col_names = c('key', 'value')) %>%
  #   mutate(question_label = grepl("Q_", key)) %>%
  #   mutate(wearit_col_qnum = ifelse(question_label == T, key, NA))
  # 
  
  # read header all the ways ----
  tb_names_onread = names(raw_df)
  tb_names_label = raw_df[1,] %>% unlist(.)
  tb_names_ques = raw_df[2,] %>% unlist(.)
  first3_cols = c(tb_names_ques[1], tb_names_ques[2], tb_names_ques[3])
  
  # create tidied headers ---
  cols_for_keymerge_num = unname(c(first3_cols, tb_names_onread[4:length(tb_names_onread)]))
  cols_for_keymerge_ques = unname(c(first3_cols, tb_names_ques[4:length(tb_names_ques)]))
  cols_for_keymerge_labels = unname(c(first3_cols, tb_names_label[4:length(tb_names_label)]))
  
  # create modified lookup table with tidied headers ----
  new_key_table = tibble(wearit_col_qnum = cols_for_keymerge_num, 
                         wearit_col_ques = cols_for_keymerge_ques, 
                         wearit_col_label = cols_for_keymerge_labels) %>%
    arrange(wearit_col_label)
  
  # create new data file ----
  # read in the file again, now with the clean tidied headers of choice (labels, num, ques)
  final_df <- read_csv(fn, skip = 3, col_names = cols_for_keymerge_labels)
  
  return(list(keytable = new_key_table, 
              clean_data = final_df))
}