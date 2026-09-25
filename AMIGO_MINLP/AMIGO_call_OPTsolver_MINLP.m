% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_call_OPTsolver.m 2528 2016-03-04 11:05:22Z evabalsa $
function [results,privstruct]=AMIGO_call_OPTsolver_MINLP(optproblem,minlpsolver,vguess,vmin,vmax,inputs,results,privstruct)
% AMIGO_call_OPTsolver:  Calls the optimization solver selected by user for PE
%
%******************************************************************************
% AMIGO2: dynamic modeling, optimization and control of biological systems    % 
% Code development:     Eva Balsa-Canto                                       %
% Address:              Process Engineering Group, IIM-CSIC                   %
%                       C/Eduardo Cabello 6, 36208, Vigo-Spain                %
% e-mail:               ebalsa@iim.csic.es                                    %
% Copyright:            CSIC, Spanish National Research Council               %
%******************************************************************************
%*****************************************************************************%
%                                                                             %
%  AMIGO_call_OPTsolver: Calls the optimization solver selected by user       %
%                        The following alternatives are available:
%                        %
%                                                                             %
%                        LOCAL OPTIMIZATION SOLVERS                           %
%                                                                             %
%                        GLOBAL OPTIMIZATION SOLVERS                          %
%                        >'de': a modification of Differential Evolution      %
%                          which incorporates a new stopping criterion        %
%                          Original reference:                                %
%                          Storn R, Price K: Differential Evolution:a Simple  %
%                          and Efficient Heuristic for Global Optimization    %
%                          over Continuous Spaces. J Global Optim 1997,       %
%                          11:341-359.                                        %
%                        >'sres': Stochastic Ranking Evolutionary Search.     %
%                          Original reference:                                %
%                          Runarsson T, Yao X: Stochastic ranking for         %
%                          constrained evolutionary optimization. IEEE Trans. %
%                          Evolutionary Computation, 2000, 564:284-294.       %
%                        >'ess': Scatter Search                               %
%                          Original reference:                                %
%                          Egea JA, Rodriguez-Fernandez M, Banga J, Marti R:  %
%                          Scatter Search for Chemical and Bio-Process        %
%                          Optimization. J Glob Opt 2007, 37(3):481-503.      %
%                        >'globalm': Clustering method for constrained        %
%                          global optimization.                               %
%                          Original reference:                                %
%                          Csendes, T., L. Pal, J.O.H. Sendin, J.R. Banga     %
%                          (2008) The GLOBAL Optimization Method Revisited.   %
%                          Optimization Letters, 2(4):445-454.                %
%                        >'hyb_sres_*' sequential hybrid combining sres       %
%                           with available local solvers                      %
%                        >'hyb_de_*' sequential hybrid combining de with      %
%                           available local solvers                           %
%*****************************************************************************%


if privstruct.print_flag==1
    fprintf(1,'\n*************************************************************************\n');
    fprintf(1,'\n\n------>IMPORTANT!!: Most of the optimization solvers have their own\n');
    fprintf(1,'                    tunning parameters (options).\n');
    fprintf(1,'                    Defaults have been assigned in the *MINLPsolver*_options\n');
    fprintf(1,'                    files. You may need to modify those settings for your\n');
    fprintf(1,'                    particular problem, specially:\n');
    fprintf(1,'                      - maximum number of function evaluations /iterations,\n');
    fprintf(1,'                      - maximum computational time\n');
    
    pause(2)
    
    fprintf(1,'\n\n******************************************************************');
    fprintf(1,'\n\n  Solving the NLP problem with ');
    fprintf(1, minlpsolver);
    fprintf(1,'\n\n');
    
end

