
function [nopts] = SetNomadOptions(opts)

nopts.bb_input_type= [];
nopts.bb_output_type= [];
nopts.direction_type= 'ortho n+1 quad';
nopts.f_target= [];
nopts.initial_mesh_size= [];
nopts.lh_search= [];
nopts.max_bb_eval= 10000;

if isfield(opts,'maxfeval')
    nopts.max_bb_eval=opts.maxfeval;
end

nopts.max_time= 1000;

if isfield(opts,'maxtime')
    nopts.max_time=opts.maxtime;
end

nopts.model_eval_sort= 1;
nopts.model_search= 1;
nopts.multi_nb_mads_runs= [];
nopts.multi_overall_bb_eval= [];
nopts.opportunistic_eval= 1;
nopts.opportunistic_lh= 1;
nopts.seed= 0;
nopts.vns_search= 0;
nopts.cache_search= 0;
nopts.h_max_0= 1.0000e+20;
nopts.h_min= [];
nopts.h_norm= 'L2';
nopts.initial_mesh_index= [];
nopts.l_curve_target= [];
nopts.max_cache_memory= 2000;

if isfield(opts,'maxcachemem')
    nopts.max_cache_memory=opts.maxcachemem;
end

nopts.max_consecutive_failed_iterations= [];
nopts.max_eval= [];

if isfield(opts,'maxfeval')
    nopts.max_eval=opts.maxfeval;
end

nopts.max_iterations= 1500;

if isfield(opts,'maxiter')
    nopts.max_iterations=opts.maxiter;
end

nopts.max_mesh_index= [];
nopts.max_sim_bb_eval= [];
nopts.mesh_coarsening_exponent= 1;
nopts.mesh_refining_exponent= -1;
nopts.mesh_update_basis= 4;
nopts.min_mesh_size= '1e-07';
nopts.min_poll_size= [];
nopts.model_eval_sort_cautious= 0;
nopts.model_search_max_trial_pts= 10;
nopts.model_search_optimistic= 1;
nopts.model_search_proj_to_mesh= 1;
nopts.model_quad_max_y_size= 500;
nopts.model_quad_min_y_size= [];
nopts.model_quad_radius_factor= 2;
nopts.model_quad_use_wp= 0;
nopts.multi_f_bounds= [];
nopts.multi_formulation= 'product';
nopts.multi_use_delta_crit= 0;
nopts.opportunistic_cache_search= 0;
nopts.opportunistic_lucky_eval= [];
nopts.opportunistic_min_eval= [];
nopts.opportunistic_min_f_imprvmt= [];
nopts.opportunistic_min_nb_success= -1;
nopts.rho= 0.1000;
nopts.scaling= [];
nopts.sec_poll_dir_type= [];
nopts.snap_to_bounds= 1;
nopts.speculative_search= 1;
nopts.stat_sum_target= [];
nopts.stop_if_feasible= 0;
nopts.add_seed_to_file_names= 1;
nopts.cache_file= [];
nopts.cache_save_period= 25;
nopts.display_degree= 2;
nopts.display_all_eval= 0;
nopts.history_file= 'ObjectPerIter.csv';

if isfield(opts,'history_file')
    nopts.history_file=opts.history_file;
end

nopts.solution_file= [];
nopts.stats_file= [];
if isfield(opts,'stats_file')
    nopts.stats_file=opts.stats_file;
end
nopts.param_file= [];
nopts.iterfun= [];
nopts.disable= [];
nopts.epsilon= 1.0000e-60;
nopts.opt_only_sgte= 0;
nopts.sgte_cost= [];
nopts.sgte_eval_sort= 1;
nopts.has_sgte= 0;
nopts.sgte_cache_file= [];
nopts.max_sgte_eval= [];
nopts.optiver= 2.2800;


return



