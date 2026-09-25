

% Examples of inputs for the function: 

% Identifier = 'Test_Try1';
% inputDesign=1; % This will be the OED iteration we are designing. 

function [oed_res, results] = Run_DiscreteOED_PLac_WithLocalSolver(Identifier, inputDesign)
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
    nstep = 8; % Number of steps for the experiment
    maxtim = 24; % Maximum time in hours
    tvec = (1:5:maxtim*60)-1; % Sampling time vector
    switchT = [(1:maxtim*60/nstep:maxtim*60)-1, tvec(end)]; % Switching times vector
    inpbounds = zeros(2,length(switchT)-1); % Set bounds for the inputs. Because we use a discretisation of 5% these are 0 and 20 but the result is multiplied by 5. 
    inpbounds(1,:) = 0;
    inpbounds(2,:) = 20;
    inpbounds(2,1)=0; % Experimetnally, first step is always set to 0. 


    % Set AMIGO structure 
    switch inputDesign
        case 1
            inputs = SetAMIGOStructureOED(tvec, switchT, inpbounds,Identifier);
        case {2,3}
            inputs = SetAMIGOStructureOEDSequential(tvec, switchT, inpbounds,Identifier,inputDesign);
    end

    AMIGO_Prep_MINLP(inputs);

    switch inputDesign
        case 1
            ParFull = load('MatrixParametersOED1.mat');disp('Input Design 1');
            ParFull = ParFull.ParFull;
        case 2
            ParFull = load('MatrixParametersOED2.mat');disp('Input Design 2');
            ParFull = ParFull.ParFull;
        case 3
            ParFull = load('MatrixParametersOED3.mat');disp('Input Design 3');
            ParFull = ParFull.ParFull;
        otherwise
            disp('Which input are you trying to design???');
            return
    end

    if ~isfolder(strjoin([".\ResultsOED\OED_", Identifier], ""))
            mkdir(strjoin([".\ResultsOED\OED_", Identifier], ""))
    end

    [k,~] = size(ParFull);

    results = cell(1,k);

    parfor j = 1:k

        if ~isfile(strjoin([".\ResultsOED\OED_", Identifier, "\Run_", j, ".mat"], ""))
        
            tmpv = ParFull(j,:);
            oedRes = mainRunOED(inputs, Identifier, tmpv, j);
            results{j} = oedRes;
        else
            oedRes = load(strjoin([".\ResultsOED\OED_", Identifier, "\Run_", j, ".mat"], ""), "oedRes");
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
    
    save(strjoin([".\ResultsOED\OEDres_", Identifier, ".mat"],""), "oed_res", "inputs", "results", "ParFull")
    

    % Run local MINLP solver from the best gloval solver result. 
    
    if ~isfolder(strjoin([".\ResultsOED\OEDlocal_", Identifier], ""))
            mkdir(strjoin([".\ResultsOED\OEDlocal_", Identifier], ""))
    end
    
    switch inputDesign
        case 1
            inputs2 = SetAMIGOStructureOED_WithLocalSolver(tvec, switchT, inpbounds,Identifier);
        case {2,3}
            inputs2 = SetAMIGOStructureOEDSequential_WithLocalSolver(tvec, switchT, inpbounds,Identifier,inputDesign);
    end
    
    
    results2 = cell(1,k);
    parfor j = 1:k

        if ~isfile(strjoin([".\ResultsOED\OEDlocal_", Identifier, "\Run_", j, ".mat"], ""))
        
            tmpv = ParFull(j,:);
            tmpu = results{j}.oed.u{1};
            oedRes2 = mainRunOED_WithLocalSolver(inputs2, Identifier, tmpv, j, tmpu);
            results2{j} = oedRes2;
        else
            oedRes2 = load(strjoin([".\ResultsOED\OEDlocal_", Identifier, "\Run_", j, ".mat"], ""), "oedRes");
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

    save(strjoin([".\ResultsOED\OEDreslocal_", Identifier, ".mat"],""), "oed_res", "inputs", "inputs2", "results", "results2", "ParFull")
    
 
end






















