x=linspace(0,2*pi,60);
y1=sin(x);
subplot(2,2,1);			%整个绘图区分为2*2区域，且当前绘图区位1号绘图区
plot(x,y1);
title('sin(x)')
axis([0 2*pi -1 1]);
y2=cos(x);
subplot(2,2,2);			%指定当前绘图区为2号绘图区
plot(x,y2);
title('cos(x)')
axis([0 2*pi -1 1]);
y3=sin(2*x);
subplot(2,2,3);			%指定当前绘图区为3号绘图区
plot(x,y3);
title('sin(2x)')
axis([0 2*pi -1 1]);
y4=cos(2*x);
subplot(2,2,4);			%指定当前绘图区为4号绘图区
plot(x,y4);
title('cos(2x)')
axis([0 2*pi -1 1]);
