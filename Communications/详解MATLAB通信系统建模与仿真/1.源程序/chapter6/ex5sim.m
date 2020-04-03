clear all
EbN0=0:10;              %SNR的范围

for ii=1:length(EbN0)
    SNR=EbN0(ii);       %赋值给AWGN信道模块中的SNR
    sim('ex5');         %运行仿真模型
    ber(ii)=BER(1);     %保存本次仿真得到的BER
end
semilogy(EbN0,ber,'-ko',EbN0,qfunc(sqrt(10.^(EbN0/10))),'-k*',EbN0,qfunc(sqrt(2*10.^(EbN0/10))));
title('双极性信号在AWGN信道下的误比特率性能')
xlabel('Eb/N0');ylabel('误比特率Pe')
legend('双极性信号仿真结果','正交信号理论误比特率','双极性信号理论误比特率')
