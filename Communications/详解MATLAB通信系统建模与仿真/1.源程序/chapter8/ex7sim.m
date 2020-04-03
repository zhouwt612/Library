clear all
EbNo=0:2:10;                  %SNR的范围
ber=berawgn(EbNo,'qam',16);
for ii=1:length(EbNo)
    ii
    BER=ber(ii);            %赋值给BSC信道模块中的BER
    sim('ex7');             %运行仿真模型
    ber1(ii)=BER1(1);       %保存本次仿真得到的BER
end
semilogy(EbNo,ber,'-ko',EbNo,ber1,'-k*');
legend('未编码','RS(15,11)编码')
title('未编码和RS(15,11)编码的16-QAM在AWGN下的性能')
xlabel('Eb/No');ylabel('误比特率')