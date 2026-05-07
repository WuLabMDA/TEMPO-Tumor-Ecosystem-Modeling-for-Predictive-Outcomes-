function [A,l,u]= fobj_nomad_Omega (n)
A = [eye(n)];
l= [ 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; ];
u= [ 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; 10; ];
return
