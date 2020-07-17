%JFk.m
 function JF=JFk(x)
 JF=[1-0.7*cos(x(1)), 0.2*sin(x(2));
          0.7*sin(x(1)), 1+0.2*cos(x(2))];