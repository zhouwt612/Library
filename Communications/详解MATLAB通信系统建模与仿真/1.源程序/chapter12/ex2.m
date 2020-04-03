%ex2.m
%仿真Alamouti 2发2收空时编码性能，调制方式为QPSK
clear all
datasize=100000;                    % 仿真的符号数
EbNo=0:2:20;                         % 信噪比
M=4;                                % QPSK modulation
x=randsrc(2,datasize/2,[0:3]);      % 数据源符号
x1=pskmod(x,M,pi/4);       
h=randn(4,datasize/2)+j*randn(4,datasize/2);   %Rayleigh衰落信道
h=h./sqrt(2);                             
for indx=1:length(EbNo)
    sigma1=sqrt(1/(4*10.^(EbNo(indx)/10)));              % SISO信道高斯白噪声标准差
    n=sigma1*(randn(2,datasize/2)+j*randn(2,datasize/2));
    y=x1+n;                                             % 通过AWGN信道
    y1=x1+n./h(1:2,:);                                         % 通过SISO瑞利衰落信道后的判决变量
    x2=pskdemod(y,M,pi/4);
    x3=pskdemod(y1,M,pi/4);
    sigma2=sqrt(1/(2*10.^(EbNo(indx)/10)));                      % Alamouti方案每个子信道高斯白噪声标准差
    n=sigma2*(randn(4,datasize/2)+j*randn(4,datasize/2));
    n1(1,:)=(conj(h(1,:)).*n(1,:)+h(2,:).*conj(n(2,:)))./(sum(abs(h(1:2,:)).^2));    % 2发1收Alamouti方案判决变量中的噪声项
    n1(2,:)=(conj(h(2,:)).*n(1,:)-h(1,:).*conj(n(2,:)))./(sum(abs(h(1:2,:)).^2));
    y=x1+n1;
    x4=pskdemod(y,M,pi/4);
    n2(1,:)=(conj(h(1,:)).*n(1,:)+h(2,:).*conj(n(2,:))+conj(h(3,:)).*n(3,:)+h(4,:).*conj(n(4,:)))./(sum(abs(h).^2));    % 2发2收Alamouti方案判决变量中的噪声项
    n2(2,:)=(conj(h(2,:)).*n(1,:)-h(1,:).*conj(n(2,:))+conj(h(4,:)).*n(3,:)-h(3,:).*conj(n(4,:)))./(sum(abs(h).^2));
    y1=x1+n2;
    x5=pskdemod(y1,M,pi/4);
    [temp,ber1(indx)]=biterr(x,x2,log2(M));
    [temp,ber2(indx)]=biterr(x,x3,log2(M));
    [temp,ber3(indx)]=biterr(x,x4,log2(M));
    [temp,ber4(indx)]=biterr(x,x5,log2(M));
    
end
semilogy(EbNo,ber1,'-k*',EbNo,ber2,'-ko',EbNo,ber3,'-kd',EbNo,ber4,'-k.')
grid on
legend('AWGN信道','SISO瑞利衰落信道','2发1收Alamouti方案','2发2收Alamouti方案')
xlabel('信噪比EbNo(dB)')
ylabel('误比特率(BER)')
title('Alamouti方案在瑞利衰落信道下的性能')