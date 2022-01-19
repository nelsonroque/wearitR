#' Read WearIT Survey data ----
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom dplyr bind_rows
#' @importFrom readr read_csv
merge_data_collection <- function(fns=NA) {
  dfs_list = lapply(fns, read_wearit_surveydata, output=NA)
  dfs_stacked = bind_rows(dfs_list)
  return(dfs_stacked)
}
