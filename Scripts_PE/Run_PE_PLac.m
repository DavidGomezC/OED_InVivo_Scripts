
function [pe_res, results] = Run_PE_PLac(Identifier, InitialGuesses, fit_dat)
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

    % Check that the model scripts are in the path as well
    if exist('M3D_load_model_Microfluidics', 'file') == 0
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the PLac model for OED (discrete) is not in the path! Please, include it before proceeding.");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end
    
    fld = ["mainpath", "files"];
    for i = 1:2
        if ~isfield(fit_dat, fld(i))
            disp("--------------------------------- WARNING ---------------------------------");
            disp(" ");
            disp("It seems that the fit_dat (function input) does not have all the fields.");
            disp("These have to be: mainpath, files. All of them must be present.");
            disp(" ");
            disp("---------------------------------------------------------------------------");
            return
        end
    end
    
    
    % Check that the contents of the fields are ok. 
    if ~isa(fit_dat.mainpath, 'string') && ~isa(fit_dat.mainpath, 'char')
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the contents of the field mainpath are wrong.");
        disp("This has to be a string, character or empty string");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end
    
    if ~isa(fit_dat.files, 'string') && ~isa(fit_dat.files, 'char')
        disp("--------------------------------- WARNING ---------------------------------");
        disp(" ");
        disp("It seems that the contents of the field files are wrong.");
        disp("This has to be a list of strings");
        disp(" ");
        disp("---------------------------------------------------------------------------");
        return
    end
    
    
    
    %% Load Experimental Data
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
    inputs = SetAMIGOStructurePE(Identifier, fit_res);
    
    AMIGO_Prep_MINLP(inputs);
     
    
    if ~isfolder(strjoin([".\ResultsPE\PE_", Identifier], ""))
            mkdir(strjoin([".\ResultsPE\PE_", Identifier], ""))
    end

    [k,~] = size(InitialGuesses);

    results = cell(1,k);

    parfor j = 1:k
        if ~isfile(strjoin([".\ResultsPE\PE_", Identifier, "\Run_", j, ".mat"], ""))
        
            tmpv = InitialGuesses(j,:);
            peRes = mainRunPE(inputs, Identifier, tmpv, j);
            results{j} = peRes;
        else
            peRes = load(strjoin([".\ResultsPE\PE_", Identifier, "\Run_", j, ".mat"], ""), "peRes");
            results{j} = peRes.peRes;
        end
    end
    
    
    %% Select best run by comparing cost function values
    cfv = zeros(1,k)+1e300;
    for j=1:k
        try
            cfv(j) = results{j}.nlpsol.fbest;     
        catch
        end
    end
    bcfv = min(cfv);
    bind = find(cfv==bcfv(1));

    pe_res.bestRun = results{bind};
    pe_res.bestRunIndx = bind; 

    save(strjoin([".\ResultsPE\PEres_", Identifier, ".mat"],""), "pe_res", "inputs", "results", "InitialGuesses")
    

    
end























