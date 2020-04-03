%1-7
x=linspace(0,2*pi,60);
y=sin(x);
z=cos(x);
plot(x,y,'-go');           %绘制正弦曲线
%hold on;                 %设置图形保持状态
plot(x,z,'-.b');           %保持正弦曲线同时绘制余弦曲线
axis ([0 2*pi -1 1]);    % 
legend('sin(x)','cos(x)');
hold off                 %关闭图形保持
