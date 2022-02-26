#' Read WearIT Survey data ----
#' @export
read_surveyconfig <- function(config_path) {
  
  # create session timestamp ----
  session_ts = str_replace_all(Sys.time(), "[[:punct:]]", "_")
  
  # read study config ----
  study_config = jsonlite::read_json(config_path)
  
  study_config$study_groupcode
    
# https://wearables.vmhost.psu.edu/wearables-survey/Survey/blockStructure?s_id=65&g_id=1035
# https://wearables.vmhost.psu.edu/wearables-survey/Survey/group/1035

  return()
}