library(wearitR)

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

# code below, for now ----
cogtask_workingrows = cogtasks_df_valid[1:7,]

cogtask_read = cogtask_workingrows %>% 
  mutate(json = map(cogtask_json, ~ jsonlite::fromJSON(.) %>% as.data.frame())) %>% 
  unnest(json) %>%
  arrange(cogtask_run_uuid)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# quantify # of records without trial parameters (flag to WearIT team, Jessie)
table(cogtask_read$cogtask_trial_params == "{}")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# look at response_time distribution for each cogtask ----
ggplot(cogtask_read, aes(as.numeric(response_time))) + geom_histogram()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# hook into auto-EDA package -----
