function [inputs] = SetAMIGOStructureOEDSequential(tvec, switchT, inpbounds, Identifier,inputDesign)


    %% Simulation Details
    inputs.ivpsol.ivpsolver='cvodes';
    inputs.ivpsol.senssolver='cvodes';
    inputs.ivpsol.rtol=1.0D-8;
    inputs.ivpsol.atol=1.0D-8;
    inputs.plotd.plotlevel='noplot';
    
    %% Model details
    M3D_load_model_Microfluidics_MINLP;
    inputs.model = model;
    
    
    %% OPTIMIZATION details
    inputs.exps.n_exp = inputDesign;
    
    switch inputDesign
        case 2
            if isfile(['ResultsOED\InputFiles\OEDInput_PLac_Iter',num2str(inputDesign-1),'.txt'])
                fid = fopen(['ResultsOED\InputFiles\OEDInput_PLac_Iter',num2str(inputDesign-1),'.txt']);
                inp = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
                fclose(fid);
                inp = inp(~cellfun('isempty',inp));
                inpoed = zeros(1,length(inp)-1);
                for k = 2:length(inp)
                    inpoed(k-1) = str2double(inp{k});
                end
            else
                fid = fopen(['ResultsOED\InputFiles\OEDlocalInput_PLac_Iter',num2str(inputDesign-1),'.txt']);
                inp = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
                fclose(fid);
                inp = inp(~cellfun('isempty',inp));
                inpoed = zeros(1,length(inp)-1);
                for k = 2:length(inp)
                    inpoed(k-1) = str2double(inp{k});
                end
            end
        case 3
            if isfile(['ResultsOED\InputFiles\OEDInput_PLac_Iter',num2str(inputDesign-1),'.txt'])
                fid = fopen(['ResultsOED\InputFiles\OEDInput_PLac_Iter',num2str(inputDesign-1),'.txt']);
                inp = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
                fclose(fid);
                inp = inp(~cellfun('isempty',inp));
                inpoed = zeros(1,length(inp)-1);
                for k = 2:length(inp)
                    inpoed(k-1) = str2double(inp{k});
                end
            else
                fid = fopen(['ResultsOED\InputFiles\OEDlocalInput_PLac_Iter',num2str(inputDesign-1),'.txt']);
                inp = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
                fclose(fid);
                inp = inp(~cellfun('isempty',inp));
                inpoed = zeros(1,length(inp)-1);
                for k = 2:length(inp)
                    inpoed(k-1) = str2double(inp{k});
                end
            end
            
            if isfile(['ResultsOED\InputFiles\OEDInput_PLac_Iter',num2str(inputDesign-2),'.txt'])
                fid = fopen(['ResultsOED\InputFiles\OEDInput_PLac_Iter',num2str(inputDesign-2),'.txt']);
                inp = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
                fclose(fid);
                inp = inp(~cellfun('isempty',inp));
                inpoed2 = zeros(1,length(inp)-1);
                for k = 2:length(inp)
                    inpoed2(k-1) = str2double(inp{k});
                end
            else
                fid = fopen(['ResultsOED\InputFiles\OEDlocalInput_PLac_Iter',num2str(inputDesign-2),'.txt']);
                inp = strsplit(regexprep(fgetl(fid),'\t+',' '), ' ');
                fclose(fid);
                inp = inp(~cellfun('isempty',inp));
                inpoed2 = zeros(1,length(inp)-1);
                for k = 2:length(inp)
                    inpoed2(k-1) = str2double(inp{k});
                end
            end
            
            inputs.exps.u{1}=inpoed/5;
            inputs.exps.u_interp{1}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
            inputs.exps.n_steps{1}=round(length(switchT)-1);         % Number of steps in the input
            inputs.exps.t_con{1}=switchT;            % Switching times
            inputs.exps.std_dev{1}=[0.10];
            inputs.exps.exp_type{1}='fixed';
            
            inputs.exps.u{2}=inpoed2/5;
            inputs.exps.u_interp{2}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
            inputs.exps.n_steps{2}=round(length(switchT)-1);         % Number of steps in the input
            inputs.exps.t_con{2}=switchT;            % Switching times
            inputs.exps.std_dev{2}=[0.10];
            inputs.exps.exp_type{2}='fixed';
            
    end
    
    
    
    inputs.exps.u{1}=inpoed/5;
    inputs.exps.u_interp{1}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
    inputs.exps.n_steps{1}=round(length(switchT)-1);         % Number of steps in the input
    inputs.exps.t_con{1}=switchT;            % Switching times
    inputs.exps.std_dev{1}=[0.10];
    inputs.exps.exp_type{1}='fixed';
    
    
    
    inputs.exps.u_type{inputDesign}='od';
    inputs.exps.u_interp{inputDesign}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
    inputs.exps.n_steps{inputDesign}=round(length(switchT)-1);         % Number of steps in the input
    inputs.exps.t_con{inputDesign}=switchT;            % Switching times
    inputs.exps.u_min{inputDesign}=round(inpbounds(1,:));    % Lower boundary for the input value
    inputs.exps.u_max{inputDesign}=round(inpbounds(2,:)); % Upper boundary for the input value
