function [fx]= AMIGO_OEDcost_MINLP (x)
global input_par 
global totfeval
[fx]= AMIGO_OEDcost(x,input_par{:});
% fx=(1e30)*(fx);
totfeval=[totfeval;fx];
return
