clear all
nsymbol=100000;                             %每种信噪比下的发送符号数
M=16;                                       %16-QAM
graycode=[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10];             %Gray编码规则                      
EsN0=5:20;                              %信噪比，Es/N0
snr1=10.^(EsN0/10);                     %信噪比转换为线性值
msg=randint(1,nsymbol,M);               %消息数据
msg1=graycode(msg+1);                   %Gray映射
msgmod=qammod(msg1,M);                  %基带16-QAM调制
spow=norm(msgmod).^2/nsymbol;           %求每个符号的平均功率
for indx=1:length(EsN0)
    sigma=sqrt(spow/(2*snr1(indx)));                %根据符号功率求噪声功率
    rx=msgmod+sigma*(randn(1,length(msgmod))+j*randn(1,length(msgmod)));
    y=qamdemod(rx,M);
    decmsg=graycode(y+1);
    [err,ber(indx)]=biterr(msg,decmsg,log2(M));     %误比特率
    [err,ser(indx)]=symerr(msg,decmsg);             %误符号率
end
P4=2*(1-1/sqrt(M))*qfunc(sqrt(3*snr1/(M-1)));
ser1=1-(1-P4).^2;                                           %理论误符号率
ber1=1/log2(M)*ser1;                                        %理论误比特率
semilogy(EsN0,ber,'-ko',EsN0,ser,'-k*',EsN0,ser1,EsN0,ber1,'-k.');
title('16-QAM载波调制信号在AWGN信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('误比特率','误符号率','理论误符号率','理论误比特率')