#' Read WearIT Survey data ----
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
#' @importFrom rlist list.append
#' @param fn path to .csv data file
#' @param col_names ???
#' @param output type of table to be produced. Options include "key_table" 
#' (produces list of question numbers, questions, and variable names/labels), "tidy_data" 
#' (produces list including all data), or c("key_table", "tidy_data") to produce both. 
#' @details None
read_surveydata <- function(fn, col_names=NA, output = c("key_table", "tidy_data"), use_labels=TRUE) {
  # read in survey data with all headers ----
  if(is.na(col_names)) {
    raw_df <- read_csv(fn, skip = 0, na = c("", "NA", "N/A"), 
    col_types = cols(.default = "c"))
  } else {
    raw_df <- read_csv(fn, skip = 0, col_names = col_names, 
    na = c("", "NA", "N/A"), col_types = cols(.default = "c"))
  }
  # read header all the ways ----
  tb_names_onread <- names(raw_df)
  tb_names_label <- raw_df[1,] %>% unlist(.)
  tb_names_ques <- raw_df[2,] %>% unlist(.)
  first3_cols <- c(tb_names_ques[1], tb_names_ques[2], tb_names_ques[3], tb_names_ques[4])
  
  # create tidied headers ---
  cols_for_keymerge_num = unname(c(first3_cols, tb_names_onread[5:length(tb_names_onread)]))
  cols_for_keymerge_ques = unname(c(first3_cols, tb_names_ques[5:length(tb_names_ques)]))
  cols_for_keymerge_labels = unname(c(first3_cols, tb_names_label[5:length(tb_names_label)]))
  
  # create modified lookup table with tidied headers ----
  new_key_table = tibble(wearit_col_qnum = cols_for_keymerge_num, 
                         wearit_col_ques = cols_for_keymerge_ques, 
                         wearit_col_label = cols_for_keymerge_labels) %>%
    arrange(wearit_col_label)
  
  # create new data file ----
  # read in the file again, now with the clean tidied headers of choice (labels, num, ques)
  if(use_labels) {
    final_df <- read_csv(fn, skip = 3, col_names = cols_for_keymerge_labels, 
              na = c("", "NA", "N/A"), col_types = cols(.default = "c"))
  } else {
    final_df <- read_csv(fn, skip = 3, col_names = cols_for_keymerge_num, 
              na = c("", "NA", "N/A"), col_types = cols(.default = "c"))
  }
  # build output list ----
  # check for any missing
  if(is.null(output) | length(output) == 0 | is.na(output)) {
    print("TEST: is.null(), length == 0, is.na()")
    out_list <- final_df # by default return data.frame
  } else {
    out_list <- list()
    if("key_table" %in% output) {
      out_list <- list.append(out_list, key_table = new_key_table)
    }
    if("tidy_data" %in% output) {
      out_list <- list.append(out_list, tidy_data = final_df)
    }
  }
  
  return(out_list)
}