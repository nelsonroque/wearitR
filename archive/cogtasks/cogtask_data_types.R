library(readr)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# specify data path, list files in path ----
path <- "examples/usc_demo_cogtaskdata"
files_in_zip <- list.files(path, recursive = T, full.names = T, pattern = "*.txt")

# get specific filenames -----
ss_filename <- files_in_zip[grepl("Symbol-Search", files_in_zip)]
cs_filename <- files_in_zip[grepl("Color-Shapes", files_in_zip)]
dm_filename <- files_in_zip[grepl("Dot-Memory", files_in_zip)]
sl_filename <- files_in_zip[grepl("Shopping-List", files_in_zip)]
stroop_filename <- files_in_zip[grepl("stroop", files_in_zip)]

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# read in the raw cognitive task data ----
ss_raw <- readr::read_delim(ss_filename, na=".", delim = "|", escape_double = FALSE, trim_ws = TRUE)
cs_raw <- readr::read_delim(cs_filename, na=".", delim = "|", escape_double = FALSE, trim_ws = TRUE)
dm_raw <- readr::read_delim(dm_filename, na=".", delim = "|", escape_double = FALSE, trim_ws = TRUE)
sl_raw <- readr::read_delim(sl_filename, na=".", delim = "|", escape_double = FALSE, trim_ws = TRUE)
stroop_raw <- readr::read_delim(stroop_filename, na=".", delim = "|", escape_double = FALSE, trim_ws = TRUE)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# list variable types for each cogtask
vartypes <- list(symbol_search  = readr::spec(ss_raw),
                 color_shapes = readr::spec(cs_raw),
                 dot_memory = readr::spec(dm_raw),
                 shopping_list = readr::spec(sl_raw),
                 stroop = readr::spec(stroop_raw))

reprex::reprex(vartypes)
