function [default]=aco_defaults

%Assings default values for all the options

default.x0 = [];
default.nint=[];
default.acc = 1e-10;        % Restriction tolerance and termination criterion for local solver
default.maxit = 1000;  % Maxim number iterations 100000000
default.maxun = 1000;  % Maximum number of consecutive iterations without improvement 100000000
default.maxfun = 1000;   % Maximum function evaluations 1000000
default.maxtime = 1e6;        % Maximum time for solver run (in seconds)
default.startloc = false;   % Start with local solver run (true/false)
default.maxeval = 1000;  % maximal evaluations (e.g. 1000000)
default.oracle  = -Inf; % oracle parameter for penalty function
default.ants  = 1000; % default 1000