switch inputs.model.exe_type
    
    case {'standard','costMex'}
        
        switch minlpsolver
                
            case {'nomad','Nomad'}
                
                %SSM has its own 'structures'.
                problem.x_0=vguess;
                problem.x_L=vmin;
                problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver_MINLP
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        % Nothing for now
                        error('Failure in AMIGO_call_OPTsolver_MINLP: PE is not supported for MINLP problems yet.')
                    case 'OED'
                        
                        problem.f='AMIGO_OEDcost_MINLP';
                        
                end
                
                
                
                if privstruct.ntotal_constraints >0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                    
                end
                
                if privstruct.ntotal_obsconstraints>0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                    
                end
                
                
                if  privstruct.ntotal_tsconstraints>0
                    while exist(inputs.pathd.ssconstraints_ts)==0
                        pause(1) 
                    end
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
                    
                end
                
                %nomad options are defined in inputs.minlpsol.nomad
                
                
                [res_ssm]=nomad_kernel(problem,inputs.minlpsol.nomad,inputs,results,privstruct);
                                
                results.minlpsol.fbest=res_ssm.fbest;
                results.minlpsol.vbest=res_ssm.xbest';
                results.minlpsol.cpu_time=res_ssm.cpu_time;
                results.minlpsol.conv_curve=[res_ssm.evalbest;  res_ssm.fevalbest]';
                results.minlpsol.neval=res_ssm.neval;
                results.minlpsol.toteval=res_ssm.toteval;
                results.minlpsol.f=res_ssm.f;
                results.minlpsol.exit_flag = res_ssm.exitflag;
                results.minlpsol.niter = res_ssm.niter;

            case {'ess','eSS'}
                
                %SSM has its own 'structures'.
                problem.x_0=vguess;
                problem.x_L=vmin;
                problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver_MINLP
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        % Nothing for now
                        error('Failure in AMIGO_call_OPTsolver_MINLP: PE is not supported for MINLP problems yet.')
                    case 'OED'
                        
                        problem.f='AMIGO_OEDcost_MINLP';
                        
                end
                
                
                
                if privstruct.ntotal_constraints >0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                    
                end
                
                if privstruct.ntotal_obsconstraints>0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                    
                end
                
                
                if  privstruct.ntotal_tsconstraints>0
                    while exist(inputs.pathd.ssconstraints_ts)==0
                        pause(1) 
                    end
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
                    
                end
                
                %nomad options are defined in inputs.minlpsol.nomad
                
                problem.int_var = inputs.minlpsol.ess.int_var;
                
                opts.maxeval = inputs.minlpsol.ess.maxeval;
                opts.maxtime = inputs.minlpsol.ess.maxtime;
                opts.iterprint = inputs.minlpsol.ess.iterprint;
                opts.log_var = inputs.minlpsol.ess.log_var;
                opts.tolc = inputs.minlpsol.ess.tolc;
                opts.dim_refset = inputs.minlpsol.ess.dim_refset;
                opts.ndiverse = inputs.minlpsol.ess.ndiverse;
                opts.combination = inputs.minlpsol.ess.combination;
                opts.local.solver= inputs.minlpsol.ess.local.solver;
                opts.local.tol = inputs.minlpsol.ess.local.tol;
                opts.local.iterprint = inputs.minlpsol.ess.local.iterprint;
                opts.local.n1 = inputs.minlpsol.ess.local.n1;
                opts.local.n2 = inputs.minlpsol.ess.local.n2;
                opts.local.finish = inputs.minlpsol.ess.local.finish;
                opts.local.bestx = inputs.minlpsol.ess.local.bestx;
                
                
                [res_ssm]=MEIGO(problem,opts,'ESS',inputs, results, privstruct );
                                
                results.minlpsol = res_ssm;
                results.minlpsol.vbest = res_ssm.xbest;
                
           case {'vns','VNS'}
                
                %SSM has its own 'structures'.
                problem.x_0=vguess;
                problem.x_L=vmin;
                problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver_MINLP
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        % Nothing for now
                        error('Failure in AMIGO_call_OPTsolver_MINLP: PE is not supported for MINLP problems yet.')
                    case 'OED'
                        
                        problem.f='AMIGO_OEDcost_MINLP';
                        
                end
                
                
                
                if privstruct.ntotal_constraints >0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                    
                end
                
                if privstruct.ntotal_obsconstraints>0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                    
                end
                
                
                if  privstruct.ntotal_tsconstraints>0
                    while exist(inputs.pathd.ssconstraints_ts)==0
                        pause(1) 
                    end
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
                    
                end
                
                %nomad options are defined in inputs.minlpsol.nomad
                
                
                
                opts.maxeval = inputs.minlpsol.vns.maxeval;
                opts.maxtime = inputs.minlpsol.vns.maxtime;
                opts.use_local = inputs.minlpsol.vns.use_local;
                opts.aggr = inputs.minlpsol.vns.aggr;
                opts.local_search_type = inputs.minlpsol.vns.local_search_type;
                opts.decomp = inputs.minlpsol.vns.decomp;
                
                 global input_par
                input_par{1} = inputs;
                input_par{2} = results;
                input_par{3} = privstruct;
                
                [res_ssm]=MEIGO(problem,opts,'VNS',inputs, results, privstruct );
                                
                results.minlpsol = res_ssm;
                results.minlpsol.vbest = res_ssm.xbest;
                
                
           case {'ga','GA'}
                
                %SSM has its own 'structures'.
                problem.x_0=vguess;
                problem.x_L=vmin;
                problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver_MINLP
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        % Nothing for now
                        error('Failure in AMIGO_call_OPTsolver_MINLP: PE is not supported for MINLP problems yet.')
                    case 'OED'
                        
                        problem.f='AMIGO_OEDcost_MINLP';
                        
                end
                
                
                
                if privstruct.ntotal_constraints >0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                    
                end
                
                if privstruct.ntotal_obsconstraints>0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                    
                end
                
                
                if  privstruct.ntotal_tsconstraints>0
                    while exist(inputs.pathd.ssconstraints_ts)==0
                        pause(1) 
                    end
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
                    
                end
                
                %nomad options are defined in inputs.minlpsol.nomad
                global totfeval
                totfeval = [];
                
                options = optimoptions('ga','PopulationSize',inputs.minlpsol.ga.PopulationSize,...
                    'ConstraintTolerance',inputs.minlpsol.ga.ConstraintTolerance,...
                    'CrossoverFcn',inputs.minlpsol.ga.CrossoverFcn,...
                    'CrossoverFraction',inputs.minlpsol.ga.CrossoverFraction,...
                    'Display',inputs.minlpsol.ga.Display,...
                    'EliteCount',inputs.minlpsol.ga.EliteCount,...
                    'FitnessLimit',inputs.minlpsol.ga.FitnessLimit,...
                    'FitnessScalingFcn',inputs.minlpsol.ga.FitnessScalingFcn,...
                    'FunctionTolerance',inputs.minlpsol.ga.FunctionTolerance,...
                    'MaxGenerations',inputs.minlpsol.ga.MaxGenerations,...
                    'MaxStallGenerations',inputs.minlpsol.ga.MaxStallGenerations,...
                    'MaxTime',inputs.minlpsol.ga.MaxTime,...
                    'MigrationFraction',inputs.minlpsol.ga.MigrationFraction,...
                    'MigrationInterval',inputs.minlpsol.ga.MigrationInterval);
                
                if isa(problem.f,'function_handle')
                    fobj = problem.f;
                    problem.f = func2str(problem.f);
                else
                    fobj=str2func(problem.f);
                end
                
                global input_par
                input_par{1} = inputs;
                input_par{2} = results;
                input_par{3} = privstruct;
                
                [x,fval,exitflag,output,population,scores] = ga(fobj,inputs.minlpsol.ga.nvars,[],[],[],[],...
                    problem.x_L,problem.x_U,[],inputs.minlpsol.ga.IntCon,options);
                
                                
                results.minlpsol.fbest=fval;
                results.minlpsol.vbest=x;
                results.minlpsol.fgen = scores;
                results.minlpsol.generations = output.generations;
                if length(scores)==output.generations
                    results.minlpsol.gen_curve=[(1:output.generations)' ,  scores];
                end
                results.minlpsol.fiter = totfeval;
                toteval = 1:length(totfeval);
                evalbest = [];
                fevalbest = [];

                for i=1:length(totfeval)
                    if i==1
                        fevalbest = totfeval(1);
                        evalbest = toteval(1);
                    else
                        if totfeval(i)<fevalbest(end)
                            fevalbest = [fevalbest, totfeval(i)];
                            evalbest = [evalbest, toteval(i)];
                        end
                    end
                end
                fevalbest = [fevalbest, fevalbest(end)];
                evalbest = [evalbest, length(totfeval)];
                results.minlpsol.iter_curve=[evalbest;  fevalbest]';
                results.minlpsol.population=population;
                results.minlpsol.exit_flag = exitflag;
                
                
           case {'mits','MITS'}
                
                %SSM has its own 'structures'.
                problem.x_0=vguess;
                problem.x_L=vmin;
                problem.x_U=vmax;
                
                if privstruct.print_flag==1
                    
                    AMIGO_report_OPTsolver_MINLP
                    AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
                    
                end
                
                switch optproblem
                    
                    case 'PE'
                        % Nothing for now
                        error('Failure in AMIGO_call_OPTsolver_MINLP: PE is not supported for MINLP problems yet.')
                    case 'OED'
                        
                        problem.f='AMIGO_OEDcost_MINLP2';
                        
                end
                
                
                
                if privstruct.ntotal_constraints >0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints))
                    
                end
                
                if privstruct.ntotal_obsconstraints>0
                    
                    eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
                    
                end
                
                
                if  privstruct.ntotal_tsconstraints>0
                    while exist(inputs.pathd.ssconstraints_ts)==0
                        pause(1) 
                    end
                    eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
                    
                end
                
                %nomad options are defined in inputs.minlpsol.nomad
                global totfeval
                totfeval = [];
                
                if isa(problem.f,'function_handle')
                    fobj = problem.f;
                    problem.f = func2str(problem.f);
                else
                    fobj=str2func(problem.f);
                end
                
                global input_par
                input_par{1} = inputs;
                input_par{2} = results;
                input_par{3} = privstruct;
                
                options = inputs.minlpsol.mits;
                options = rmfield(options,'nint');
                options.x0 = problem.x_0;
                
                [ solution,nfeval,ifail,LM,nLM ] = ...
                    mits(fobj, problem.x_L,problem.x_U,inputs.minlpsol.mits.nint,[],[],[],options );
                
                                
                results.minlpsol.fbest=solution.f;
                results.minlpsol.vbest=solution.x;
                results.minlpsol.nfeval = nfeval;
                results.minlpsol.fiter = totfeval;
                toteval = 1:length(totfeval);
                evalbest = [];
                fevalbest = [];

                for i=1:length(totfeval)
                    if i==1
                        fevalbest = totfeval(1);
                        evalbest = toteval(1);
                    else
                        if totfeval(i)<fevalbest(end)
                            fevalbest = [fevalbest, totfeval(i)];
                            evalbest = [evalbest, toteval(i)];
                        end
                    end
                end
                fevalbest = [fevalbest, fevalbest(end)];
                evalbest = [evalbest, length(totfeval)];
                results.minlpsol.iter_curve=[evalbest;  fevalbest]';
                results.minlpsol.exitflag = ifail;
                
                
           case {'aco','ACO'}
                
               disp('There are still issues to be solved in order to use ACO. Please, use another solver.')
               
