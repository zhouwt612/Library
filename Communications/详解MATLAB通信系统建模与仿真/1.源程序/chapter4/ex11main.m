clear all
snr=-3:3;               %SNR的范围
SimulationTime=0;       %仿真结束时间
ex7main;                %运行示例4.7
ser1=ser;ber1=ber;      %保存示例4.7的结果
for ii=1:length(snr)
    SNR=snr(ii);        %赋值给AWGN信道模块中的SNR
    sim('ex11');        %运行仿真模型
    ber(ii)=BER(1);     %保存本次仿真得到的BER
    ser(ii)=SER(1);     %保存本次仿真得到的SER
end
semilogy(snr,ber,'-rs',snr,ser,'-r^',snr,ber1,'-ro',snr,ser1,'-r*')
legend('Rayleigh衰落+AWGN信道BER','Rayleigh衰落+AWGN信道SER','AWGN信道BER','AWGN信道SER')
title('QPSK在AWGN和多径Rayleigh衰落信道下的性能')
xlabel('信噪比（dB）')
ylabel('误符号率和误比特率')