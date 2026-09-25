

function [inputs] = SetAMIGOStructureOnLineOED(tvec, switchT, inpbounds,Identifier, fit_res, solverOED)

    %% Simulation Details
    inputs.ivpsol.ivpsolver='cvodes';
    inputs.ivpsol.senssolver='cvodes';
    inputs.ivpsol.rtol=1.0D-8;
    inputs.ivpsol.atol=1.0D-8;
    inputs.plotd.plotlevel='noplot';
    
    %% Model details
    M3D_load_model_Microfluidics_MINLP;
    inputs.model = model;
    
    %% Path details
    results_folder = strcat('DISCOLOED2',char(Identifier),'_',datestr(now,'yyyy-mm-dd'));
    short_name     = strcat('DISCOLOED2');
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_setup';

    %% Experiments deffinition
    inputs.exps.n_exp = length(fit_res.exps)+1;

    for exp = 1:length(fit_res.exps)
        
        inputs.exps.u{exp}=round(fit_res.exps{exp}.inp/5);
        inputs.exps.u_interp{exp}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
        inputs.exps.n_steps{exp}=round(length(fit_res.exps{exp}.inp));         % Number of steps in the input
        inputs.exps.t_con{exp}=fit_res.exps{exp}.evnT;            % Switching times
        inputs.exps.std_dev{exp}=[0.10];
        inputs.exps.exp_type{exp}='fixed';
        
        inputs.exps.n_s{exp}=length(fit_res.exps{exp}.time);              % Number of sampling times
        inputs.exps.t_f{exp}=round(fit_res.exps{exp}.evnT(end));          % Experiment duration
        inputs.exps.t_s{exp}=round(fit_res.exps{exp}.time)';         % Times of samples    

        inputs.exps.n_obs{exp}=1;                         % Number of observables per experiment
        inputs.exps.obs_names{exp} = char('Citrine_AU');
        inputs.exps.obs{exp} = char('Citrine_AU = Cit_AU');% Name of the observables 

        inputs.exps.exp_y0{exp}=M3D_steady_state_Microfluidics_MINLP(inputs.model.par,0);
        
        
    end

    inputs.exps.noise_type='hetero_proportional';

    inputs.exps.u_type{length(fit_res.exps)+1}='od';
    inputs.exps.u_interp{length(fit_res.exps)+1}='stepf';                             % Stimuli definition for experiment: 'stepf' steps of constant duration
    inputs.exps.n_steps{length(fit_res.exps)+1}=round(length(switchT)-1);         % Number of steps in the input
    inputs.exps.t_con{length(fit_res.exps)+1}=switchT;            % Switching times
    inputs.exps.u_min{length(fit_res.exps)+1}=round(inpbounds(1,:));    % Lower boundary for the input value
    inputs.exps.u_max{length(fit_res.exps)+1}=round(inpbounds(2,:)); % Upper boundary for the input value
    inputs.exps.std_dev{length(fit_res.exps)+1}=[0.10];
    inputs.exps.exp_type{length(fit_res.exps)+1}='od';

    inputs.exps.n_s{length(fit_res.exps)+1}=length(tvec);              % Number of sampling times
    inputs.exps.t_f{length(fit_res.exps)+1}=round(tvec(end));          % Experiment duration
    inputs.exps.t_s{length(fit_res.exps)+1}=round(tvec);         % Times of samples    

    inputs.exps.n_obs{length(fit_res.exps)+1}=1;                         % Number of observables per experiment
    inputs.exps.obs_names{length(fit_res.exps)+1} = char('Citrine_AU');
    inputs.exps.obs{length(fit_res.exps)+1} = char('Citrine_AU = Cit_AU');% Name of the observables 

    inputs.exps.exp_y0{length(fit_res.exps)+1}=M3D_steady_state_Microfluidics_MINLP(inputs.model.par,0);


    %% Optimisation settings
    if length(fit_res.exps) == 0
        inputs.OEDsol.OEDcost_type= 'Dopt';
    else
        inputs.OEDsol.OEDcost_type= 'Eopt';
    end
    
    inputs.minlpsol.minlpsolver=solverOED;

    switch inputs.minlpsol.minlpsolver
            case {'Nomad','nomad'}
        %%%%%%%%%%%%%%%%%%%%%%%%%%%% NOMAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%
                inputs.minlpsol.nomad.maxfeval = 6e3;
                inputs.minlpsol.nomad.maxiter = 6e3;
                inputs.minlpsol.nomad.maxtime = 6e10;
                inputs.minlpsol.nomad.xtype = 'IIIIIIII'; % I=Integer, C=Continuous, B=Binary
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
    end
    
    %% PE details
    global_theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012,0.01]; % 1/min
    global_theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217,100];
    
    inputs.PEsol.id_global_theta=inputs.model.par_names;                
    inputs.PEsol.global_theta_max=global_theta_max;  % Maximum allowed values for the paramters
    inputs.PEsol.global_theta_min=global_theta_min;  % 
    inputs.PEsol.global_theta_guess = inputs.model.par;
   


end






























