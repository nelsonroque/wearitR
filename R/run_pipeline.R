#' Read WearIT Survey data ----
#' @export
run_pipeline <- function(data_path, config_path, use_labels=T, silent=TRUE) {
  
  # download study config from WearIT server ----
  study_config = read_studyconfig(config_path)
  
  # try to run_pipeline_cogdata() ----
  tryCatch(
    expr = {
      run_pipeline_cogdata(data_path, config_path)
      message("Successfully executed run_pipeline_cogdata().")
    },
    error = function(e){
      message('`run_pipeline_cogdata()` Caught an error!')
      print(e)
    },
    warning = function(w){
      message('`run_pipeline_cogdata()` Caught a warning!')
      print(w)
    },
    finally = {
      message('`run_pipeline_cogdata()` All done, quitting.')
    }
  )    
  
  # run survey pipeline ----
  run_pipeline_survey(data_path, config_path, use_labels=use_labels)

  if(!silent){
    return(study_config)
  }
}