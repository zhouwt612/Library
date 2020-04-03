clear all
nsymbol=10000;                      %每种信噪比下的发送符号数
SymbolRate=1000;                    %符号速率
nsamp=50;                           %每个符号的取样点数
fs=nsamp*SymbolRate;                %取样频率
fd=100;                             %Rayleigh衰落信道的最大多普勒频移
chan=rayleighchan(1/fs,fd);         %生成Rayleigh衰落信道
M=4;                                %4-QAM和4-FSK
graycode=[0 1 3 2 ];                %Gray编码规则                      
EsN0=0:2:20;                        %信噪比，Es/N0
snr1=10.^(EsN0/10);                 %信噪比转换为线性值
msg=randint(1,nsymbol,M);           %消息数据序列
msg1=graycode(msg+1);               %Gray映射
x1=qammod(msg1,M);                  %基带4-QAM调制
x1=rectpulse(x1,nsamp);
x2=fskmod(msg1,M,SymbolRate,nsamp,fs);  %4-FSK调制
spow1=norm(x1).^2/nsymbol;              %求4-QAM信号每个符号的平均功率
spow2=norm(x2).^2/nsymbol;              %求4-FSK信号每个符号的平均功率
for indx=1:length(EsN0)
    sigma1=sqrt(spow1/(2*snr1(indx)));                %根据符号功率求噪声功率
    sigma2=sqrt(spow2/(2*snr1(indx))); 
    fadeSig1=filter(chan,x1);           %4-QAM信号通过Rayleigh衰落信道
    fadeSig2=filter(chan,x2);           %4-FSK信号通过Rayleigh衰落信道
    rx1=fadeSig1+sigma1*(randn(1,length(x1))+j*randn(1,length(x1)));    %加入高斯白噪声
    rx2=fadeSig2+sigma2*(randn(1,length(x2))+j*randn(1,length(x2)));
    y1=intdump(rx1,nsamp);              %相关
    y1=qamdemod(y1,M);                  %4-QAM信号解调    
    decmsg1=graycode(y1+1);             %Gray逆映射
    [err,ber1(indx)]=biterr(msg,decmsg1,log2(M));       %4-QAM信号误比特率
    [err,ser1(indx)]=symerr(msg,decmsg1);               %4-QAM信号误符号率
    y2=fskdemod(rx2,M,SymbolRate,nsamp,fs);             %4-FSK信号解调     
    decmsg2=graycode(y2+1);                             %Gray逆映射
    [err,ber2(indx)]=biterr(msg,decmsg2,log2(M));       %4-FSK信号误比特率
    [err,ser2(indx)]=symerr(msg,decmsg2);               %4-FSK误符号率
end
semilogy(EsN0,ser1,'-k*',EsN0,ber1,'-ko',EsN0,ser2,'-kv',EsN0,ber2,'-k.');
title('4-QAM和4-FSK调制信号在Rayleigh衰落信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('4-QAM误符号率','4-QAM误比特率','4-FSK误符号率','4-FSK误比特率')