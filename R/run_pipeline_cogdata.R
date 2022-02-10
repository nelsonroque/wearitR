#' Read WearIT Survey data ----
#' @export
run_pipeline_cogdata <- function(data_path, config_path) {
  
  # create session timestamp ----
  session_ts = str_replace_all(Sys.time(), "[[:punct:]]", "_")
  
  # read study config ----
  study_config = jsonlite::read_json(config_path)
  
  # preprocess cog task data ----
  cogtasks_df_p = cogdata_preprocess(data_path = "data")
  
  # get unique cogtask names -----
  table(cogtasks_df_p$m2c2_cogtask)
  
  for(i in unique(study_config$cogtasks)) {
    print(i)
    cogtask_current <- cogtasks_df_p %>% filter(m2c2_cogtask == i)
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # unstack cogtask json data -----
    cogtask_unstacked = cogdata_unnest(cogtask_current) %>% select(-cogtask_json)
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # retype data based on Chelsea's definitions
    # insert reprex results
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # verify all records parsed ----
    cogtask_processcheck = cogdata_validation(cogtask_current, cogtask_unstacked)
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # export data 
    write_csv(cogtask_unstacked, paste0("output/wearitR_cogdata_unstacked","_",session_ts,"_",i,"_",study_config$study_id,"_",study_config$study_groupcode, ".csv"))
  }
}