%m-序列DS-CDMA在AWGN信道下的性能仿真
clear all
user=[1 4 7];
seq=1;
for index=1:length(user)
    ber(index,:)=dscdma(user(index),seq);
end

EbNo=0:2:10;
semilogy(EbNo,ber(1,:),'-kx',EbNo,ber(2,:),'-ko',EbNo,ber(3,:),'-k*');
legend('user=1','user=4','user=7')
title('m序列DS-CDMA在AWGN信道下的性能')
xlabel('信噪比EbNo(dB)')
ylabel('误比特率(BER)')