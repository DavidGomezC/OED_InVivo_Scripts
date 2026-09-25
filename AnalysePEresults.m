
% identif = 'Iter1_try1';

function [] = AnalysePEresults(identif)

    resu = load(strcat(['ResultsPE/PEres_',identif,'.mat']));

    [a,~] = size(resu.InitialGuesses);
    
    % Check for imaginary number in the confidence intervals
    for i = 1:a
        try
            if ~isreal(resu.results{i}.fit.conf_interval)
                f = warndlg(strcat(['Imaginary confidence interval present in run',num2str(i),'!']),'Warning');
            end
        catch
        end
    end
    
    % Simulate system with best parameter vector
    inputs.ivpsol = resu.inputs.ivpsol;
    
    inputs.plotd = resu.inputs.plotd;
    
    inputs.model = resu.inputs.model;
    inputs.model.par = resu.pe_res.bestRun.fit.thetabest';
    
    inputs.pathd = resu.inputs.pathd;
    inputs.pathd.results_folder = strcat([inputs.pathd.results_folder,'_SIM']);
    inputs.pathd.short_name = strcat([inputs.pathd.short_name,'_SIM']);
    
    inputs.exps = resu.inputs.exps;
    for j = 1:inputs.exps.n_exp
        inputs.exps.exp_y0{j} = M3D_steady_state_Microfluidics(inputs.model.par,0);
    end
        
    AMIGO_Prep(inputs);

    sim = AMIGO_SModel(inputs);

    if ~isfolder("ResultsPE\Plots")
        mkdir("ResultsPE\Plots")
    end
    
    % Plot Simualtions
    for i = 1:inputs.exps.n_exp
        h = figure(i);  
        subplot(4,1,1:3)
        hold on
        errorbar(inputs.exps.t_s{i}, inputs.exps.exp_data{i}, inputs.exps.error_data{i}, 'black')
        plot(sim.sim.tsim{i}, sim.sim.states{i}(:,4), 'g','LineWidth',2)
        title(strjoin(["PLac Best Theta Simulation Model ", identif], ""))
        ylabel('Citrine (A.U.)')

        subplot(4,1,4)
        hold on
        stairs(inputs.exps.t_con{i}, [inputs.exps.u{i}, inputs.exps.u{i}(end)])
        ylabel('IPTG (mM)')
        xlabel('time(min)')
        saveas(h,strjoin(["ResultsPE\Plots\SimulPLacExper",num2str(i),"_", identif,".png"],""))
        hold off
    end
    

    % Display cost function convergence
    
    cc = figure();
    hold on
    for i = 1:a
        try
            stairs(resu.results{i}.nlpsol.neval, resu.results{i}.nlpsol.f)
        catch
        end
    end
    set(gca, 'YScale', 'log')
    xlabel("Function Evalueation");
    ylabel("f")
    title(strjoin(["Cost Function ", identif], ""))
    saveas(cc,strjoin(["ResultsPE\Plots\PE_ConvergencePlot_", identif,".png"],""))

end
























