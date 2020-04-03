clear all
clc
nsymbol=10000;         %每种信噪比下的发送符号数

T=1;                        %符号周期
fs=100;                     %每个符号的采样点数
ts=1/fs;                    %采样时间间隔
t=0:ts:T-ts;                %时间向量
fc=8;                      %载波频率
gt = 0.5*(1-(cos(pi*t)));
c=sqrt(2/T)*exp(j*2*pi*fc*t);   %载波信号
c1=sqrt(2/T)*cos(2*pi*fc*t);    %同相载波
c2=-sqrt(2/T)*sin(2*pi*fc*t);   %正交载波     
M=8;                                    %8-PSK
graycode=[0 1 2 3 6 7 4 5];             %Gray编码规则                      
EsN0=0:15;                              %信噪比，Es/N0
snr1=10.^(EsN0/10);                     %信噪比转换为线性值
msg=randint(1,nsymbol,M);               %消息数据
msgg = conv(gt,msg)
msg1=graycode(msg+1);                   %Gray映射
msgmod=pskmod(msg1,M).';                %基带8-PSK调制
tx=real(msgmod*c);                      %载波调制
tx1=reshape(tx.',1,length(msgmod)*length(c));   
spow=norm(tx1).^2/nsymbol;              %求每个符号的平均功率
stem(tx1)
for indx=1:length(EsN0)
    sigma=sqrt(spow/(2*snr1(indx)));                %根据符号功率求噪声功率
    rx=tx1+sigma*randn(1,length(tx1));              %加入高斯白噪声
    rx1=reshape(rx,length(c),length(msgmod));       
    r1=(c1*rx1)/length(c1);                         %相关运算
    r2=(c2*rx1)/length(c2);
    r=r1+j*r2;
    y=pskdemod(r,M);                                %PSK解调
    decmsg=graycode(y+1);
    [err,ber(indx)]=biterr(msg,decmsg,log2(M));     %误比特率
    [err,ser(indx)]=symerr(msg,decmsg);             %误符号率
end
ser1=2*qfunc(sqrt(2*snr1)*sin(pi/M));               %理论误符号率
ber1=1/log2(M)*ser1;                                %理论误比特率
semilogy(EsN0,ber,'-ko',EsN0,ser,'-k*',EsN0,ser1,EsN0,ber1,'-k.');
title('8-PSK载波调制信号在AWGN信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('误比特率','误符号率','理论误符号率','理论误比特率')