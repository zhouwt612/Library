clear all
EbNo=0:2:10;                      %SNR的范围
N=100000;                      %消息比特个数
M=2;                            %BPSK调制
L=7;                            %约束长度
trel=poly2trellis(L,[171 133]); %卷积码生成多项式
  
msg=randint(1,N);               %消息比特序列
msg1=convenc(msg,trel);         %卷积编码
x1=pskmod(msg1,M);              %BPSK调制
for ii=1:length(EbNo)
    ii
    y=awgn(x1,EbNo(ii)-3);          %加入高斯白噪声，因为码率为1/2，所以每个符号的能量要比比特能量少3dB
    y1=pskdemod(y,M);               %硬判决
    y1=vitdec(y1,trel,tblen,'cont','hard');                     %Viterbi译码
    [err,ber1(ii)]=biterr(y1(tblen+1:end),msg(1:end-tblen));    %误比特率
    
    y2=vitdec(real(y),trel,tblen,'cont','unquant');             %软判决
    [err,ber2(ii)]=biterr(y2(tblen+1:end),msg(1:end-tblen));    %误比特率
    
end
ber=berawgn(EbNo,'psk',2,'nodiff');                             %BPSK调制理论误比特率
semilogy(EbNo,ber,'-ko',EbNo,ber1,'-k*',EbNo,ber2,'-k.');
legend('BPSK理论误比特率','硬判决误比特率','软判决误比特率')
title('卷积码性能')
xlabel('Eb/No');ylabel('误比特率')
