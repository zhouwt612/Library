clear all
M=16;                   %16-PSK
EsN0=0:2:20;              %SNR的范围
EsN01=10.^(EsN0/10);
SymbolRate=2;           %符号速率
for ii=1:length(EsN0)
    SNR=EsN0(ii);       %赋值给AWGN信道模块中的SNR
    sim('ex4');         %运行仿真模型
    ber(ii)=BER(1);     %保存本次仿真得到的BER
    ser(ii)=SER(1);     %保存本次仿真得到的SER
end
ser1=2*qfunc(sqrt(2*EsN01)*sin(pi/M));               %理论误符号率
ber1=1/log2(M)*ser1;                                %理论误比特率
semilogy(EsN0,ber,'-ko',EsN0,ser,'-k*',EsN0,ser1,EsN0,ber1,'-k.');
title('16-PSK载波调制信号在AWGN信道下的性能')
xlabel('Es/N0');ylabel('误比特率和误符号率')
legend('误比特率','误符号率','理论误符号率','理论误比特率')