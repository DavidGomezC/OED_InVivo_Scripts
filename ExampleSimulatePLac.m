% This is the identifier used to perform PE
identif = 'OnLinePostPE_Iter1_try1';

% As for PE, the path to the CSV files containing experimetnal data
fit_dat = {};
fit_dat.mainpath = "D:\ExperimentalData_PLac\ExperimentalData_OfflineOED";
fit_dat.files = ["04-Jun-2021_OfflineOED1_Rep1-Corrected_Average_Data.csv", "07-Jun-2021_OfflineOED1_Rep2-Corrected_Average_Data.csv"];

% Identifier to give to the resultant plots. Ideally say from where does
% theta come and what is being simulated. 
Identifier = 'ThetaFromSomewhere_DataFromSomewhere';


[sim] = SimulatePLacGen(identif, fit_dat, Identifier);

