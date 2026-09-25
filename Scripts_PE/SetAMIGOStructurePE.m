function [inputs] = SetAMIGOStructurePE(Identifier, fit_res)


    %% Simulation Details
    inputs.ivpsol.ivpsolver='cvodes';
    inputs.ivpsol.senssolver='fdsens5';
    inputs.ivpsol.rtol=1.0D-9;
    inputs.ivpsol.atol=1.0D-9;
    inputs.plotd.plotlevel='noplot';
    
    %% Model details
    inputs.model = M3D_load_model_Microfluidics;
    
    %% COST FUNCTION RELATED DATA details
    inputs.PEsol.PEcost_type='llk';                       % 'lsq' (weighted least squares default) | 'llk' (log likelihood) | 'user_PEcost'
    inputs.PEsol.lsq_type='Q_expmax';                                           % [] To be defined for llk function, 'homo' | 'homo_var' | 'hetero'
    inputs.PEsol.llk_type='hetero';
    
    %% Optimisation details
    inputs.nlpsol.nlpsolver='eSS';
    inputs.nlpsol.eSS.maxeval = 200000;
    inputs.nlpsol.eSS.maxtime = 50000000;
    inputs.nlpsol.eSS.local.solver = 'lsqnonlin'; 
    inputs.nlpsol.eSS.local.finish = 'lsqnonlin'; 
    
    %% Path details
    results_folder = strcat('PLacPE',char(Identifier),'_',datestr(now,'yyyy-mm-dd'));
    short_name     = strcat('PLacPE');
    inputs.pathd.results_folder = results_folder;                        
    inputs.pathd.short_name     = short_name;
    inputs.pathd.runident       = 'initial_setup';

    
    %% Experiment Details
    
    inputs.exps.n_exp = length(fit_res.exps);
    inputs.exps.data_type='real';
    inputs.exps.noise_type='hetero_proportional';
    
    for j = 1:length(fit_res.exps)
        inputs.exps.n_obs{j}=1;                         % Number of observables per experiment
        inputs.exps.obs_names{j} = char('Citrine_AU');
        inputs.exps.obs{j} = char('Citrine_AU = Cit_AU');% Name of the observables 
        
        % To know which model and set of parameters the user wants to load.
        inputs.exps.exp_data{j} = fit_res.exps{j}.CitrineMean;
        inputs.exps.error_data{j} = fit_res.exps{j}.CitrineSD;
        inputs.exps.u{j}= fit_res.exps{j}.inp; 
    
        inputs.exps.t_f{j}=round(fit_res.exps{j}.time(end));          % Experiment duration
        inputs.exps.n_s{j}=length(fit_res.exps{j}.time);              % Number of sampling times
        inputs.exps.t_s{j}=round(fit_res.exps{j}.time)';         % Times of samples
        inputs.exps.u_interp{j}='step';                                % Interpolating function for the input
        inputs.exps.n_steps{j}=length(fit_res.exps{j}.evnT)-1;                  % Number of steps in the input
%         fit_res.inputs.exps.u{j}= fit_res.exps{j}.inp;                            % IPTG values for the input
        inputs.exps.t_con{j}=round(fit_res.exps{j}.evnT);                     % Switching times
        
        inputs.exps.exp_y0{j}=M3D_steady_state_Microfluidics(inputs.model.par,0);
    end

    
%% PE details
    global_theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012,0.01]; % 1/min
    global_theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217,100];
    
    inputs.PEsol.id_global_theta=inputs.model.par_names;                
    inputs.PEsol.global_theta_max=global_theta_max;  % Maximum allowed values for the paramters
    inputs.PEsol.global_theta_min=global_theta_min;  % 
    inputs.PEsol.global_theta_guess = inputs.model.par;


    
    
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
