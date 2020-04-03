clear all

nsymbol=100000;                         %发送符号数
EbN0=0:12;                               %信噪比
msg=randint(1,nsymbol);                 %消息数据
E=1;
r0=zeros(1,nsymbol);
r1=zeros(1,nsymbol);
indx=find(msg==0);
r0(indx)=E;
indx1=find(msg==1);
r1(indx1)=E;

for indx=1:length(EbN0)
    dec=zeros(1,length(msg));
    snr=10.^(EbN0(indx)/10);                    %dB转换为线性值
    sigma=1/(2*snr);                            %噪声方差
    r00=r0+sqrt(sigma)*randn(1,length(msg));    %相关器的输出
    r11=r1+sqrt(sigma)*randn(1,length(msg));
    indx1=find(r11>=r00);                       %判决
    dec(indx1)=1;
    [err,ber(indx)]=biterr(msg,dec);
end
figure
semilogy(EbN0,ber,'-ko',EbN0,qfunc(sqrt(10.^(EbN0/10))));
title('二进制正交信号在AWGN信道下的误比特率性能')
xlabel('Eb/N0');ylabel('误比特率Pe')
legend('仿真结果','理论结果')


        
        