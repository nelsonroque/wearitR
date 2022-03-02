#' Read WearIT Survey data ----
#' @export
run_pipeline <- function(data_path, config_path, use_labels=T, silent=TRUE) {
  # try to run_pipeline_survey() ----
  tryCatch(
    expr = {
      run_pipeline_survey(data_path, config_path, use_labels=use_labels)
      message("Successfully executed run_pipeline_survey().")
    },
    error = function(e){
      message('`run_pipeline_survey()` Caught an error!')
      print(e)
    },
    warning = function(w){
      message('`run_pipeline_survey()` Caught an warning!')
      print(w)
    },
    finally = {
      message('`run_pipeline_survey()` All done, quitting.')
    }
  )    
  
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
      message('`run_pipeline_cogdata()` Caught an warning!')
      print(w)
    },
    finally = {
      message('`run_pipeline_cogdata()` All done, quitting.')
    }
  )    
  
  study_config = read_studyconfig(config_path)
  
  if(!silent){
    return(study_config)
  }
}