function [x,val,k]=gradd(ff,x0,maxk)
% 功能: 用最速下降法求解无约束问题:  min f(x)
%输入:  x0是初始点, maxk是最大迭代次数，默认为5000
%输出:  x, val分别是近似最优点和最优值,  k是迭代次数.
if nargin==2, maxk=5000; end
rho=0.5;sigma=0.4;
k=0;  epsilon=1e-5;
while(k<maxk)
    d=-gg(x0);  %计算搜索方向
    if(norm(d)<epsilon), break; end
    m=0; mk=0;
    while(m<20)   %Armijo搜索
        if(feval(ff,x0+rho^m*d)<feval(ff,x0)-sigma*rho^m*d'*d)
            mk=m; break;
        end
        m=m+1;
    end
    x0=x0+rho^mk*d;
    k=k+1;
end
x=x0;
val=feval(ff,x0); 

%function t=f(x)
%t=100*(x(1)^2-x(2))^2+(x(1)-1)^2;

%function s=g(x)
%s=[400*x(1)*(x(1)^2-x(2))+2*(x(1)-1), -200*(x(1)^2-x(2))]';