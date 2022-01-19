#' Read WearIT Survey data ----
#' @export
get_data_fns <- function(data_path=NA) {
  if(is.na(data_path)) {
    error("Oops - no `data_path` supplied")
  } else {
    return(list.files(pattern="*.csv", path=data_path, recursive = T, full.names = T))
  }
}