clear all
nsymbol=100000;                         %每种信噪比下的发送符号数
nsamp=10;                               %每个脉冲信号的抽样点数

M=4;                                    %4-PAM
graycode=[0 1 3 2];                     %Gray编码规则                      
EsN0=0:15;                              %信噪比，E/N0
msg=randint(1,nsymbol,4);               %消息数据
msg1=graycode(msg+1);                   %Gray映射
msg2=pammod(msg1,M);                    %4-PAM调制
s=rectpulse(msg2,nsamp);                %矩形脉冲成形
for indx=1:length(EsN0)
    decmsg=zeros(1,nsymbol);
    r=awgn(real(s),EsN0(indx)-7,'measured');    %通过AWGN信道
    r1=intdump(r,nsamp);                        %相关器输出
    msg_demod=pamdemod(r1,M);                   %判决
    decmsg=graycode(msg_demod+1);               %Gray逆映射
    [err,ber(indx)]=biterr(msg,decmsg,log2(M)); %求误比特率
    [err,ser(indx)]=symerr(msg,decmsg);
end
semilogy(EsN0,ber,'-ko',EsN0,ser,'-k*',EsN0,1.5*qfunc(sqrt(0.4*10.^(EsN0/10))));
title('4-PAM信号在AWGN信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('误比特率','误符号率','理论误符号率')