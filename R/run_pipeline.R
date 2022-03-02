#' Read WearIT Survey data ----
#' @export
run_pipeline <- function(data_path, config_path, use_labels=T, silent=TRUE) {
  run_pipeline_survey(data_path, config_path, use_labels=use_labels)
  run_pipeline_cogdata(data_path, config_path)
  study_config = read_studyconfig(config_path)
  
  if(!silent){
    return(study_config)
  }
}