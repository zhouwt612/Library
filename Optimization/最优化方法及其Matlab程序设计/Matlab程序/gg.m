function s=gg(x)
x1=x(1); x2=x(2); s=zeros(2,1);
s=[400*x(1)*(x(1)^2-x(2))+2*(x(1)-1), -200*(x(1)^2-x(2))]';
s=(1/norm(s))*s;