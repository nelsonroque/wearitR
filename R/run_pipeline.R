#' Read WearIT Survey data ----
#' @export
run_pipeline <- function(data_path, config_path, use_labels=T, silent=TRUE, drop_deprecated=TRUE) {
  
  # download study config from WearIT server ----
  
  tryCatch(
    expr = {
      study_config = read_studyconfig(config_path)
      message('[✅] SUCCESS | `read_studyconfig()`')
    },
    error = function(e){
      message('[❌] ERROR | `read_studyconfig()`')
      print(e)
    },
    warning = function(w){
      message('[⚠️] WARNING | `read_studyconfig()`')
      print(w)
    },
    finally = {
      message('[✅] SUCCESS | `read_studyconfig()`')
    }
  )    
  
  # try to run_pipeline_cogdata() ----
  tryCatch(
    expr = {
      run_pipeline_cogdata(data_path, config_path)
      message('[✅] SUCCESS | `run_pipeline_cogdata()`')
    },
    error = function(e){
      message('[❌] ERROR | `run_pipeline_cogdata()`')
      print(e)
    },
    warning = function(w){
      message('[⚠️] WARNING | `run_pipeline_cogdata()`')
      print(w)
    },
    finally = {
      message('[✅] SUCCESS | `run_pipeline_cogdata()`')
    }
  )    
  
  # try to run_pipeline_survey() ----
  tryCatch(
    expr = {
      run_pipeline_survey(data_path, config_path, use_labels=use_labels, drop_deprecated=drop_deprecated)
      message('[✅] SUCCESS | `run_pipeline_survey()`')
    },
    error = function(e){
      message('[❌] ERROR | `run_pipeline_survey()`')
      print(e)
    },
    warning = function(w){
      message('[⚠️] WARNING | `run_pipeline_survey()`')
      print(w)
    },
    finally = {
      message('[✅] SUCCESS | `run_pipeline_survey()`')
    }
  )    

  if(!silent){
    return(study_config)
  }
}