clear all
snr=-3:3;               %SNR的范围
SimulationTime=10;  %仿真结束时间
for ii=1:length(snr)
    SNR=snr(ii);        %赋值给AWGN信道模块中的SNR
    sim('ex7');         %运行仿真模型
    ber(ii)=BER(1);     %保存本次仿真得到的BER
    ser(ii)=SER(1);     %保存本次仿真得到的SER
end
figure
semilogy(snr,ber,'-ro',snr,ser,'-r*')
legend('BER','SER')
title('QPSK在AWGN信道下的性能')
xlabel('信噪比（dB）')
ylabel('误符号率和误比特率')