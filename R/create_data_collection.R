#' Read WearIT Survey data ----
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
create_data_collection <- function(data_path=NA, types=c()) {
  
  if(is.na(data_path)) {
    stop("Oops - no `data_path` supplied")
  } else {
    fns <- get_data_fns(data_path)
    if(length(types) == 0) {
      target_files = fns[grepl("key", fns)]
    } else {
      target_files <- c()
      for(i in types) {
        print(i)
        print(":::::::::::")
        target_files = c(target_files, fns[grepl(i, fns)])
        print(target_files)
      }
      
      ## Find all key and non-key files (used for auto-merging)
      key_files <- target_files[grepl("_key", target_files)]
      nonkey_files <- target_files[!grepl("_key", target_files)]
      if(length(key_files) == 0) {
        message("No `Wear-IT` key files found. Subsequent linking operations via `wearitR` may be limited. Download key file (if necessary) from Wear-IT Platform.")
      }
    }
  }
  
  return(list(all_files = fns,
              key_files = key_files,
              nonkey_files = nonkey_files,
              target_files = target_files))
}