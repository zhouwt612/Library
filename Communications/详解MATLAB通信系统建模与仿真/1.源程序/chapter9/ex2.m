clear all
N=8;                    % 子载波数
x=randint(1,N,[0 3])    % 子载波上的数据
x1=qammod(x,4)          % 4-QAM调制
f=1:N;                  % 子载波频率
t=0:0.001:1-0.001;      % 符号持续时间
w=2*pi*f.'*t;
y1=x1*exp(j*w);         % 子载波调制

x2=ifft(x1,N);          % IFFT

plot(t,abs(y1));    
hold on;
stem(0:1/8:1-1/8,abs(x2)*N,'-r');
legend('模拟调制实现','IDFT实现')
title('OFDM的模拟调制实现与IDFT实现')
  
x3=fft(x2)              % FFT
