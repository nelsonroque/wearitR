#' Read WearIT Survey data ----
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom dplyr bind_rows
#' @importFrom readr read_csv
#' @details Must specify which type of file to stack (key files, nonkey files, target files, or all files)
#' @return Returns stacked dataframe 
merge_data_collection <- function(fns=NA) {
  dfs_list = lapply(fns, read_wearit_surveydata, output=NA)
  dfs_stacked = bind_rows(dfs_list)
  return(dfs_stacked)
}
