clear all
EbNo=0:2:10;                  %SNR的范围
SymbolRate=50000;           %符号速率
for ii=1:length(EbNo)
    ii
    SNR=EbNo(ii);           %赋值给AWGN信道模块中的SNR
    sim('ex3');             %运行仿真模型
    ber1(ii)=BER1(1);       %保存本次仿真未编码得到的BER
    ber2(ii)=BER2(1);       %保存本次仿真Hamming编码得到的BER
end
semilogy(EbNo,ber1,'-ko',EbNo,ber2,'-k*');
legend('未编码','Hamming(7,4)编码')
title('未编码和Hamming(7,4)编码的QPSK在AWGN下的性能')
xlabel('Eb/No');ylabel('误比特率')