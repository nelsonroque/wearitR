#' Read WearIT Survey data ----
#' @export
read_studyconfig <- function(config_path, save_files=TRUE) {
  
  # create session timestamp ----
  session_ts = str_replace_all(Sys.time(), "[[:punct:]]", "_")
  
  # read study config ----
  study_config = jsonlite::read_json(config_path)

  # configure API endpoints
  base_url = "https://wearables.vmhost.psu.edu/wearables-survey/Survey/"
  
  # read json from Wear-IT Platform
  group_code = study_config$study_groupcode
  
  # read study data
  meta_api = glue::glue("{base_url}group/{group_code}")
  meta_df = jsonlite::fromJSON(meta_api)
  study_info_j = jsonlite::toJSON(meta_df)
  
  # read survey data
  survey_api = glue::glue("{base_url}blockStructure?s_id={meta_df$id}&g_id={group_code}")
  survey_df = jsonlite::fromJSON(survey_api)
  survey_info_j = jsonlite::toJSON(survey_df)
  
  # save list with all results from endpoint
  out_list = list(study_info = meta_df,
                  study_info_j = study_info_j,
                  survey_info = survey_df,
                  survey_info_j = survey_info_j)
  
  if(save_files) {
    jsonlite::write_json(meta_df, glue::glue("output/wearitR_config_study_{group_code}.json"))
    jsonlite::write_json(survey_df, glue::glue("output/wearitR_config_survey_{group_code}.json"))
  }

  return(out_list)
}
