# list of packages required on machine if developing on this R Package ---
packages_req_dev = c("rlist", "skimr", "tidyverse", "devtools") # optional: "dataReporter"

# install them ---
install.packages(packages_req_dev)

# install `wearitR` package ---
devtools::install_github("nelsonroque/wearitR")
