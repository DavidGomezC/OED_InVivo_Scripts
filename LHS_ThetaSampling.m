
% samps is an integer indicating how many sampels for the parameters one
% wants
function [ParFull] = LHS_ThetaSampling(samps)

    % Selected boundaries for the parameters
    theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012,0.01]; % 1/min
    theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217,100];

    % Create a matrix of initial guesses for the parameters, having as many
    % rows as the number of PE iterations (numExperiments) 
    % Each vector is passed as input to the computing function
    M_norm = lhsdesign(samps,length(theta_min));
    M = zeros(size(M_norm));
    for c=1:size(M_norm,2)
        for r=1:size(M_norm,1)
            M(r,c) = 10^(M_norm(r,c)*(log10(theta_max(1,c))-log10(theta_min(1,c)))+log10(theta_min(1,c))); % log exploration
        end
    end 

    ParFull = M; % in this case I am fitting all the values

end