%     inputs.exps.noise_type='hetero';           % Experimental noise type: Homoscedastic: 'homo'|'homo_var'(default)
    inputs.exps.std_dev{inputDesign}=[0.10];
    inputs.OEDsol.OEDcost_type= 'Eopt';
    inputs.exps.exp_type{inputDesign}='od';
    % OPTIMIZATION
%     %oidDuration=600;
    inputs.minlpsol.minlpsolver='eSS';
switch inputs.minlpsol.minlpsolver
%     opts = 
%          solver: 'nomad'
%         maxiter: 1500
%        maxfeval: 10000
%        maxnodes: 10000
%         maxtime: 1000
%         tolrfun: 1.0000e-07
%         tolafun: 1.0000e-07
%          tolint: 1.0000e-05
%      solverOpts: []
%     dynamicOpts: []
%         iterfun: []
%        warnings: 'critical'
%         display: 'iter'
%      derivCheck: 'off'

    case {'Nomad','nomad'}
%%%%%%%%%%%%%%%%%%%%%%%%%%%% NOMAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        inputs.minlpsol.nomad.maxfeval = 6e6;
        inputs.minlpsol.nomad.maxiter = 6e6;
        inputs.minlpsol.nomad.maxtime = 6e10;
        inputs.minlpsol.nomad.xtype = 'IIIIIII'; % I=Integer, C=Continuous, B=Binary
        inputs.minlpsol.nomad.history_file = ['History_', short_name, '.csv'];
        inputs.minlpsol.nomad.stats_file = ['Stats_', short_name, '.csv'];
    
    case {'eSS','ess'}
%%%%%%%%%%%%%%%%%%%%%%%%%%%% eSS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        inputs.minlpsol.ess.maxeval = 4e5;
        inputs.minlpsol.ess.maxtime = 6e20;
        inputs.minlpsol.ess.int_var = length(switchT)-1; % I=Integer, C=Continuous, B=Binary
        inputs.minlpsol.ess.log_var=[];
        inputs.minlpsol.ess.tolc = 1e-7;
        inputs.minlpsol.ess.local.solver = 0;%'misqp';

    case {'VNS','vns'}
%%%%%%%%%%%%%%%%%%%%%%%%%%%% VNS %%%%%%%%%%%%%%%%%%%%%%%%%%%%

        inputs.minlpsol.vns.maxeval = 6e5;
        inputs.minlpsol.vns.maxtime = 1e5;
        inputs.minlpsol.vns.maxdist = 0.5;
        inputs.minlpsol.vns.use_local = 1; % 1 = yes, 0 = no
    
    case {'GA','ga'}    
%%%%%%%%%%%%%%%%%%%%%%%%%%%% GenAlg %%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    % https://uk.mathworks.com/help/gads/mixed-integer-optimization.html
    % It needs Global Optimization Toolbox to be installed
    
        inputs.minlpsol.ga.nvars = inputs.exps.n_steps{1};
        inputs.minlpsol.ga.IntCon = [1:inputs.minlpsol.ga.nvars];


        inputs.minlpsol.ga.PopulationSize = (min(max(10*inputs.minlpsol.ga.nvars,40),100));
        inputs.minlpsol.ga.ConstraintTolerance = 1e-3;
        inputs.minlpsol.ga.CrossoverFcn = 'crossoverscattered';
        inputs.minlpsol.ga.CrossoverFraction = 0.8;
        inputs.minlpsol.ga.Display = 'off';
        inputs.minlpsol.ga.EliteCount = ceil(0.05*inputs.minlpsol.ga.PopulationSize);
        inputs.minlpsol.ga.FitnessLimit = -Inf;
        inputs.minlpsol.ga.FitnessScalingFcn = 'fitscalingrank';
        inputs.minlpsol.ga.FunctionTolerance = 1e-6;
        inputs.minlpsol.ga.MaxGenerations = 100*inputs.minlpsol.ga.nvars;
        inputs.minlpsol.ga.MaxStallGenerations = 50;
        inputs.minlpsol.ga.MaxTime = Inf;
        inputs.minlpsol.ga.MigrationFraction = 0.2;
        inputs.minlpsol.ga.MigrationInterval = 20;
    
