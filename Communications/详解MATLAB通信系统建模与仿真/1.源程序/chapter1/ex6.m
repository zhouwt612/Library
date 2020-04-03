%1-6
x=linspace(0,2*pi,60);
y1=sin(x);
figure;              %创建新窗口并返回句柄到变量H1
plot(x,y1);
title('sin(x)')
axis([0 2*pi -1 1]);
y2=cos(x);
figure;              %创建第2个窗口并返回句柄到变量H2
plot(x,y2);
title('cos(x)')
axis([0 2*pi -1 1]);
y3=sin(2*x);
figure;              %创建第3个窗口并返回句柄到变量H3
plot(x,y3);
title('sin(2x)')
axis([0 2*pi -1 1]);
y4=cos(2*x);
figure;              %创建第4个窗口并返回句柄到变量H4
plot(x,y4);
title('cos(2x)')
axis([0 2*pi -1 1]);
