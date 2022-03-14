#' Read WearIT Survey data ----
#' @export
run_pipeline <- function(data_path, config_path, use_labels=T, silent=TRUE) {
  
  # download study config from WearIT server ----
  
  tryCatch(
    expr = {
      study_config = read_studyconfig(config_path)
      message("Successfully executed read_studyconfig().")
    },
    error = function(e){
      message('`read_studyconfig()` Caught an error!')
      print(e)
    },
    warning = function(w){
      message('`read_studyconfig()` Caught a warning!')
      print(w)
    },
    finally = {
      message('`read_studyconfig()` All done, quitting.')
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
      message('`run_pipeline_cogdata()` Caught a warning!')
      print(w)
    },
    finally = {
      message('`run_pipeline_cogdata()` All done, quitting.')
    }
  )    
  
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
      message('`run_pipeline_survey()` Caught a warning!')
      print(w)
    },
    finally = {
      message('`run_pipeline_survey()` All done, quitting.')
    }
  )    

  if(!silent){
    return(study_config)
  }
}