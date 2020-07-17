function dp=dpfun(dfun1,hfun, dhfun,gfun1,dgfun1,x,sigma)
df1=feval('dfun1',x);  h1=feval('hfun',x); g1=feval('gfun1',x);
dh1=feval('dhfun',x); dg1=feval('dgfun1',x);
l=length(h1); m=length(g1); n=length(x);
dg2=zeros(n,1);
for(i=1:m)
    if(g1(i)>=0)
        dg2=dg2+zeros(n,1);
    else
        dg2=dg2+2*g1(i)*dg1(:,i);
    end
end
dp=df1+2*sigma*dh1*h1+2*sigma*dg1*g1;
function f1=fun1(x)
f1=x(1)^2+x(2)^2+x(3)^2+x(4)^2-2*x(1)-3*x(4);
%%%%%%%
function df1=dfun1(x)
df1=[2*x(1)-2, 2*x(2), 2*x(3), 2*x(4)-3]';
function h1=hfun(x)
h1(1)=2*x(1)+x(2)+x(3)+4*x(4)-7;
h1(2)=x(1)+x(2)+2*x(3)+x(4)-6;
h1=h1(:);
%%%%%%%
function dh1=dhfun(x)
dh1=[2, 1, 1, 4; 1, 1, 2, 1]';
function g1=gfun1(x)
g1=[x(1),  x(2), x(3), x(4)]';
%%%%%%%
function dg1=dgfun1(x)
dg1=[1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1]';
