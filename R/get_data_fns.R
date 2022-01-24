#' Read WearIT Survey data ----
#' \code{get_data_fns} takes path to a data folder as input and returns list of all files
#' @param data_path path to data folder
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
get_data_fns <- function(data_path=NA) {
  if(is.na(data_path)) {
    error("Oops - no `data_path` supplied")
  } else {
    fl = list.files(pattern="*.csv", 
                    path=data_path, 
                    recursive = T, 
                    full.names = T)
    return(fl)
  }
}