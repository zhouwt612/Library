%ex1-13
y=0;
x=0:0.01:2*pi;
indx=1;
while indx<=100
    y=y+sin(indx*x);
    indx=indx+1;
end
plot(x,y)
