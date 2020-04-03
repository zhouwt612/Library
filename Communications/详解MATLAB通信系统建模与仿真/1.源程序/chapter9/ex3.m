clear all
N=64;                       % 系统子载波数
x=randint(N,2,[0 15]);      % 2个符号周期的数据
x1=qammod(x,16);            % 16-QAM调制
x2=ifft(x1);                % IFFT
x3=[zeros(16,2); x2];       % 空白前缀
x4=[x2(49:end,:); x2];      % 循环前缀

x3=reshape(x3,1,160);       % 并串变换
x4=reshape(x4,1,160);

h=sqrt(1/3)*(randn(1,3));   % 3径信道

y1=x3*h(1)+[zeros(1,8) x3(1:end-8)*h(2)]; %只考虑前2径
y2=x4*h(1)+[zeros(1,8) x4(1:end-8)*h(2)];

y3=reshape(y1,80,2);        % 串并变换
y4=reshape(y2,80,2);

y3=y3(17:end,2);            % 考虑第2个符号的影响
y4=y4(17:end,2);

y3=fft(y3);                 % FFT
y4=fft(y4);

h1=[h(1) zeros(1,7) h(2)];  % 信道FFT变换
H=fft(h1,N).';
y3=y3./H;                   % 信道均衡
y4=y4./H;

stem(abs(x1(:,2)),'fill');hold on;stem(abs(y3),'r<');stem(abs(y4),'-gs')
legend('原始信号','空白前缀','循环前缀')
axis([0 70 0 max(abs(y3))+2])
title('2径信道结果')

y1=y1+[zeros(1,20) x3(1:end-20)*h(3)];      % 3径信道结果
y2=y2+[zeros(1,20) x4(1:end-20)*h(3)];

y3=reshape(y1,80,2);        % 串并变换        
y4=reshape(y2,80,2);

y3=y3(17:end,2);            % 考虑第2个符号的影响
y4=y4(17:end,2);

y3=fft(y3);                 % FFT
y4=fft(y4);

h1=[h1 zeros(1,11) h(3)];   % 信道FFT变换
H=fft(h1,N).';
y3=y3./H;                   % 信道均衡
y4=y4./H;
figure
stem(abs(x1(:,2)),'fill');hold on;stem(abs(y3),'r<');stem(abs(y4),'-gs')
legend('原始信号','空白前缀','循环前缀')
axis([0 70 0 max(max(abs(y3),abs(y4)))+2])
title('3径信道结果')