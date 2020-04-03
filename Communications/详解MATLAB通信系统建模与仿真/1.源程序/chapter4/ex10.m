clear all
nSamp = 8;              %矩形脉冲的取样点数
numSymb = 10000;       %每种SNR下的传输的符号数
ts=1/(numSymb*nSamp);
t=(0:numSymb*nSamp-1)*ts;

M=4;                    %QPSK的符号类型数
SNR=-3:3;               %SNR的范围
grayencod=[0 1 3 2];    %Gray编码格式
for ii=1:length(SNR)
    msg=randsrc(1,numSymb,[0:3]);           %产生发送符号
    msg_gr=grayencod(msg+1);                %进行Gray编码影射
    msg_tx=pskmod(msg_gr,M);                %QPSK调制
    msg_tx=rectpulse(msg_tx,nSamp);         %矩形脉冲成形
    h=rayleigh(10,t);                       %生成瑞利衰落
    msg_tx1=h.*msg_tx;                      %信号通过瑞利衰落信道
    msg_rx=awgn(msg_tx,SNR(ii));            %通过AWGN信道
    msg_rx1= msg_tx1;
    msg_rx_down = intdump(msg_rx,nSamp);    %匹配滤波相干解调    
    msg_rx_down1 = intdump(msg_rx1,nSamp);
    msg_gr_demod = pskdemod(msg_rx_down,M); %QPSK解调
    msg_gr_demod1 = pskdemod(msg_rx_down1,M);
    [dummy graydecod] = sort(grayencod); graydecod = graydecod - 1;
    msg_demod = graydecod(msg_gr_demod+1);                  %Gray编码逆映射
    msg_demod1 = graydecod(msg_gr_demod1+1);
    [errorBit BER(ii)] = biterr(msg, msg_demod, log2(M));   %计算AWGN信道BER
    [errorBit1 BER1(ii)] =biterr(msg,msg_demod1,log2(M));   %计算瑞利衰落+AWGN信道BER
    [errorSym SER(ii)] = symerr(msg, msg_demod);            %计算AWGN信道SER
    [errorSym SER1(ii)] = symerr(msg, msg_demod1);          %计算瑞利衰落+AWGN信道SER
end
figure
semilogy(SNR,BER,'-ro',SNR,SER,'-r*',SNR,BER1,'-r.',SNR,SER1,'-r^')       %画出BER和SER随SNR变化的曲线
legend('AWGN信道BER','AWGN信道SER','Rayleigh衰落+AWGN信道BER','Rayleigh衰落+AWGN信道SER')
title('QPSK在AWGN和Rayleigh衰落信道下的性能')
xlabel('信噪比（dB）')
ylabel('误符号率和误比特率')