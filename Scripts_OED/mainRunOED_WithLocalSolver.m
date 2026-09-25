


function [oedRes] = mainRunOED_WithLocalSolver(inputs, Identifier, tmpv, j, tmpu)


    inputs.PEsol.global_theta_guess = tmpv;
    inputs.model.par = tmpv;
    inputs.exps.exp_y0{1}=M3D_steady_state_Microfluidics_MINLP(tmpv,0);
    
    inputs.exps.u_guess{1}=tmpu;
    
    inputs.pathd.results_folder = [inputs.pathd.results_folder, '_', num2str(j)];
    inputs.pathd.short_name = [inputs.pathd.short_name, '_', num2str(j)];
    AMIGO_Prep_MINLP(inputs);
    
    oedRes = AMIGO_OED_MINLP(inputs);

    save(strjoin([".\ResultsOED\OEDlocal_", Identifier, "\Run_", j, ".mat"], ""), "oedRes")


end
