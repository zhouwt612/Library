clear all
EbN0=0:12              %SNR的范围

for ii=1:length(EbN0)
    SNR=EbN0(ii);       %赋值给AWGN信道模块中的SNR
    sim('ex3');         %运行仿真模型
    ber(ii)=BER(1);     %保存本次仿真得到的BER
end
semilogy(EbN0,ber,'-ko',EbN0,qfunc(sqrt(10.^(EbN0/10))));
title('二进制正交信号在AWGN信道下的误比特率性能')
xlabel('Eb/N0');ylabel('误比特率Pe')
legend('仿真结果','理论结果')

