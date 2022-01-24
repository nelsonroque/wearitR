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
# 
# # create a list of data frames from each expanded JSON ----
# coglookup = list()
# for(i in 1:nrow(cogtasks_df_valid)) {
#   print(i)
#   
#   # extract current row
#   cur_row = cogtasks_df_valid[i,]
#   
#   # for debugging
#   print("---------------------")
#   print(cur_row$wearit_uuid)
#   
#   # unpack json list
#   cur_row_df = jsonlite::fromJSON(cur_row$cogtask_json) %>%
#     mutate(wearit_uuid = cur_row$wearit_uuid) %>% # append the wearit_uuid for linking
#     mutate(flag_missing_params = ifelse(cogtask_trial_params == "{}", TRUE, FALSE)) %>% # flag missing params
#     select(order(colnames(.))) %>% # sort cols a-z
#     select(wearit_uuid, everything()) # bring wearit_uuid to the front for easy checking
#   
#   # echo cogtask name
#   print(cur_row_df$wearit_uuid[1])
#   print(cur_row_df$cogtask_name[1])
#   print(names(cur_row_df))
#   
#   # save dataframe
#   coglookup <- rlist::list.append(coglookup, cur_row_df)
# }


# get dates ----
coglookup = list()
#cog_metadata = tibble()
#cur_metadata = tibble()
for(i in 1:nrow(cogtasks_df_valid)) {
  print(i)
  
  cur_row = cogtasks_df_valid[i,]
  print(cur_row)
  print(":------")
  
  jp = tryCatch(
    expr = {
      # Your code...
      # goes here...
      # ...
      # filter by dates
      jsonlite::fromJSON(cur_row)
      # cur_metadata = tibble(session_start_ts = tss) %>%
      #   mutate(wearit_uuid = cur_row$wearit_uuid)
      #print(cur_metadata)
      #rlist::list.append(coglookup, cur_metadata)
    },
    error = function(e){ 
      # (Optional)
      # Do this if an error is caught...
      "ERROR"
      #cur_metadata = tibble("wearit_uuid" = cur_row$wearit_uuid, "session_start_ts" = tss )
    })
      #print(cur_metadata)
      #rlist::list.append(coglookup, cur_metadata)
    # },
    # warning = function(w){
    #   # (Optional)
    #   # Do this if an warning is caught...
    #   tss = "WARNING"
    #   cur_metadata = tibble("wearit_uuid" = cur_row$wearit_uuid, "session_start_ts" = tss )
    #   #print(cur_metadata)
    #  #rlist::list.append(coglookup, cur_metadata)
    # }
    # ,
    # finally = function(f){
    #   # (Optional)
    #   # Do this if an warning is caught...
    #   tss = "FINALLY"
    #   cur_metadata = tibble("wearit_uuid" = cur_row$wearit_uuid, "session_start_ts" = tss )
    #   print(cur_metadata)
    #   coglookup = rlist::list.append(coglookup, cur_metadata)
    # }
  #)
  
  coglookup = rlist::list.append(coglookup, jp)
  #print(cur_metadata)
  
  
  #coglookup = rlist::list.append(coglookup, tss)
}

# look at all rows metadata ----
session_dates = bind_rows(coglookup)
# 
# a = jsonlite::fromJSON(cogtasks_df_valid$cogtask_json[1])
# 
# # View the raw JSON - index 9 is a broken schema
# listviewer::jsonedit(cogtasks_df_valid$cogtask_json[9], height = "800px", mode = "view")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# parse bug may be related to -----
# https://stackoverflow.com/questions/34148619/lexical-error-inside-a-string-occurs-before-a-character-which-it-may-not
# 
# # bind available data - coincidentally, all dot-memory
# dotmemory_df <- bind_rows(coglookup) %>%
#   select(order(colnames(.))) %>%
#   select(wearit_uuid, everything()) %>%
#   mutate(dt_date = anytime::anydate(time_stamp))
# 
# #read_csv(col_types=c(col_character(), col_integer()))
# 
# # evaluate distribution of computed frames per second ----
# ggplot(dotmemory_df, aes(as.numeric(cogtask_cps))) + geom_histogram()
# ggplot(dotmemory_df, aes(as.numeric(cogtask_fps))) + geom_histogram()
