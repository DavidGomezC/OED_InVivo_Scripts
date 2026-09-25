function [default]=mits_defaults

%Assings default values for all the options

default.nint = [];
default.acc = 1e-7; % The user has to specify the desired final accuracy
%               (e.g. 1.0D-7) for the constraints and as a termination criterion
%               for the local solver.
default.maxit = 1000; % Maximum number of iterations, where one iteration corresponds to
%               one evaluation of the neighbourhood and maybe an additional
%               start of the local solver.
default.maxun = 100; % The algorithm will stop after the maximum number of consecutive
%               iterations without improvement has been reached.
default.maxtime = 1e6; %  Maximum time for MITS run in seconds.
default.maxfun = 1000; % Maximum number of function evaluations. 