%% On-Line OED
% This scripts runs all the necessary steps to perform on-line OED for the
% PLac system considering 3 iterations of the whole process. The steps
% included here are only the ones that do not need to be done in the
% microscope room (e.g. PE after the full experiment and OED of the first
% segment for the next experiment). 


%% Generate matrix of repeated initial guesses (Iteration 1)

% Here you should load the theta coming from the PE of the first
% subexperiment since this is the best current estimate (you can use random
% values, but then you would ignore the information from the first step).

thetabest = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this script I am setting everything to have only 32 parallel 
% runs since that is what happens in the microscope room. If you 
% wanna set it to 100 as it is in the off-line OED just change the
% input in the functions from 32 to 100.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ParFull = RepeatedInitialGuess(thetabest',32); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersOnLineOED_FirstSubExp_Iter1.mat","ParFull");
save("Scripts_OED\MatrixParametersOnLineOED_FirstSubExp_Iter1.mat","ParFull");


%% Perform PE with new data (Iteration 1)
%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%
% For the definition of the experiment csv path and file always use " ",
% never ' ' or it won't work. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["something.csv"];

ParFull = load('Scripts_PE\MatrixParametersOnLineOED_FirstSubExp_Iter1.mat');
ParFull = ParFull.ParFull;

[pe_res, resultsPE] = Run_PE_PLac('OnLinePostPE_Iter1_try1', ParFull, fit_dat);

%% Generate matrix of repeated initial guesses (Iteration 2)

ParFull = RepeatedInitialGuess(pe_res.bestRun.fit.thetabest',32); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersOnLineOED_Exp1_Iter2.mat","ParFull");
save("Scripts_OED\MatrixParametersOnLineOED_Exp1_Iter2.mat","ParFull");

%% Run OED (Iteration 2)

% These will be the csv files with the past onLine OED experiments data to
% be included in the computation of the FIM. 
fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["something.csv"];

ParFull = load('Scripts_PE\MatrixParametersOnLineOED_Exp1_Iter2.mat');
ParFull = ParFull.ParFull;

% fit_dat = {};
% fit_dat.mainpath = "E:\UNI\D_Drive\PhD\GitHub\PLacToggle\PLacToggle_Project\ExperimentsCsvFiles\PLac_Corrected";
% fit_dat.files = ["17-Dec-2020_Random_corrected.csv"];
% 
% ParFull = load('Scripts_PE\MatrixParametersOED1.mat');
% ParFull = ParFull.ParFull;
% Identifier = 'OnLineFirstHalf_Iter2_Try1';

[oed_res, resultsOED] = Run_DiscreteOnLineOED_PLac_WithLocalSolver('OnLineFirstHalf_Iter2_Try1', ParFull, fit_dat);

%% Generate input file for the microscope (Iteration 2)

%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%
% The second input to the following function has to be the same identifier
% you put in the previous function. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GenerateInputFileMicroscopeOnLine_WithLocalSolver(oed_res,'OnLineFirstHalf_Iter2_Try1');





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 2nd On Line Experiment!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!







%% Generate matrix of repeated initial guesses (Iteration 2)

% Here you should load the theta coming from the PE of the first
% subexperiment since this is the best current estimate (you can use random
% values, but then you would ignore the information from the first step).

thetabest = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this script I am setting everything to have only 32 parallel 
% runs since that is what happens in the microscope room. If you 
% wanna set it to 100 as it is in the off-line OED just change the
% input in the functions from 32 to 100.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ParFull = RepeatedInitialGuess(thetabest',32); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersOnLineOED_FirstSubExp_Iter2.mat","ParFull");
save("Scripts_OED\MatrixParametersOnLineOED_FirstSubExp_Iter2.mat","ParFull");


%% Perform PE with new data (Iteration 2)
%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%
% For the definition of the experiment csv path and file always use " ",
% never ' ' or it won't work. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["something.csv", "somethingelse.csv"];

ParFull = load('Scripts_PE\MatrixParametersOnLineOED_FirstSubExp_Iter2.mat');
ParFull = ParFull.ParFull;

[pe_res2, resultsPE2] = Run_PE_PLac('OnLinePostPE_Iter2_try1', ParFull, fit_dat);

%% Generate matrix of repeated initial guesses (Iteration 3)

ParFull = RepeatedInitialGuess(pe_res2.bestRun.fit.thetabest',32); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersOnLineOED_Exp1_Iter3.mat","ParFull");
save("Scripts_OED\MatrixParametersOnLineOED_Exp1_Iter3.mat","ParFull");

%% Run OED (Iteration 3)

% These will be the csv files with the past onLine OED experiments data to
% be included in the computation of the FIM. 
fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["something.csv", "somethingelse.csv"];

ParFull = load('Scripts_PE\MatrixParametersOnLineOED_Exp1_Iter3.mat');
ParFull = ParFull.ParFull;

% fit_dat = {};
% fit_dat.mainpath = "E:\UNI\D_Drive\PhD\GitHub\PLacToggle\PLacToggle_Project\ExperimentsCsvFiles\PLac_Corrected";
% fit_dat.files = ["17-Dec-2020_Random_corrected.csv"];
% 
% ParFull = load('Scripts_PE\MatrixParametersOED1.mat');
% ParFull = ParFull.ParFull;
% Identifier = 'OnLineFirstHalf_Iter2_Try1';

[oed_res2, resultsOED2] = Run_DiscreteOnLineOED_PLac_WithLocalSolver('OnLineFirstHalf_Iter3_Try1', ParFull, fit_dat);

%% Generate input file for the microscope (Iteration 2)

%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%
% The second input to the following function has to be the same identifier
% you put in the previous function. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

GenerateInputFileMicroscopeOnLine_WithLocalSolver(oed_res2,'OnLineFirstHalf_Iter3_Try1');









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 3rd On Line Experiment!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!









%% Generate matrix of repeated initial guesses (Iteration 2)

% Here you should load the theta coming from the PE of the first
% subexperiment since this is the best current estimate (you can use random
% values, but then you would ignore the information from the first step).

thetabest = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%%
% In this script I am setting everything to have only 32 parallel 
% runs since that is what happens in the microscope room. If you 
% wanna set it to 100 as it is in the off-line OED just change the
% input in the functions from 32 to 100.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ParFull = RepeatedInitialGuess(thetabest',32); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersOnLineOED_FirstSubExp_Iter3.mat","ParFull");
save("Scripts_OED\MatrixParametersOnLineOED_FirstSubExp_Iter3.mat","ParFull");


%% Perform PE with new data (Iteration 2)
%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%
% For the definition of the experiment csv path and file always use " ",
% never ' ' or it won't work. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["something.csv", "somethingelse.csv", "evensomethingelse.csv"];

ParFull = load('Scripts_PE\MatrixParametersOnLineOED_FirstSubExp_Iter3.mat');
ParFull = ParFull.ParFull;

[pe_res3, resultsPE3] = Run_PE_PLac('OnLinePostPE_Iter3_try1', ParFull, fit_dat);
























