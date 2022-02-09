#' Read WearIT Survey data ----
#' @export
run_study_datapipeline <- function(data_path, config_path) {
  study_pipeline_survey(data_path, config_path)
  study_pipeline_cogtasks(data_path, config_path)
}