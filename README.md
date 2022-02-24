# wearitR (version `0.0.0.2`)

-----

An R package to simplify data preparation across WearIT platform exports. 

`Disclaimer: This repository is not directly affiliated with the WearIT platform.`

-----

## Installation

Run the code below to install the required packages in a fresh R environment.

```{r}
# list of packages required on machine ---
packages_req_dev = c("rlist", "skimr", "tidyverse", "devtools") # optional: "dataReporter"

# install them ---
install.packages(packages_req_dev)

# install `wearitR` package ---
devtools::install_github("nelsonroque/wearitR")
```

-----

## Intended Usage of Package

- The intended interface is leveraging/cloning one of our example pipelines (`template/catslife`) that contains a `data` folder (intended for all input data files exported from Wear-IT platform), an `output` folder (intended for any csv outputs from the processes described above), and a JSON configuration (`config.json`) containing relevant study datafile identifiers (survey ids, cognitive task names).

See `https://github.com/nelsonroque/wearitR_templates` for a sampling of functions in a brief demo.

-----

## Function listing

### General Utilities

- `read_surveydata()`
  - Description: ``` read Wear-It Platform raw exports ```
- `list_csvs()`
	- Description: ``` Get vector of all filenames in a directory. ```
- `list_csvs_bytype()`
	- Description: ``` Search for specific files and group them for tasks such as merging or comparison. ```
- `merge_csvs()`
	- Description: ``` Concatenate to a single dataframe, the data n. ```
- `reformat_keyfiles()`
	- Description: ``` reformat key files for easier querying. ```

### Cognitive Task Data Utilities
- `cogdata_preprocess()`
	- Description: ``` prepare initial cogtask data. ```
- `cogdata_unnest()`
	- Description: ``` unnest JSON cogtask data. ```
- `cogdata_validation()`
	- Description: ``` validate that the number of UUIDs matches in input and unnested cogtask data. ```
	
### Pipeline functions

- `run_pipeline_cogdata()`
	- Description: ``` leveraging a config.json file, crawl a study and prepare cogtask data. ```
- `run_pipeline_survey()`
	- Description: ``` leveraging a config.json file, crawl a study and prepare survey data. ```
- `run_pipeline()`
	- Description: ``` leveraging a config.json file, crawl a study and prepare all (survey, cogtask) data. ```

-----

Page last updated: `Feb 9 2022`
