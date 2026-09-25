

function [] = AnalyseOEDresults(identif)

    resu = load(strcat(['ResultsOED/OEDres_',identif,'.mat']));
    
    if isfile(strcat(['ResultsOED/OEDreslocal_',identif,'.mat']))
        resuLoc = load(strcat(['ResultsOED/OEDreslocal_',identif,'.mat']));
    else
        resuLoc = [];
    end

    a = length(resu.results);
    
    % Check for imaginary number in the confidence intervals
    for i = 1:a
        try
            if ~isreal(resu.results{i}.fit.conf_interval)
                f = warndlg(strcat(['Imaginary confidence interval present in run',num2str(i),'!']),'Warning');
            end
        catch
        end
    end
    
    if ~isfolder("ResultsOED\Plots")
        mkdir("ResultsOED\Plots")
    end
    
    % Plot convergence curve OED global solver
    cc = figure();
    hold on
    for i = 1:a
        try
            stairs(resu.results{i}.minlpsol.neval, resu.results{i}.minlpsol.f)
        catch
        end
    end
    set(gca, 'YScale', 'log')
    xlabel("Function Evalueation");
    ylabel("f")
    title(strjoin(["Cost Function Gloval Solver ", identif], ""))
    saveas(cc,strjoin(["ResultsOED\Plots\OED_ConvergencePlot_GlobalSolver_", identif,".png"],""))
    
    
    % Plot convergence curve OED local solver
    if ~isempty(resuLoc)
        cc = figure();
        hold on
        for i = 1:a
            try
                concurv = zeros(1,length(resuLoc.results2{i}.minlpsol.toteval));
                concurv(1,1) = resuLoc.results2{i}.minlpsol.f(1);
                for j = 2:length(resuLoc.results2{i}.minlpsol.toteval)
                     if resuLoc.results2{i}.minlpsol.f(j) < concurv(1,j-1)
                         concurv(1,j) = resuLoc.results2{i}.minlpsol.f(j);
                     else
                         concurv(1,j) = concurv(1,j-1);
                     end
                end
                
                stairs(resuLoc.results2{i}.minlpsol.toteval, concurv)
            catch
            end
        end
        xlabel("Function Evalueation");
        ylabel("f")
        title(strjoin(["Cost Function Local Solver ", identif], ""))
        saveas(cc,strjoin(["ResultsOED\Plots\OED_ConvergencePlot_LocalSolver_", identif,".png"],""))
    end
    
    
    
    

end




















