clear all
EsN0=0:15;              %SNR的范围
EsN01=10.^(EsN0/10);
SymbolRate=2;           %符号速率
for ii=1:length(EsN0)
    SNR=EsN0(ii);       %赋值给AWGN信道模块中的SNR
    sim('ex2');         %运行仿真模型
    ber(ii)=BER(1);     %保存本次仿真得到的BER
    ser(ii)=SER(1);     %保存本次仿真得到的SER
end
semilogy(EsN0,ber,'-ko',EsN0,ser,'-k*',EsN0,1.5*qfunc(sqrt(0.4*EsN01)));
title('4-PAM载波调制信号在AWGN信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('误比特率','误符号率','理论误符号率')