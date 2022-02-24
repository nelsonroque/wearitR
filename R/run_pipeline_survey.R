#' Read WearIT Survey data ----
#' @export
run_pipeline_survey <- function(data_path, config_path, use_labels=TRUE) {
  
  # create session timestamp ----
  session_ts = str_replace_all(Sys.time(), "[[:punct:]]", "_")
  
  # read study config ----
  study_config = jsonlite::read_json(config_path)
  
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  
  all_codebooks = tibble()
  all_reports = tibble()
  for (i in 1:length(study_config$surveys)) {
    print("-------")
    print(i)
    cur_survey_patterns = study_config$surveys[[i]] %>% unlist(.)
    cur_survey_fn = paste0(cur_survey_patterns, collapse="_")
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # create data collection ----
    dc = list_csvs_bytype("data", types=cur_survey_patterns)
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # for debugging ---
    # print(cur_survey_patterns)
    # dc$target_files
    # dc$all_files
    # dc$nonkey_files
    # dc$key_files
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # list all keys, prepare codebook ---
    all_keys = read_surveydata(dc$nonkey_files[1], use_labels=use_labels)$key_table
    near_codebook_keyfile = reformat_keyfiles(dc$key_files[1], all_keys) %>%
      mutate(filenames = paste0(cur_survey_patterns, collapse=","))
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # merge like files ----
    dc_stacked_package = merge_csvs(fns=dc$nonkey_files, use_labels=use_labels)
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # create (simple) data quality reports ----
    simple_dataquality_report = skimr::skim(dc_stacked_package) %>%
      mutate(filenames = paste0(cur_survey_patterns, collapse=","))
    
    # output data from this survey ----
    write_csv(simple_dataquality_report, paste0("output/wearitR_dataquality_report","_",session_ts,"_",cur_survey_fn,"_",study_config$study_id,"_",study_config$study_groupcode, ".csv"))
    write_csv(near_codebook_keyfile, paste0("output/wearitR_codebook_report","_",session_ts,"_",cur_survey_fn,"_",study_config$study_id,"_",study_config$study_groupcode, ".csv"))
    write_csv(dc_stacked_package, paste0("output/wearitR_survey","_",session_ts,"_",cur_survey_fn,"_",study_config$study_id,"_",study_config$study_groupcode, ".csv"))
    
    # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    # stack data for this session ----
    all_codebooks = bind_rows(all_codebooks, near_codebook_keyfile)
    all_reports = bind_rows(all_reports, simple_dataquality_report)
  }
}