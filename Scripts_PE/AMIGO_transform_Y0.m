% $Header: svn://.../trunk/AMIGO2R2016/Kernel/AMIGO_transform_theta.m 2046 2015-08-24 12:43:55Z attila $


function [privstruct,inputs]=AMIGO_transform_Y0(inputs,results,privstruct)
% * Modified\Introduced in:
% 	- AMIGO_PEcost: After line 100
% 	- AMIGO_PE: After line 246

for iexp=1:inputs.exps.n_exp
    privstruct.y_0{iexp} = M3D_steady_state_Microfluidics(privstruct.theta,0);
    privstruct.exp_y0{iexp} = M3D_steady_state_Microfluidics(privstruct.theta,0);
    inputs.exps.exp_y0{iexp} = M3D_steady_state_Microfluidics(privstruct.theta,0);
end



return;