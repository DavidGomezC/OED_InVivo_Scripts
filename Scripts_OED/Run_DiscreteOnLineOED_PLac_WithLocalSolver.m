
%%
% Examples of inputs for the function: 

% Identifier = 'Test_Try1';
% ParFull=[1,1,1,1,1,1,1,1,1; 1,1,1,1,1,1,1,1,1]; % The vector or matrix with initial guesses for the parameters
% fit_dat = {}; 
%       fit_dat.mainpath = "."; % Path to the directory with the csv files with past experiments data 
%       fit_dat.files = ["something.csv"]; # Name(s) of the csv file(s) with past experiments data 

function [oed_res, results] = Run_DiscreteOnLineOED_PLac_WithLocalSolver(Identifier, ParFull, fit_dat)
%% First let's run some checks to see that everything is fine. 

    % Check that AMIGO is included in the path
    if exist('AMIGO_Prep', 'file') == 0
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that AMIGO is not in the working path! Please, include it before proceeding.");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end

    % Check that the MINLP scripts versions are also in the path
    if exist('AMIGO_Prep_MINLP', 'file') == 0
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the MINLP verison of AMIGO is not in the working path! Please, include it before proceeding.");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end

    % Check that the model scripts are in the path as well
    if exist('M3D_load_model_Microfluidics_MINLP', 'file') == 0
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the PLac model for OED (discrete) is not in the path! Please, include it before proceeding.");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end


%% Run OED  
    % Set experiment details
    nstep = 4; % Number of steps for the experiment
    maxtim = 12; % Maximum time in hours
    tvec = (1:5:maxtim*60)-1; % Sampling time vector
    switchT = [(1:maxtim*60/nstep:maxtim*60)-1, tvec(end)]; % Switching times vector
    inpbounds = zeros(2,length(switchT)-1); % Set bounds for the inputs. Because we use a discretisation of 5% these are 0 and 20 but the result is multiplied by 5. 
    inpbounds(1,:) = 0;
    inpbounds(2,:) = 20;
    inpbounds(2,1)=0; % Experimetnally, first step is always set to 0. 

    
%% Load Past Experimental Data
    % Check that the file with the experiment data exists and if so, load
    % them and fill the results structure with the details of the
    % experiment. 
    % Fit for only one of the systems will be allowed, so check taht all
    % the data given is from the same system will be done. 
    
    fit_res = {};
    fit_res.exps = {}; % This will contain the detains of the experiment and data extracted from the CSV (makes plotting easier)

    % First we loop to check that all the files exist and that they all
    % come from the same system. 
    for i = 1:length(fit_dat.files)
        
        % First check that the file exists
        if fit_dat.mainpath == "" || fit_dat.mainpath == ''
            datpat = strjoin(([fit_dat.files(i)]), "");
        else
            datpat = strjoin(([fit_dat.mainpath, '\\', fit_dat.files(i)]), "");
        end
        if ~isfile(datpat)
            disp("--------------------------------- WARNING ---------------------------------");
            disp(" ");
            disp("It seems that there is something wrong with the files introduced.");
            disp("Remember that the field files has to be a list of strings and that each file string needs to contain the termination .csv");
            disp(strcat("The issue happened in file number ", num2str(i)));
            disp(" ");
            disp("---------------------------------------------------------------------------");
            return
        end
        
        % Load the CSV file and introduce it in the data structure. 
        try
            tmp1 = readmatrix(datpat);
        catch
            tmp1 = csvread(datpat,1);
        end

        % Extract all information from CSV for the experiment
        fit_res.exps{i}.preIPTG = tmp1(1,1);
        fit_res.exps{i}.time = tmp1(:,3);
        fit_res.exps{i}.IPTGfull = tmp1(:,2);
        fit_res.exps{i}.CitrineMean = tmp1(:,4);
        fit_res.exps{i}.CitrineSD = tmp1(:,5);

        % Put inputs information in events. 
        fit_res = wrapInputDetailsFit(fit_res, i);  
        
    end
    

    % Set AMIGO structure 
    inputs = SetAMIGOStructureOnLineOED(tvec, switchT, inpbounds,Identifier, fit_res, 'eSS');
    inputs2 = SetAMIGOStructureOnLineOED(tvec, switchT, inpbounds,Identifier, fit_res, 'nomad');
    
    AMIGO_Prep_MINLP(inputs);
    
    
    % Run global optimisation
    if ~isfolder(strjoin([".\ResultsOnLineOED\OLOED_", Identifier], ""))
            mkdir(strjoin([".\ResultsOnLineOED\OLOED_", Identifier], ""))
    end

    [k,~] = size(ParFull);

    results = cell(1,k);

    parfor j = 1:k

        if ~isfile(strjoin([".\ResultsOnLineOED\OLOED_", Identifier, "\Run_", j, ".mat"], ""))
            tmpv = ParFull(j,:);
            oedRes = mainRunOnLineOED(inputs, Identifier, tmpv, j);
            results{j} = oedRes;
        else
            oedRes = load(strjoin([".\ResultsOnLineOED\OLOED_", Identifier, "\Run_", j, ".mat"], ""), "oedRes");
            results{j} = oedRes.oedRes;
        end
    end

    cfv = zeros(1,k)+1e200;
    for j=1:k
        try
            cfv(j) = results{j}.minlpsol.fbest;     
        catch
        end
    end
    bcfv = min(cfv);
    bind = find(cfv==bcfv(1));

    oed_res.bestRun = results{bind};
    oed_res.bestRunIndx = bind; 
    
    save(strjoin([".\ResultsOnLineOED\OLOEDres_", Identifier, ".mat"],""), "oed_res", "inputs", "results", "ParFull")


    % Run local MINLP solver from the best gloval solver result. 
    
    if ~isfolder(strjoin([".\ResultsOnLineOED\OLOEDlocal_", Identifier], ""))
            mkdir(strjoin([".\ResultsOnLineOED\OLOEDlocal_", Identifier], ""))
    end
 
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To Check!!!!
    results2 = cell(1,k);
    parfor j = 1:k

        if ~isfile(strjoin([".\ResultsOnLineOED\OLOEDlocal_", Identifier, "\Run_", j, ".mat"], ""))
            tmpv = ParFull(j,:);
            tmpu = results{j}.oed.u{end};
            oedRes2 = mainRunOnLineOED_WithLocalSolver(inputs2, Identifier, tmpv, j, tmpu);
            results2{j} = oedRes2;
        else
            oedRes2 = load(strjoin([".\ResultsOnLineOED\OLOEDlocal_", Identifier, "\Run_", j, ".mat"], ""), "oedRes");
            results2{j} = oedRes2.oedRes;
        end
    end


    %% Select best run by comparing cost function values
    cfv = zeros(1,k)+1e200;
    for j=1:k
        try
            cfv(j) = results2{j}.minlpsol.fbest;     
        catch
        end
    end
    bcfv = min(cfv);
    bind = find(cfv==bcfv(1));

    oed_res.bestRun = results2{bind};
    oed_res.bestRunIndx = bind; 

    save(strjoin([".\ResultsOnLineOED\OLOEDreslocal_", Identifier, ".mat"],""), "oed_res", "inputs", "inputs2", "results", "results2", "ParFull")
    

end