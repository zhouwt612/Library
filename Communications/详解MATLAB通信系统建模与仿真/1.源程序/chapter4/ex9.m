%ex4.9
clear all
fd=10;              %多普勒频移为10
ts=1/1000;          %信道抽样时间间隔
t=0:ts:1;           %生成时间序列
h1=rayleigh(fd,t);  %产生信道数据

fd=20;              %多普勒频移为20
h2=rayleigh(fd,t);  %产生信道数据
subplot(2,1,1),plot(20*log10(abs(h1(1:1000))))
title('fd =10Hz时的信道功率曲线')
xlabel('时间');ylabel('功率')
subplot(2,1,2),plot(20*log10(abs(h2(1:1000))))
title('fd=20Hz时的信道功率曲线')
xlabel('时间');ylabel('功率')