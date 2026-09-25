
% identif = 'Iter1_try1';
% 
% fit_dat = {};
% fit_dat.mainpath = "E:\UNI\D_Drive\PhD\GitHub\PLacToggle\PLacToggle_Project\ExperimentsCsvFiles\PLac_Corrected";
% fit_dat.files = ["17-Dec-2020_Random_corrected.csv"];
% 
% Identifier = 'RandomExper_ThetaFromTest1';

function [sim] = SimulatePLacGen(identif, fit_dat, Identifier)

    resu = load(strcat(['ResultsPE/PEres_',identif,'.mat']));

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

    inputsPre = SetAMIGOStructurePE(Identifier, fit_res);
    
    
    % Simulate system with best parameter vector
    inputs.ivpsol = inputsPre.ivpsol;
    
    inputs.plotd = inputsPre.plotd;
    
    inputs.model = inputsPre.model;
    inputs.model.par = resu.pe_res.bestRun.fit.thetabest';
    
    inputs.pathd = inputsPre.pathd;
    inputs.pathd.results_folder = strcat([inputsPre.pathd.results_folder,'_SIM']);
    inputs.pathd.short_name = strcat([inputsPre.pathd.short_name,'_SIM']);
    
    inputs.exps = inputsPre.exps;
    for j = 1:inputs.exps.n_exp
        inputs.exps.exp_y0{j} = M3D_steady_state_Microfluidics(resu.pe_res.bestRun.fit.thetabest',0);
    end
        
    AMIGO_Prep(inputs);

    sim = AMIGO_SModel(inputs);
    
    save(['Simulation_', Identifier, '_ThetaFrom-',identif, '.mat'],'sim','inputs','identif')
    
    if ~isfolder("SimulateModels\Plots")
        mkdir("SimulateModels\Plots")
    end

    % Plot Simualtions
    for i = 1:inputs.exps.n_exp
        h = figure(i);  
        subplot(4,1,1:3)
        hold on
        errorbar(inputs.exps.t_s{i}, inputs.exps.exp_data{i}, inputs.exps.error_data{i}, 'black')
        plot(sim.sim.tsim{i}, sim.sim.states{i}(:,4), 'g','LineWidth',2)
        title(strjoin(["PLac Simulation ", Identifier], ""))
        ylabel('Citrine (A.U.)')

        subplot(4,1,4)
        hold on
        stairs(inputs.exps.t_con{i}, [inputs.exps.u{i}, inputs.exps.u{i}(end)])
        ylabel('IPTG (mM)')
        xlabel('time(min)')
        saveas(h,strjoin(["SimulateModels\Plots\SimulPLacExper",num2str(i),"_", Identifier, '_ThetaFrom-',identif,".png"],""))
        hold off
    end



end