clear all
nsamp=10;                               %每个脉冲信号的抽样点数

s0=ones(1,nsamp);                       %基带脉冲信号
s1=-s0;          

nsymbol=100000;                         %每种信噪比下的发送符号数

EbN0=0:10;                               %信噪比，E/N0
msg=randint(1,nsymbol);                 %消息数据
s00=zeros(nsymbol,1);                   
s11=zeros(nsymbol,1);
indx=find(msg==0);                      %比特0在发送消息中的位置
s00(indx)=1;
s00=s00*s0;                             %比特0影射为发送波形s0
indx1=find(msg==1);                     %比特1在发送消息中的位置
s11(indx1)=1;                               
s11=s11*s1;                             %比特1映射为发送波形s1
s=s00+s11;                              %总的发送波形
s=s.';                                  %数据转置，方便接收端处理

for indx=1:length(EbN0)
    decmsg=zeros(1,nsymbol);
    r=awgn(s,EbN0(indx)-7);              %通过AWGN信道
    r00=s0*r;                            %与s0相关
    indx1=find(r00<0);               
    decmsg(indx1)=1;                       %判决
    [err,ber(indx)]=biterr(msg,decmsg);
end
semilogy(EbN0,ber,'-ko',EbN0,qfunc(sqrt(10.^(EbN0/10))),'-k*',EbN0,qfunc(sqrt(2*10.^(EbN0/10))));
title('双极性信号在AWGN信道下的误比特率性能')
xlabel('Eb/N0');ylabel('误比特率Pe')
legend('双极性信号仿真结果','正交信号理论误比特率','双极性信号误理论误比特率')
