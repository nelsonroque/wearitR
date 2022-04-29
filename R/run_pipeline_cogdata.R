#' Read WearIT Survey data ----
#' @export
run_pipeline_cogdata <- function(data_path, config_path) {
  
  # create session timestamp ----
  session_ts = str_replace_all(Sys.time(), "[[:punct:]]", "_")
  
  # read study config ----
  study_config = jsonlite::read_json(config_path)
  
  # create data collection of M2C2 cogtest data ----
  cogtasks = list_csvs_bytype(data_path = data_path, 
                              types=c("cog"))
  
  # read cog task data ----
  # pass in col names for easy processing thereafter
  cogtasks_df = read_csv(cogtasks$nonkey_files)
  
  if(exists("cogtasks_df", where = .GlobalEnv)) {
    # apply simple filtering logic for JSON schema ----
    names(cogtasks_df) <- c("wearit_uuid", "cogtask_json_raw",
                            "m2c2_cogtask", "participant_id",
                            "device_model", "device_os", 
                            "survey_date_submitted", "survey_date_completed")
    
    cogtasks_df_p = cogtasks_df %>%
      mutate(cogtask_json = gsub("\\\\", "", `cogtask_json_raw`)) %>% # fix backslash problem
      mutate(extract_firstchar = stringi::stri_sub(`cogtask_json_raw`,1,1)) %>%
      mutate(extract_lastchar = stringi::stri_sub(`cogtask_json_raw`,-1)) %>%
      mutate(format_valid = ifelse(extract_firstchar == "[" & extract_lastchar == "]", TRUE, FALSE))
  } else {
    cogtasks_df_p = tibble(error="issue with read_csv(cogtasks$nonkey_files)",
                           format_valid=FALSE)
  }
  
  cogtasks_valid = cogtasks_df_p %>% filter(format_valid)
  cogtasks_invalid = cogtasks_df_p %>% filter(!format_valid)
  
  # save separately all data deemed invalid ----
  write_csv(cogtasks_invalid, paste0("output/wearitR_cogdata_INVALID","_",session_ts,"_",study_config$study_id,"_",study_config$study_groupcode, ".csv"))
  
  # get unique cogtask names -----
  table(cogtasks_df_p$m2c2_cogtask)
  
  for(i in unique(study_config$cogtasks)) {
    print(i)
    cogtask_current <- cogtasks_valid %>% filter(m2c2_cogtask == i)
    
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