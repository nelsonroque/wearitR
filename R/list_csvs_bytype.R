#' Read WearIT Survey data ----
#' 
#' \code{list_csvs_bytype} takes path to data folder as input and produces
#'  a list of files within the folder
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
#' @param data_path path to data file to be processed
#' @param types type of data to to target. Options include "Beeped_Survey_1", 
#' "Beeped_Survey_2","Beeped_Survey_3"...
#' @details Finds like items and produces target_files, all_files, nonkey_files (survey files),
#' and key_files (table of key, question number,...) will be useful to build pdf codebooks.
#' @return Returns a list object containing lists of files within the specified path by data
#' type (key files, nonkey files, target files, all files)
list_csvs_bytype <- function(data_path=NA, types=c()) {
  
  if(is.na(data_path)) {
    stop("Oops - no `data_path` supplied")
  } else {
    fns <- list_csvs(data_path)
    if(length(types) == 0) {
      target_files = fns[grepl("key", fns)]
    } else {
      target_files <- c()
      for(i in types) {
        target_files = c(target_files, fns[grepl(i, fns)])
      }
      
      ## Find all key and non-key files (used for auto-merging)
      key_files <- ""
      key_files <- target_files[grepl("_key", target_files)]
      nonkey_files <- target_files[!grepl("_key", target_files)]
      if(length(key_files) == 0) {
        message("No `Wear-IT` key files found. Subsequent linking operations via `wearitR` may be limited. Download key file (if necessary) from Wear-IT Platform.")
      }
    }
  }
  
  out_list = list(all_files = fns,
                  key_files = key_files,
                  nonkey_files = nonkey_files,
                  target_files = target_files)
  
  message(out_list)
  
  return(out_list)
}