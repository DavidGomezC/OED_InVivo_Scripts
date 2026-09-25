

%% Multivariate Gaussian Sampling
% samps is an integer indicating how many sampels for the parameters one
% wants
function [R, R2] = SamplingMultivariateGaussian(samps)

    theta_min = [3.88e-5,3.88e-2,0.5,2,7.7e-3,0.2433,5.98e-5,0.012,0.01]; % 1/min
    theta_max = [0.4950,0.4950,4.9,10,0.23,6.8067,0.2449,0.0217,100];

    mu = (theta_max+theta_min)/2;
    sigma = (theta_max-theta_min)/4;

    covs = eye(length(sigma)).*sigma.^2;

    R = mvnrnd(mu,covs,samps);

    % Truncated versions

    R2 = mvnrnd_trn(theta_min,theta_max,mu,covs,samps);

end


















