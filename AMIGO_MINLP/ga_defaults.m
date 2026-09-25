function [default]=ga_defaults

%Assings default values for all the options

default.nvars = [];
default.IntCon = [];


default.PopulationSize = 200;
default.ConstraintTolerance = 1e-3;
default.CrossoverFcn = 'crossoverscattered';
default.CrossoverFraction = 0.8;
default.Display = 'off';
default.EliteCount = ceil(0.05*default.PopulationSize);
default.FitnessLimit = -Inf;
default.FitnessScalingFcn = 'fitscalingrank';
default.FunctionTolerance = 1e-6;
default.MaxGenerations = 200;
default.MaxStallGenerations = 50;
default.MaxTime = Inf;
default.MigrationFraction = 0.2;
default.MigrationInterval = 20;