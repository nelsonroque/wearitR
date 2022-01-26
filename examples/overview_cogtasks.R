library(wearitR)

# Attempted approaches:
# for loop
# map, jsonlite::fromJSON, unnest
# filtering weird strings
# filtering backslashes

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

unnest_cogtask_data <- function(.data) {
  cogtasks_unnested = .data %>% 
    mutate(json = map(cogtask_json, ~ jsonlite::fromJSON(.) %>% as.data.frame())) %>% 
    unnest(json) %>%
    arrange(cogtask_run_uuid) %>%
    select(-`Game Result`)
  return(cogtasks_unnested)
}

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create data collection of M2C2 cogtest data ----
cogtasks = create_data_collection(data_path = "examples/data", 
                                  types=c("cog"))

# read cog task data ----
cogtasks_df = read_csv(cogtasks$nonkey_files)#, #col_names = c("wearit_uuid", "cogtask_json"))

# apply simple filtering logic for JSON schema ----
cogtasks_df_p = cogtasks_df %>%
  mutate(cogtask_json = gsub("\\\\", "", `Game Result`)) %>%
  mutate(first_char = substr(`Game Result`,1,1)) %>%
  mutate(format_valid = ifelse(first_char == "{", FALSE, TRUE))

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# get unique cogtask names -----
table(cogtasks_df_p$`Cog Test Name`)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# separate data from each cogtask -----
cogtasks_dotmemory <- cogtasks_df_p %>% filter(`Cog Test Name` == "dotmemory")
cogtasks_symbolsearch <- cogtasks_df_p %>% filter(`Cog Test Name` == "symbolsearch")
cogtasks_shoppinglist <- cogtasks_df_p %>% filter(`Cog Test Name` == "shoppinglist")
cogtasks_stroop <- cogtasks_df_p %>% filter(`Cog Test Name` == "stroop")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# unstack cogtask json data -----
cogtask_dotmemory_unstacked = unnest_cogtask_data(cogtasks_dotmemory)
cogtask_symbolsearch_unstacked = unnest_cogtask_data(cogtasks_symbolsearch)
cogtask_shoppinglist_unstacked = unnest_cogtask_data(cogtasks_shoppinglist)
cogtask_stroop_unstacked = unnest_cogtask_data(cogtasks_stroop)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# quantify # of records without trial parameters (flag to WearIT team, Jessie)
table(cogtask_dotmemory_unstacked$cogtask_trial_params == "{}")
table(cogtask_symbolsearch_unstacked$cogtask_trial_params == "{}")
table(cogtask_shoppinglist_unstacked$cogtask_trial_params == "{}")
table(cogtask_stroop_unstacked$cogtask_trial_params == "{}")
