#' Read WearIT Survey data ----
#' 
#' \code{unnest_cogtask_data} unnests M2C2 Cogtask JSON data from WearIT platform
#' @author Nelson Roque, \email{Nelson.Roque@@ucf.edu}
#' @export
#' @importFrom tibble tibble
#' @importFrom dplyr arrange
#' @importFrom readr read_csv
#' @importFrom jsonlite fromJSON
#' @param data data object returned from `cogdata_preprocess()`
cogdata_unnest <- function(.data) {
  unnested = .data %>% 
    mutate(json = map(cogtask_json, ~ jsonlite::fromJSON(.) %>% as.data.frame())) %>% 
    unnest(json) %>%
    arrange(survey_date_submitted) %>%
    select(-`cogtask_json_raw`)
  return(unnested)
}