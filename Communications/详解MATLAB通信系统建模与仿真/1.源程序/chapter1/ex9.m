%1-9
x=[0:0.1:2*pi];
y=abs(500*(sin(2*x)+cos(x)))+1;
semilogx(x,y);                    %单对数X轴绘图命令
title('X轴对数');
figure
semilogy(x,y);
title('Y轴对数')
