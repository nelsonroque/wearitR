library(wearitR)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Attempted approaches:
# for loop
# map, jsonlite::fromJSON, unnest
# filtering weird strings
# filtering backslashes

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# preprocess cog task data ----
cogtasks_df_p = preprocess_cogtask_data(data_path = "examples/data")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# get unique cogtask names -----
table(cogtasks_df_p$m2c2_cogtask)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# separate data from each cogtask -----
cogtask_dotmemory <- cogtasks_df_p %>% filter(m2c2_cogtask == "dotmemory")
cogtask_symbolsearch <- cogtasks_df_p %>% filter(m2c2_cogtask == "symbolsearch")
cogtask_shoppinglist <- cogtasks_df_p %>% filter(m2c2_cogtask == "shoppinglist")
cogtask_stroop <- cogtasks_df_p %>% filter(m2c2_cogtask == "stroop")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# unstack cogtask json data -----
cogtask_dotmemory_unstacked = unnest_cogtask_data(cogtask_dotmemory) %>% select(-cogtask_json)
cogtask_symbolsearch_unstacked = unnest_cogtask_data(cogtask_symbolsearch) %>% select(-cogtask_json)
cogtask_shoppinglist_unstacked = unnest_cogtask_data(cogtask_shoppinglist) %>% select(-cogtask_json)
cogtask_stroop_unstacked = unnest_cogtask_data(cogtask_stroop) %>% select(-cogtask_json)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# verify all records parsed ----
cogtask_dotmemory_processcheck = parsecheck_cogtask_data(cogtask_dotmemory, cogtask_dotmemory_unstacked)
cogtask_symbolsearch_processcheck = parsecheck_cogtask_data(cogtask_symbolsearch, cogtask_symbolsearch_unstacked)
cogtask_shoppinglist_processcheck = parsecheck_cogtask_data(cogtask_shoppinglist, cogtask_shoppinglist_unstacked)
cogtask_stroop_processcheck = parsecheck_cogtask_data(cogtask_stroop, cogtask_stroop_unstacked)

cogtask_dotmemory_processcheck$ids_overlap

cogtask_dotmemory_processcheck$all_records_processed
cogtask_symbolsearch_processcheck$all_records_processed
cogtask_shoppinglist_processcheck$all_records_processed
cogtask_stroop_processcheck$all_records_processed

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# quantify # of records without trial parameters (flag to WearIT team, Jessie)
prop.table(table(cogtask_dotmemory_unstacked$cogtask_trial_params == "{}"))
prop.table(table(cogtask_symbolsearch_unstacked$cogtask_trial_params == "{}"))
prop.table(table(cogtask_shoppinglist_unstacked$cogtask_trial_params == "{}"))
prop.table(table(cogtask_stroop_unstacked$cogtask_trial_params == "{}"))
