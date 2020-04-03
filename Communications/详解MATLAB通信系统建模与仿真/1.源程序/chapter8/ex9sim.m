clear all
EbNo=0:2:10;                  %SNR的范围
ber=berawgn(EbNo,'qam',16);
for ii=1:length(EbNo)
    ii
    BER=ber(ii);            %赋值给BSC信道模块中的BER
    sim('ex9');             %运行仿真模型
    pmissed(ii)=MissedFrame(end)/length(MissedFrame);       %本次仿真得到的漏检概率
end
semilogy(EbNo,pmissed,'-ko');
title('CRC-16检错性能')
xlabel('Eb/No');ylabel('漏检概率')
axis([0 8 10.^(-6) 10.^(-3)])