library(RM2C2dev)
library(readr)

path <- "examples/usc_demo_cogtaskdata"
files_in_zip <- list.files(path, recursive = T, full.names = T, pattern = "*.txt")

ss_filename <- files_in_zip[grepl("Symbol-Search", files_in_zip)]
cs_filename <- files_in_zip[grepl("Color-Shapes", files_in_zip)]
dm_filename <- files_in_zip[grepl("Dot-Memory", files_in_zip)]
sl_filename <- files_in_zip[grepl("Shopping-List", files_in_zip)]
stroop_filename <- files_in_zip[grepl("stroop", files_in_zip)]
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# read in the raw cognitive task data ----
ss_raw <- RM2C2dev::read_m2c2_local(ss_filename, na=".")
cs_raw <- RM2C2dev::read_m2c2_local(cs_filename, na=".")
dm_raw <- RM2C2dev::read_m2c2_local(dm_filename, na=".")
sl_raw <- RM2C2dev::read_m2c2_local(sl_filename, na=".")
stroop_raw <- RM2C2dev::read_m2c2_local(stroop_filename, na=".")

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# list variable types for each cogtask
vartypes <- list(symbol_search  = readr::spec(ss_raw),
                 color_shapes = readr::spec(cs_raw),
                 dot_memory = readr::spec(dm_raw),
                 shopping_list = readr::spec(sl_raw),
                 stroop = readr::spec(stroop_raw))


# # if using spec function, don't need any of the below code.
# # below is just another way to do something similar, but with more code 
# # filter exact duplicates ----
# ss_filter_ed <- ss_raw %>% distinct()
# cs_filter_ed <- cs_raw %>% distinct()
# dm_filter_ed <- dm_raw %>% distinct()
# sl_filter_ed <- sl_raw %>% distinct()
# stroop_filter_ed <- stroop_raw %>% distinct()
# 
# # ss_datatypes <- data.frame(lapply(ss_filter_ed, typeof))
# # cs_datatypes <- data.frame(lapply(cs_filter_ed, typeof))
# # dm_datatypes <- data.frame(lapply(dm_filter_ed, typeof))
# # sl_datatypes <- data.frame(lapply(sl_filter_ed, typeof))
# # stroop_datatypes <- data.frame(lapply(stroop_filter_ed, typeof))
# 
# ss_datatypes <- data.frame(var_type = sapply(ss_filter_ed, typeof), 
#                            var_names = colnames(ss_filter_ed),
#                            row.names = seq(1:ncol(ss_filter_ed)))
# cs_datatypes <- data.frame(var_type = sapply(cs_filter_ed, typeof), 
#                            var_names = colnames(cs_filter_ed),
#                            row.names = seq(1:ncol(cs_filter_ed))) 
# dm_datatypes <- data.frame(var_type = sapply(dm_filter_ed, typeof), 
#                            var_names = colnames(dm_filter_ed),
#                            row.names = seq(1:ncol(dm_filter_ed))) 
# sl_datatypes <- data.frame(var_type = sapply(sl_filter_ed, typeof), 
#                            var_names = colnames(sl_filter_ed),
#                            row.names = seq(1:ncol(sl_filter_ed))) 
# stroop_datatypes <- data.frame(var_type = sapply(stroop_filter_ed, typeof), 
#                            var_names = colnames(stroop_filter_ed),
#                            row.names = seq(1:ncol(stroop_filter_ed))) 
# 
# # save variable names as list by variable type? 
# ss_num_vars <- ss_datatypes %>%
#   dplyr::filter(var_type == "double"|var_type == "integer") %>%
#   pull(var_names)
# 
# # pull column names for different data types; could loop/apply this
# numeric_vars <- names(dm_datatypes[,dm_datatypes[1,] == "double"])
# character_vars <- names(dm_datatypes[,dm_datatypes[1,] == "character"])
