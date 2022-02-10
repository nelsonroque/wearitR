#' Read WearIT Survey data ----
#' @export
run_pipeline <- function(data_path, config_path) {
  run_pipeline_survey(data_path, config_path)
  run_pipeline_cogdata(data_path, config_path)
}