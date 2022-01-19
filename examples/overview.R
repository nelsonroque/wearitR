library(wearitR)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# repeat steps above with new function for two survey files -----
beep_survey1_list = wearitR::read_wearit_surveydata("examples/data/1035_Beeped_Survey_1_2022-01-19.csv")
beep_survey1_keytable = beep_survey1_list$key_table
beep_survey1_tidydata = beep_survey1_list$tidy_data

beep_survey2_list = wearitR::read_wearit_surveydata("examples/data/1035_Beeped_Survey_2_2022-01-19.csv")
beep_survey2_keytable = beep_survey2_list$key_table
beep_survey2_tidydata = beep_survey2_list$tidy_data

# merge like files ----
dc_stacked_dplyr = bind_rows(beep_survey1_tidydata, 
                             beep_survey2_tidydata)

# look at columns that have NAs ----
dc_stacked_dplyr_nacols = dc_stacked_dplyr %>%
  select(`Survey Date Submitted`, contains("N/A"))

# should all beep surveys have same labels? ----

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# get all filenames in folder ----
get_data_fns("examples/data")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# search for filenames of interest ----
dc = create_data_collection("examples/data", types=c("Beeped_Survey_1", 
                                                     "Beeped_Survey_2",
                                                     "Beeped_Survey_3"))

# view all exports of create_data_collection() ----
dc$target_files
dc$all_files
dc$nonkey_files
dc$key_files

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# merge like files ----
dc_stacked_package = merge_data_collection(fns=dc$nonkey_files)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create data quality report ----
skimr::skim(dc_stacked_package)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create codebook ----

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>