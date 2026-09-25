%% Off-Line OED
% This scripts runs all the necessary steps to perform off-line OED for the
% PLac system considering 3 iterations of the whole process


%% Sample uninformative initial guesses

%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This section is commented to not overwrite the initial matrix so we can
% keep using it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ParFull = LHS_ThetaSampling(100);
% save("Scripts_OED\MatrixParametersOED1.mat","ParFull");

%% Run OED (Iteration 1)
[oed_res, resultsOED] = Run_DiscreteOED_PLac('Iter1_Try1', 1);

%% Generate input file for the microscope (Iteration 1)
GenerateInputFileMicroscope(oed_res, 1);

%% Perform PE with new data (Iteration 1)
%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%
% For the definition of the experiment csv path and file always use " ",
% never ' ' or it won't work. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["17-Dec-2020_Random_corrected.csv"];

ParFull = load('Scripts_PE\MatrixParametersOED1.mat');
ParFull = ParFull.ParFull;

[pe_res, resultsPE] = Run_PE_PLac('Iter1_try1', ParFull, fit_dat);

%% Generate matrix of repeated initial guesses (Iteration 2)
ParFull = RepeatedInitialGuess(pe_res.bestRun.fit.thetabest',100); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersPETest1Results.mat","ParFull");
save("Scripts_OED\MatrixParametersOED2.mat","ParFull");

%% Run OED (Iteration 2)
[oed_res2, resultsOED2] = Run_DiscreteOED_PLac('Iter2_Try1', 2);

%% Generate input file for the microscope (Iteration 2)
GenerateInputFileMicroscope(oed_res2, 2);

%% Perform PE with new data (Iteration 2)
%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%
% For the definition of the experiment csv path and file always use " ",
% never ' ' or it won't work. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["17-Dec-2020_Random_corrected.csv"];

ParFull = load('Scripts_PE\MatrixParametersPETest1Results.mat');
ParFull = ParFull.ParFull;

[pe_res2, resultsPE2] = Run_PE_PLac('Iter2_try1', ParFull, fit_dat);

%% Generate matrix of repeated initial guesses (Iteration 3)
ParFull = RepeatedInitialGuess(pe_res.bestRun.fit.thetabest',100); % Allways call the matrix ParFull!!!
save("Scripts_PE\MatrixParametersPETest2Results.mat","ParFull");
save("Scripts_OED\MatrixParametersOED3.mat","ParFull");

%% Run OED (Iteration 3)
[oed_res3, resultsOED3] = Run_DiscreteOED_PLac('Iter3_Try1', 3);

%% Generate input file for the microscope (Iteration 3)
GenerateInputFileMicroscope(oed_res3, 3);

%% Perform PE with new data (Iteration 3)
%%%%%%%%%%%%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%%%%%%%%
% For the definition of the experiment csv path and file always use " ",
% never ' ' or it won't work. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fit_dat = {};
fit_dat.mainpath = ".";
fit_dat.files = ["17-Dec-2020_Random_corrected.csv"];

ParFull = load('Scripts_PE\MatrixParametersPETest1Results.mat');
ParFull = ParFull.ParFull;

[pe_res3, resultsPE3] = Run_PE_PLac('Iter3_try1', ParFull, fit_dat);

% 
%                                       **
%                                      ****                             
%                                   **********                          
%                                ****************                       
%                           **************************                  
%                   ******************************************          
%          ************************** THE END ************************** 
%                   ******************************************          
%                           **************************                  
%                                ****************                       
%                                    **********                          
%                                      ****                             
%                                       **











