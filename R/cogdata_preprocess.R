#' Read WearIT Survey data ----
#' 
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
#' @importFrom jsonlite fromJSON
#' @importFrom stringi stri_sub
#' @param data_path data path containing cogtest results export
cogdata_preprocess <- function(data_path) {
  # create data collection of M2C2 cogtest data ----
  cogtasks = list_csvs_bytype(data_path = data_path, 
                                    types=c("cog"))
  
  # read cog task data ----
  # pass in col names for easy processing thereafter
  tryCatch(
    expr = {
      cogtasks_df = read_csv(cogtasks$nonkey_files)
      message('[✅] SUCCESS | `read_csv(cogtasks$nonkey_files)`')
    },
    error = function(e){
      message('[❌] ERROR | `read_csv(cogtasks$nonkey_files)`')
      print(e)
    },
    warning = function(w){
      message('[⚠️] WARNING | `read_csv(cogtasks$nonkey_files)`')
      print(w)
    },
    finally = {
      message('[✅] EXECUTION COMPLETE |  `read_csv(cogtasks$nonkey_files)`')
    }
  )

  if(exists("cogtasks_df")) {
    names(cogtasks_df) <- c("wearit_uuid", "cogtask_json_raw",
                            "m2c2_cogtask", "participant_id",
                            "device_model", "device_os", 
                            "survey_date_submitted", "survey_date_completed")
    # apply simple filtering logic for JSON schema ----
  cogtasks_df_p = cogtasks_df %>%
    mutate(cogtask_json = gsub("\\\\", "", `cogtask_json_raw`)) %>% # fix backslash problem
    mutate(extract_firstchar = stringi::stri_sub(`cogtask_json_raw`,1,1)) %>%
    mutate(extract_lastchar = stringi::stri_sub(`cogtask_json_raw`,-1)) %>%
    mutate(format_valid = ifelse(extract_firstchar == "[" & extract_lastchar == "]", TRUE, FALSE))
  } else {
    cogtasks_df_p = tibble(error="issue with read_csv(cogtasks$nonkey_files)",
                           format_valid=FALSE)
  }

  
  return(cogtasks_df_p)
}
