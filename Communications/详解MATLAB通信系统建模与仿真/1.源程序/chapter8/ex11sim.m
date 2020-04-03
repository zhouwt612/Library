clear all
Lc=7;                       %卷积码约束长度
BitRate=100000;             %比特速率
EbNo=0:2:10;                      %SNR的范围
for ii=1:length(EbNo)
    ii
    SNR=EbNo(ii);               %赋值给AWGN信道模块中的SNR
    sim('ex11');                %运行仿真模型
    ber1(ii)=BER1(1);           %保存本次仿真得到的BER
    ber2(ii)=BER2(1);
end
ber=berawgn(EbNo,'psk',2,'nodiff');   
semilogy(EbNo,ber,'-ko',EbNo,ber1,'-k*',EbNo,ber2,'-k.');
legend('BPSK理论误比特率','硬判决误比特率','软判决误比特率')
title('卷积码性能')
xlabel('Eb/No');ylabel('误比特率')
