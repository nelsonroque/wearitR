#' Read WearIT Survey data ----
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom dplyr bind_rows
#' @importFrom readr read_csv
#' @details Must specify which type of file to stack (key files, nonkey files, target files, or all files)
#' @return Returns stacked dataframe 
merge_csvs <- function(fns=NA, use_labels=TRUE, drop_deprecated=TRUE) {
  dfs_list = lapply(fns, read_surveydata, use_labels=use_labels, output=NA)
  dfs_stacked = bind_rows(dfs_list)
  
  if(drop_deprecated) {
    dfs_stacked_f = dfs_stacked %>%
      select(-contains("deprecated"))
  } else {
    dfs_stacked_f = dfs_stacked
  }
  return(dfs_stacked_f)
}
