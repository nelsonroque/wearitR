#' Read WearIT Survey data ----
#' @export

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


