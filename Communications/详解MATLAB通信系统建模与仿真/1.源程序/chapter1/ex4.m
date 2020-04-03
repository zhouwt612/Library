x=linspace(0,2*pi,200);			%生成含有200个数据元素的向量x
y1=sin(x);
y2=cos(x);
plot(x,y1,'go',x,y2,'b-.')
title('sin(x),cos(x)曲线');      
xlabel('时间');     
ylabel('振幅');       
text(x(150),y1(150),'sin(x)曲线');
text(x(150),y2(150),'cos(x)曲线');
axis ([0 2*pi -2 2]);				%设定坐标轴范围
grid on					%显示坐标网格
legend('sin(x)','cos(x)');			%图例说明
