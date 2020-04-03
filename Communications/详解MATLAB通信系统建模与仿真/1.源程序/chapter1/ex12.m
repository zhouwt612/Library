%ex1-12
y=0;
x=0:0.01:2*pi;
for indx=1:100
    y=y+sin(indx*x);
end
plot(x,y)
title('y=sinx+sin2x+...+sin100x')