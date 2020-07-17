function  callqpact 
H=[2 -1; -1 4]; 
c=[-1 -10]'; 
Ae=[ ];  be=[ ];
Ai=[-3 -2; 1 0; 0 1];
bi=[-6 0 0]';
x0=[0 0]';
[x, lambda, exitflag,output]=qpact(H,c,Ae,be,Ai,bi,x0)