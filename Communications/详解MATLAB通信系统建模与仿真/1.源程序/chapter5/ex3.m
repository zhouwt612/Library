clear all
ts=0.0025;                      %信号抽样时间间隔
t=0:ts:5-ts;                   %时间向量
fs=1/ts;                        %抽样频率
msg=randint(10,1,[-3,3],123);  %生成消息序列,随机数种子为123
msg1=msg*ones(1,fs/2);         %扩展成取样信号形式
msg2=reshape(msg1.',1,length(t));
subplot(3,1,1)
plot(t,msg2)                    %画出消息信号
title('消息信号')

A=4;
fc=100;                         %载波频率
Sam=(A+msg2).*cos(2*pi*fc*t);   %已调信号

dems=abs(hilbert(Sam))-A;       %包络检波，并且去掉直流分量。
subplot(3,1,2)
plot(t,dems)                    %画出解调后的信号
title('无噪声的解调信号')

y=awgn(Sam,20,'measured');      %调制信号通过AWGN信道
dems2=abs(hilbert(y))-A;        %包络检波，并且去掉直流分量。
subplot(3,1,3)                  %画出解调信号
plot(t,dems2)
title('信噪比为20dB时的解调信号')
