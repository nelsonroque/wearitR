library(wearitR)

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# repeat steps above with new function -----
beep_survey1 = wearitR::read_wearit_survey("data/wear_it_data_v2/1035_Beeped_Survey_1_2022-01-19.csv")
View(beep_survey1$keytable)
View(beep_survey1$clean_data)

beep_survey2 = wearitR::read_wearit_survey("data/wear_it_data_v2/1035_Beeped_Survey_2_2022-01-19.csv")
View(beep_survey2$keytable)
View(beep_survey2$clean_data)

# should all beep surveys have same labels?
beep_survey2$keytable$wearit_col_label == beep_survey1$keytable$wearit_col_label

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# create codebook ----

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>