%                 %SSM has its own 'structures'.
%                 problem.x_0=vguess;
%                 problem.x_L=vmin;
%                 problem.x_U=vmax;
%                 
%                 if privstruct.print_flag==1
%                     
%                     AMIGO_report_OPTsolver_MINLP
%                     AMIGO_report_guess_bounds(vguess,vmin,vmax,inputs.pathd.report);
%                     
%                 end
%                 
%                 switch optproblem
%                     
%                     case 'PE'
%                         % Nothing for now
%                         error('Failure in AMIGO_call_OPTsolver_MINLP: PE is not supported for MINLP problems yet.')
%                     case 'OED'
%                         
%                         problem.f='AMIGO_OEDcost_MINLP2';
%                         
%                 end
%                 
%                 
%                 
%                 if privstruct.ntotal_constraints >0
%                     
%                     eval(sprintf('%s',inputs.pathd.ssconstraints))
%                     
%                 end
%                 
%                 if privstruct.ntotal_obsconstraints>0
%                     
%                     eval(sprintf('%s',inputs.pathd.ssconstraints_obs))
%                     
%                 end
%                 
%                 
%                 if  privstruct.ntotal_tsconstraints>0
%                     while exist(inputs.pathd.ssconstraints_ts)==0
%                         pause(1) 
%                     end
%                     eval(sprintf('%s',inputs.pathd.ssconstraints_ts))
%                     
%                 end
%                 
%                 %nomad options are defined in inputs.minlpsol.nomad
%                 global totfeval
%                 totfeval = [];
%                 
%                 if isa(problem.f,'function_handle')
%                     fobj = problem.f;
%                     problem.f = func2str(problem.f);
%                 else
%                     fobj=str2func(problem.f);
%                 end
%                 
%                 global input_par
%                 input_par{1} = inputs;
%                 input_par{2} = results;
%                 input_par{3} = privstruct;
%                 
%                 options = inputs.minlpsol.aco;
%                 options = rmfield(options,'nint');
%                 options.x0 = problem.x_0;
%                 options.local.solver = 'misqp';
%                 
%                 problem2.objfunc = fobj;
%                 problem2.ncont =0;
%                 problem2.nint=inputs.minlpsol.aco.nint;
%                 problem2.nbin=0;
%                 problem2.m=[];
%                 problem2.me=[];
%                 problem2.xl = problem.x_L;
%                 problem2.xu = problem.x_U;
%                 options.max_best=10;
%                 
%                 opstr = inputs.model;
%                 opstr.def_states = inputs.model.eqns;
%                 opstr.par = inputs.model.par;
%                 opstr.name_odefile='PLac';
% 
%                 opstr.n_real = 0;
%                 opstr.n_int = inputs.minlpsol.aco.nint;
% 
%                 
% %                 [ solution,nfeval,ifail,LM,nLM ] = ...
% %                     mits(fobj, problem.x_L,problem.x_U,inputs.minlpsol.mits.nint,[],[],[],options );
%                 results = ACO2_1(problem2,options,opstr);
%                                 
%                 results.minlpsol.fbest=solution.f;
%                 results.minlpsol.vbest=solution.x;
%                 results.minlpsol.nfeval = nfeval;
%                 results.minlpsol.fiter = totfeval;
%                 toteval = 1:length(totfeval);
%                 evalbest = [];
%                 fevalbest = [];
% 
%                 for i=1:length(totfeval)
%                     if i==1
%                         fevalbest = totfeval(1);
%                         evalbest = toteval(1);
%                     else
%                         if totfeval(i)<fevalbest(end)
%                             fevalbest = [fevalbest, totfeval(i)];
%                             evalbest = [evalbest, toteval(i)];
%                         end
%                     end
%                 end
%                 fevalbest = [fevalbest, fevalbest(end)];
%                 evalbest = [evalbest, length(totfeval)];
%                 results.minlpsol.iter_curve=[evalbest;  fevalbest]';
%                 results.minlpsol.exitflag = ifail;
        end
        
    case 'fullMex'
        
        switch minlpsolver
                
            case 'nomad'
                
                switch optproblem
                    
                    case 'PE'
                        
                        if privstruct.ntotal_constraints >0
                            error('Failure in AMIGO_call_OPTsolverMINLP: Problems with constraints are not supported in fullMex execution mode.')
                        end
                        
                        error('Failure in AMIGO_call_OPTsolver_MINLP: PE problem are not supported in fullMex execution mode.')
                        
                    case 'OED'
                        
                        error('Failure in AMIGO_call_OPTsolver_MINLP: OED problem are not supported in fullMex execution mode.')
                        
                end
                
            otherwise
                error('Failure in AMIGO_call_OPTsolver_MINLP: solver not implemented in fullMex execution mode');
                
        end
        
    otherwise
        
        error('Failure in AMIGO_call_OPTsolver_MINLP: execution mode not recognized.');
        
end%switch exetype


for i=1:size(results.minlpsol.vbest,2)
    
    results.minlpsol.act_bound(i)=0;
    
    if 100*((results.minlpsol.vbest(1,i)-vmin(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99 ||...
            100*((vmax(1,i)-results.minlpsol.vbest(1,i))/(vmax(1,i)-vmin(1,i)))>=99.99
        
        results.minlpsol.act_bound(1,i)=1;
        
    end
    
end

