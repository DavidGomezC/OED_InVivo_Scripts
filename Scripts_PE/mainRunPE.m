


function [peRes] = mainRunPE(inputs, Identifier, tmpv, j)


    inputs.PEsol.global_theta_guess = tmpv;
    inputs.model.par = tmpv;
    
    for i = 1:inputs.exps.n_exp
        inputs.exps.exp_y0{i}=M3D_steady_state_Microfluidics(tmpv,0);
    end
    
    inputs.pathd.results_folder = [inputs.pathd.results_folder, '_', num2str(j)];
    inputs.pathd.short_name = [inputs.pathd.short_name, '_', num2str(j)];
    AMIGO_Prep(inputs);
    
    peRes = AMIGO_PE(inputs);

    save(strjoin([".\ResultsPE\PE_", Identifier, "\Run_", j, ".mat"], ""), "peRes")


end




