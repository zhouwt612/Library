clear all
M=8;                        
msg=[1 4 3 0 7 5 2 6];          %消息信号
ts=0.01;                        %抽样时间间隔
T=1;                            %符号周期
t=0:ts:T;                       %符号持续时间向量
x=0:ts:length(msg);             %所有符号的传输时间    
fc=1;                           %载波频率
c=sqrt(2)*exp(j*2*pi*fc*t);     %1个符号周期内的载波波形
msg_qam=qammod(msg,M).';        %基带8QAM调制
tx_qam=real(msg_qam*c);         %8QAM载波调制
tx_qam=reshape(tx_qam.',1,length(msg)*length(t));
plot(x,tx_qam(1:length(x)))
title('8QAM信号波形')
xlabel('时间t'),ylabel('载波振幅')
scatterplot(msg_qam)
title('8QAM信号星座图')
xlabel('同相分量'),ylabel('正交分量')