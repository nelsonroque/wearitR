#' Read WearIT Survey data ----
#' 
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
#' @importFrom jsonlite fromJSON
#' @param data_path data path containing cogtest results export
preprocess_cogtask_data <- function(data_path) {
  # create data collection of M2C2 cogtest data ----
  cogtasks = create_data_collection(data_path = data_path, 
                                    types=c("cog"))
  
  # read cog task data ----
  # pass in col names for easy processing thereafter
  cogtasks_df = read_csv(cogtasks$nonkey_files, 
                         col_names = c("wearit_uuid", "cogtask_json_raw",
                                       "m2c2_cogtask", "participant_id",
                                       "device_model", "device_os", 
                                       "survey_date_submitted", "survey_date_completed"))
  
  # apply simple filtering logic for JSON schema ----
  cogtasks_df_p = cogtasks_df %>%
    mutate(cogtask_json = gsub("\\\\", "", `cogtask_json_raw`)) %>% # fix backslash problem
    mutate(first_char = substr(`cogtask_json_raw`,1,1)) %>% # validate first character is what is expected
    mutate(format_valid = ifelse(first_char == "{", FALSE, TRUE))
  
  return(cogtasks_df_p)
}
