


function [oedRes] = mainRunOnLineOED_WithLocalSolver(inputs, Identifier, tmpv, j, tmpu)


    inputs.PEsol.global_theta_guess = tmpv;
    inputs.model.par = tmpv;
    for exp = 1:inputs.exps.n_exp
        inputs.exps.exp_y0{exp}=M3D_steady_state_Microfluidics_MINLP(tmpv,0);
    end
    
    inputs.exps.u_guess{inputs.exps.n_exp}=tmpu;
    
    inputs.pathd.results_folder = [inputs.pathd.results_folder, '_', num2str(randi([0,1000],1)), '_', num2str(j)];
    inputs.pathd.short_name = [inputs.pathd.short_name, '_', num2str(randi([0,1000],1)), '_', num2str(j)];
    AMIGO_Prep_MINLP(inputs);
    
    oedRes = AMIGO_OED_MINLP(inputs);

    save(strjoin([".\ResultsOnLineOED\OLOEDlocal_", Identifier, "\Run_", j, ".mat"], ""), "oedRes")


end