%     case {'ACO', 'aco'}    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%% ACO %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%         inputs.minlpsol.aco.nint=inputs.exps.n_steps{1};
%         inputs.minlpsol.aco.acc = 1e-10;        % Restriction tolerance and termination criterion for local solver
%         inputs.minlpsol.aco.maxit = 3;  % Maxim number iterations 100000000
%         inputs.minlpsol.aco.maxun = 3;  % Maximum number of consecutive iterations without improvement 100000000
%         inputs.minlpsol.aco.maxfun = 3;   % Maximum function evaluations 1000000
%         inputs.minlpsol.aco.maxtime = 3;        % Maximum time for solver run (in seconds)
%         inputs.minlpsol.aco.startloc = false;   % Start with local solver run (true/false)
%         inputs.minlpsol.aco.maxeval = 3;  % maximal evaluations (e.g. 1000000)
%         inputs.minlpsol.aco.oracle  = -Inf; % oracle parameter for penalty function
%         inputs.minlpsol.aco.ants  = 3; % default 1000
%     
%     case {'MITS', 'mits'}
% %%%%%%%%%%%%%%%%%%%%%%%%%%%% MITS %%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%         inputs.minlpsol.mits.nint = inputs.exps.n_steps{1};
%         inputs.minlpsol.mits.acc = 1e-7; % The user has to specify the desired final accuracy
%     %               (e.g. 1.0D-7) for the constraints and as a termination criterion
%     %               for the local solver.
%         inputs.minlpsol.mits.maxit = 6e5; % Maximum number of iterations, where one iteration corresponds to
%     %               one evaluation of the neighbourhood and maybe an additional
%     %               start of the local solver.
%         inputs.minlpsol.mits.maxun = 500; % The algorithm will stop after the maximum number of consecutive
%     %               iterations without improvement has been reached.
%         inputs.minlpsol.mits.maxtime = 1e5; %  Maximum time for MITS run in seconds.
%         inputs.minlpsol.mits.maxfun = 6e5; % Maximum number of function evaluations. 
%     
end




    %% Path details
    results_folder = strcat('DISCOED2',Identifier,'_',datestr(now,'yyyy-mm-dd'));
    short_name     = strcat('DISCOED2');
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_setup';

    
    %% Experiment Details
    
%     inputs.exps.data_type='real';
    inputs.exps.noise_type='hetero_proportional';
    

    inputs.exps.n_s{1}=length(tvec);              % Number of sampling times
    inputs.exps.t_f{1}=round(tvec(end));          % Experiment duration
    inputs.exps.t_s{1}=round(tvec);         % Times of samples    

    inputs.exps.n_obs{1}=1;                         % Number of observables per experiment
    inputs.exps.obs_names{1} = char('Citrine_AU');
    inputs.exps.obs{1} = char('Citrine_AU = Cit_AU');% Name of the observables 
 
    inputs.exps.exp_y0{1}=M3D_steady_state_Microfluidics_MINLP(inputs.model.par,0);
    
    if inputDesign == 3
        inputs.exps.n_s{2}=length(tvec);              % Number of sampling times
        inputs.exps.t_f{2}=round(tvec(end));          % Experiment duration
        inputs.exps.t_s{2}=round(tvec);         % Times of samples    

        inputs.exps.n_obs{2}=1;                         % Number of observables per experiment
        inputs.exps.obs_names{2} = char('Citrine_AU');
        inputs.exps.obs{2} = char('Citrine_AU = Cit_AU');% Name of the observables 

        inputs.exps.exp_y0{2}=M3D_steady_state_Microfluidics_MINLP(inputs.model.par,0);
    end
    
    
    
    inputs.exps.n_s{inputDesign}=length(tvec);              % Number of sampling times
    inputs.exps.t_f{inputDesign}=round(tvec(end));          % Experiment duration
    inputs.exps.t_s{inputDesign}=round(tvec);         % Times of samples    

    inputs.exps.n_obs{inputDesign}=1;                         % Number of observables per experiment
    inputs.exps.obs_names{inputDesign} = char('Citrine_AU');
    inputs.exps.obs{inputDesign} = char('Citrine_AU = Cit_AU');% Name of the observables 
    


    inputs.exps.exp_y0{inputDesign}=M3D_steady_state_Microfluidics_MINLP(inputs.model.par,0);
    
%% PE details
    global_theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012,0.01]; % 1/min
    global_theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217,100];
    
    inputs.PEsol.id_global_theta=inputs.model.par_names;                
    inputs.PEsol.global_theta_max=global_theta_max;  % Maximum allowed values for the paramters
    inputs.PEsol.global_theta_min=global_theta_min;  % 
    inputs.PEsol.global_theta_guess = inputs.model.par;



end