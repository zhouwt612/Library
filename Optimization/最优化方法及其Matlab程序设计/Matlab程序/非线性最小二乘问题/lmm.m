function [x,val,k]=lmm(Fk,JFk,x0)
%功能: 用L-M方法求解非线性方程组: F(x)=0
%输入: x0是初始点, Fk, JFk 分别是求F(xk)及F'(xk)的函数
%输出:  x, val分别是近似解及||F(xk)||的值,  k是迭代次数.
maxk=1000;   %给出最大迭代次数
rho=0.55;sigma=0.4; muk=norm(feval(Fk,x0));
k=0;  epsilon=1e-6; n=length(x0);
while(k<maxk)
    fk=feval(Fk,x0); %计算函数值
    jfk=feval(JFk,x0); %计算Jacobi阵
    gk=jfk'*fk;
    dk=-(jfk'*jfk+muk*eye(n))\gk; %解方程组Gk*dk=-gk, 计算搜索方向
    if(norm(gk)<epsilon), break; end  %检验终止准则
    m=0; mk=0;
    while(m<20)   % 用Armijo搜索求步长 
        newf=0.5*norm(feval(Fk,x0+rho^m*dk))^2;
        oldf=0.5*norm(feval(Fk,x0))^2;
        if(newf<oldf+sigma*rho^m*gk'*dk)
            mk=m; break;
        end
        m=m+1;
    end
    x0=x0+rho^mk*dk;
    muk=norm(feval(Fk,x0));
    k=k+1;
end
x=x0;
val=0.5*muk^2; 
%gval=norm(gfun(x));
%%%% 目标函数 %%%%%%%%%
function y=Fk(x)
y(1)=x(1)-0.7*sin(x(1))-0.2*cos(x(2));
y(2)=x(2)-0.7*cos(x(1))+0.2*sin(x(2));
y=y(:);
%%%% Jacobi 阵 %%%%%%%%%%%%%%%%%%%
function JF=JFk(x)
   JF=[1-0.7*cos(x(1)), 0.2*sin(x(2));
        0.7*sin(x(1)), 1+0.2*cos(x(2))];
