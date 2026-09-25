function [fx, g]= AMIGO_OEDcost_MINLP2 (x,input_par2)
global input_par 
global totfeval
[fx]= AMIGO_OEDcost(x,input_par{:});
% fx=(1e30)*(fx);
totfeval=[totfeval;fx];
g=[];
return
