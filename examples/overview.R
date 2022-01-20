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

# TODO: write `reformat_keyfiles.R`

allkeys = read_wearit_surveydata(dc$nonkey_files[1])$key_table

# read single key file
dc$key_files[1]
sample_keyfile <- read_csv(dc$key_files[1], 
                           col_names=c("key", "value")) %>%
  mutate(is_ques_num = grepl("Q_", key)) %>%
  mutate(wearit_col_qnum = ifelse(is_ques_num, key, NA)) %>%
  full_join(allkeys)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# merge like files ----
dc_stacked_package = merge_data_collection(fns=dc$nonkey_files)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# reformat key files ----
reformat_keyfiles()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create data quality reports ----

# Simple
example_simple_dataquality_report = skimr::skim(dc_stacked_dplyr)

# Complex
#dataReporter::visualize(dc_stacked_dplyr)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create data collection of M2C2 cogtest data ----
cogtasks = create_data_collection(data_path = "examples/data", 
                                  types=c("cog"))

# read cog task data ----
cogtasks_df = read_csv(cogtasks$nonkey_files, col_names = c("wearit_uuid", "cogtask_json"))

# apply simple filtering logic for JSON schema ----
cogtasks_df_p = cogtasks_df %>%
  mutate(first_char = substr(cogtask_json,1,1)) %>%
  mutate(format_valid = ifelse(first_char == "{", FALSE, TRUE))

# generate a table of valid cognitive task data to process -----
cogtasks_df_valid <- cogtasks_df_p %>%
  filter(format_valid) %>%
  mutate(inferred_ios = wearit_uuid == toupper(wearit_uuid))

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create a list of data frames from each expanded JSON ----
coglookup = list()
for(i in 1:nrow(cogtasks_df_valid)) {
  print(i)
  
  # extract current row
  cur_row = cogtasks_df_valid[i,]
  
  # for debugging
  print("---------------------")
  print(cur_row$wearit_uuid)
  
  # unpack json list
  cur_row_df = jsonlite::fromJSON(cur_row$cogtask_json) %>%
    mutate(wearit_uuid = cur_row$wearit_uuid) %>% # append the wearit_uuid for linking
    mutate(flag_missing_params = ifelse(cogtask_trial_params == "{}", TRUE, FALSE)) %>% # flag missing params
    select(order(colnames(.))) %>% # sort cols a-z
    select(wearit_uuid, everything()) # bring wearit_uuid to the front for easy checking
  
  # echo cogtask name
  print(cur_row_df$wearit_uuid[1])
  print(cur_row_df$cogtask_name[1])
  print(names(cur_row_df))
  
  # save dataframe
  coglookup <- rlist::list.append(coglookup, cur_row_df)
}

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# parse bug may be related to -----
# https://stackoverflow.com/questions/34148619/lexical-error-inside-a-string-occurs-before-a-character-which-it-may-not

# bind available data - coincidentally, all dot-memory
dotmemory_df <- bind_rows(coglookup) %>%
  select(order(colnames(.))) %>%
  select(wearit_uuid, everything()) %>%
  mutate(dt_date = anytime::anydate(time_stamp))

# evaluate distribution of computed frames per second ----
ggplot(dotmemory_df, aes(as.numeric(cogtask_cps))) + geom_histogram()
ggplot(dotmemory_df, aes(as.numeric(cogtask_fps))) + geom_histogram()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create codebook ----

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>