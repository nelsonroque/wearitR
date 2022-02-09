# wearitR

An R package to simplify data preparation across WearIT platform exports. 

`Disclaimer: This repository is not directly affiliated with the WearIT platform.`

-----

## Function listing

### General Utilities
- `get_data_fns()`
	- Description: ``` Get vector of all filenames in a directory. ```
- `read_wearit_surveydata()`
  - Description: ``` read Wear-It Platform raw exports ```
- `create_data_collection()`
	- Description: ``` Search for specific files and group them for tasks such as merging or comparison. ```
- `merge_data_collection()`
	- Description: ``` Concatenate to a single dataframe, the data n. ```
- `reformat_keyfiles()`
	- Description: ``` reformat key files for easier querying. ```

### Cognitive Task Data Utilities
- `preprocess_cogtask_data()`
	- Description: ``` prepare initial cogtask data. ```
- `unnest_cogtask_data()`
	- Description: ``` unnest JSON cogtask data. ```
- `parsecheck_cogtask_data()`
	- Description: ``` validate that the number of UUIDs matches in input and unnested cogtask data. ```
	
### Pipeline functions

- `study_pipeline_cogtasks()`
	- Description: ``` leveraging a config.json file, crawl a study and prepare cogtask data. ```
- `study_pipeline_survey()`
	- Description: ``` leveraging a config.json file, crawl a study and prepare survey data. ```
- `run_study_datapipeline()`
	- Description: ``` leveraging a config.json file, crawl a study and prepare all (survey, cogtask) data. ```

-----

## Intended Usage of Package

- The intended interface is leveraging/cloning one of our example pipelines (`template/catslife`) that contains a `data` folder (intended for all input data files exported from Wear-IT platform), an `output` folder (intended for any csv outputs from the processes described above), and a JSON configuration (`config.json`) containing relevant study datafile identifiers (survey ids, cognitive task names).

See `templates/catslife/pipeline.R` for a sampling of functions in a brief demo.

-----

Page last updated: `Feb 9 2022`
