clear all
nsymbol=100000;         %每种信噪比下的发送符号数

T=1;                        %符号周期
fs=100;                     %每个符号的采样点数
ts=1/fs;                    %采样时间间隔
t=0:ts:T-ts;                %时间向量
fc=10;                      %载波频率
c=sqrt(2/T)*cos(2*pi*fc*t);   %载波信号

M=4;                                    %4-PAM
graycode=[0 1 3 2];                     %Gray编码规则                      
EsN0=0:15;                              %信噪比，Es/N0
snr1=10.^(EsN0/10);                     %信噪比转换为线性值
msg=randint(1,nsymbol,4);               %消息数据
msg1=graycode(msg+1);                   %Gray映射
msgmod=pammod(msg1,M).';                %基带4-PAM调制
tx=msgmod*c;                            %载波调制
tx1=reshape(tx.',1,length(msgmod)*length(c));   
spow=norm(tx1).^2/nsymbol;              %求每个符号的平均功率
for indx=1:length(EsN0)
    sigma=sqrt(spow/(2*snr1(indx)));                %根据符号功率求噪声功率
    rx=tx1+sigma*randn(1,length(tx1));              %加入高斯白噪声
    rx1=reshape(rx,length(c),length(msgmod));       
    y=(c*rx1)/length(c);                            %相关运算
    y1=pamdemod(y,M);                               %PAM解调
    decmsg=graycode(y1+1);
    [err,ber(indx)]=biterr(msg,decmsg,log2(M));     %误比特率
    [err,ser(indx)]=symerr(msg,decmsg);             %误符号率
end
semilogy(EsN0,ber,'-ko',EsN0,ser,'-k*',EsN0,1.5*qfunc(sqrt(0.4*snr1)));
title('4-PAM载波调制信号在AWGN信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('误比特率','误符号率','理论误符号率')