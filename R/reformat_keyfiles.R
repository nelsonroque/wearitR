#' Read WearIT Survey data ----
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
#' @importFrom zoo na.locf
#' \code{reformat_keyfiles} takes keytable as input; outputs dataframe 
reformat_keyfiles <- function(fn, keytable) {
  keyfile <- read_csv(fn, 
                             col_names=c("key", "value")) %>%
    mutate(is_ques_num = grepl("Q_", key)) %>%
    mutate(wearit_col_qnum_tmp = ifelse(is_ques_num, key, NA))
  
  keyfile$wearit_col_qnum = zoo::na.locf(keyfile$wearit_col_qnum_tmp, fromLast = FALSE)
  
  # filter keyfile
  keyfile_restructured = keyfile %>%
    filter(!is_ques_num) %>%
    select(!wearit_col_qnum_tmp) %>%
    select(!is_ques_num) %>%
    full_join(keytable)
  
  return(keyfile_restructured)
}