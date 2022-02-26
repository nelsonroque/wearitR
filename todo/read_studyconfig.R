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

# configure API endpoints
base_url = "https://wearables.vmhost.psu.edu/wearables-survey/Survey/"

# read json from Wear-IT Platform
group_code = "1035"

# read study data
meta_api = glue::glue("{base_url}group/{group_code}")
m_df = jsonlite::fromJSON(meta_api)

# read survey data
survey_api = glue::glue("{base_url}blockStructure?s_id={m_df$id}&g_id={group_code}")
s_df = jsonlite::fromJSON(survey_api)

# quick echo
jsonlite::toJSON(m_df)
jsonlite::toJSON(s_df)


  return()
}