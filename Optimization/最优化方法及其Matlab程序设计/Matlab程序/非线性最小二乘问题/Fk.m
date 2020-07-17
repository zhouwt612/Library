%Fk.m
 function y=Fk(x)
 y(1)=x(1)-0.7*sin(x(1))-0.2*cos(x(2));
 y(2)=x(2)-0.7*cos(x(1))+0.2*sin(x(2));
 y=y(:);
  