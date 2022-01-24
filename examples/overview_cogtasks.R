library(wearitR)
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# What has been tried to parse cog data

# for loop
# map, jsonlite::fromJSON, unnest
# filtering weird strings
# filtering backslashes

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create data collection of M2C2 cogtest data ----
cogtasks = create_data_collection(data_path = "examples/data", 
                                  types=c("cog"))

# read cog task data ----
cogtasks_df = read_csv(cogtasks$nonkey_files, col_names = c("wearit_uuid", "cogtask_json"))

# apply simple filtering logic for JSON schema ----
cogtasks_df_p = cogtasks_df %>%
  mutate(first_char = substr(cogtask_json,1,1)) %>%
  mutate(format_valid = ifelse(first_char == "{", FALSE, TRUE)) %>%
  mutate(cogtask_json_r = gsub("\\\\", "\\\\\\\\", cogtask_json))
  #mutate(cogtask_name = purrr::pluck(cogtask_json, "cogtask_name", .default = NA))

# generate a table of valid cognitive task data to process -----
cogtasks_df_valid <- cogtasks_df_p %>%
  mutate(inferred_ios = wearit_uuid == toupper(wearit_uuid)) %>%
  mutate(flag_weirdschema1 = grepl("\\\\Tools.js\\\\", cogtask_json)) %>%
  mutate(flag_weirdschema2 = grepl("\\\\dotmemory.zip\\\\", cogtask_json)) %>%
  mutate(flag_weirdschema3 = grepl("\\\\GameEngine.js\\\\", cogtask_json)) %>%
  # mutate(flag_weirdschema4 = grepl("\\\\*.js", cogtask_json)) %>%
  # mutate(flag_weirdschema5 = grepl("{\\\\*}", cogtask_json)) %>%
  filter(format_valid) %>%
  #filter(!flag_weirdschema4) %>%
  filter(!flag_weirdschema1 & !flag_weirdschema2 & !flag_weirdschema3)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# code below, for now ----
cogtasks_workingrows = cogtasks_df_valid#[1:6,]

cogtasks_unnested = cogtasks_workingrows %>% 
  mutate(json = map(cogtask_json, ~ jsonlite::fromJSON(.) %>% as.data.frame())) %>% 
  unnest(json) %>%
  arrange(cogtask_run_uuid)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# quantify # of records without trial parameters (flag to WearIT team, Jessie)
table(cogtasks_unnested$cogtask_trial_params == "{}")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# look at response_time distribution for each cogtask ----
ggplot(cogtasks_unnested, aes(as.numeric(response_time))) + geom_histogram()

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# other parse approach
library(tidyjson)

cogtasks_df_p$cogtask_json %>% spread_all
#https://cran.r-project.org/web/packages/tidyjson/vignettes/introduction-to-tidyjson.html
#try(map(x, chuck, 2, "elt", 10))

cogtasks_unnested = cogtasks_df_p %>% 
  mutate(json = map(cogtask_json_r, ~ jsonlite::fromJSON(.) %>% as.data.frame())) %>% 
  unnest(json) %>%
  arrange(cogtask_run_uuid)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# hook into auto-EDA package -----
