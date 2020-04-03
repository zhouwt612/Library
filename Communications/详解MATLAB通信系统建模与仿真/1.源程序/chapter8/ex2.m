clear all
N=100000;               %信息比特行数
M=4;                    %QPSK调制
n=7;                    %Hamming编码码组长度
m=3;                    %Hamming码监督位长度
graycode=[0 1 3 2];

msg=randint(N,n-m);     %信息比特
msg1=reshape(msg.',log2(M),N*(n-m)/log2(M)).';
msg1_de=bi2de(msg1,'left-msb');     %信息比特转换为10进制形式
msg1=graycode(msg1_de+1);           %Gray编码
msg1=pskmod(msg1,M);                %QPSK调制
Eb1=norm(msg1).^2/(N*(n-m));        %计算比特能量
msg2=encode(msg,n,n-m);             %Hamming编码
msg2=reshape(msg2.',log2(M),N*n/log2(M)).';
msg2=bi2de(msg2,'left-msb');
msg2=graycode(msg2+1);              %Hamming编码后的比特序列转换为10进制形式
msg2=pskmod(msg2,M);                %Hamming编码数据进行QPSK调制
Eb2=norm(msg2).^2/(N*(n-m));        %计算比特能量
EbNo=0:2:10;                          %信噪比
EbNo_lin=10.^(EbNo/10);             %信噪比的线性值
for indx=1:length(EbNo_lin)
    indx
    sigma1=sqrt(Eb1/(2*EbNo_lin(indx)));    %未编码的噪声标准差
    rx1=msg1+sigma1*(randn(1,length(msg1))+j*randn(1,length(msg1)));    %加入高斯白噪声
    y1=pskdemod(rx1,M);                     %未编码QPSK解调
    y1_de=graycode(y1+1);                   %未编码的Gray逆映射
    [err ber1(indx)]=biterr(msg1_de.',y1_de,log2(M));   %未编码的误比特率
    
    sigma2=sqrt(Eb2/(2*EbNo_lin(indx)));    %编码的噪声标准差
    rx2=msg2+sigma2*(randn(1,length(msg2))+j*randn(1,length(msg2)));    %加入高斯白噪声   
    y2=pskdemod(rx2,M);                     %编码QPSK解调
    y2=graycode(y2+1);                      %编码Gray逆映射
    y2=de2bi(y2,'left-msb');                %转换为二进制形式
    y2=reshape(y2.',n,N).';
    y2=decode(y2,n,n-m);                    %译码
    [err ber2(indx)]=biterr(msg,y2);        %编码的误比特率

end
semilogy(EbNo,ber1,'-ko',EbNo,ber2,'-k*');
legend('未编码','Hamming(7,4)编码')
title('未编码和Hamming(7,4)编码的QPSK在AWGN下的性能')
xlabel('Eb/No');ylabel('误比特率')