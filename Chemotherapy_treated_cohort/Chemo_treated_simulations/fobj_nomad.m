function [fx]= fobj_nomad (x)
global input_par 
[fx]= AMIGO_PEcost(x,input_par{:});
return
