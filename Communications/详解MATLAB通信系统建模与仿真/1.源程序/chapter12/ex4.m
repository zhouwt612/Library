%ex4.m
%仿真V-BALST结构MMSE检测算法性能，调制方式为QPSK
clear all
Nt=4;                           % 发射天线数
Nr=4;                           % 接收天线数
N=10;                           % 每帧的长度
L=10000;                        % 仿真的总帧数
EbNo=0:2:20;                    % 信噪比
M=4;                            % QPSK 调制方式
x=randint(N*L,Nt,M);            % 信源数据
s=pskmod(x,M,pi/4);             % QPSK调制
                       
for indx=1:length(EbNo)
    x1=[];
    x2=[];
    x3=[];
    for indx1=1:L
        h=randn(Nt,Nr)+j*randn(Nt,Nr);          % Rayleigh衰落信道
        h=h./sqrt(2);                           % 信道系数归一化

        sigma1=sqrt(1/(10.^(EbNo(indx)/10)));   % 每根接收天线的高斯白噪声标准差
        n=sigma1*(randn(N,Nr)+j*randn(N,Nr));   % 每根接收天线的高斯白噪声
        w=h'*inv(h*h'+2*sigma1.^2*diag(ones(1,Nt)));    % w的最优解
        
        y=s((indx1-1)*N+1:indx1*N,:)*h+n;       % 信号通过信道
        yy=y;
        y1=y*w;                                 % 无干扰消除时的MMSE检测
        temp1=pskdemod(y1,M,pi/4);              % 无干扰消除时的解调    
        x1=[x1;temp1];                          % 无干扰消除时的解调结果
        
        temp2(:,Nt)=temp1(:,Nt);
        y=y-pskmod(temp2(:,Nt),4,pi/4)*h(Nt,:);     % 非理想干扰消除时，接收信号矩阵的更新
        
        temp3(:,Nt)=temp1(:,Nt);
        yy=yy-s((indx1-1)*N+1:indx1*N,Nt)*h(Nt,:);  % 理想干扰消除时，接收信号矩阵的更新
        
        h=h(1:Nt-1,:);                              % 信道矩阵更新     
        
        for ii=Nt-1:-1:1
            w=h'*inv(h*h'++2*sigma1.^2*diag(ones(1,ii)));   % 信道矩阵更新后的w
            
            y1=y*w;                                         % 非理想干扰消除的检测与解调     
            temp2(:,ii)=pskdemod(y1(:,ii),M,pi/4);      
            y=y-pskmod(temp2(:,ii),4,pi/4)*h(ii,:);
            
            yy1=yy*w;                                       % 理想干扰消除的检测与解调
            temp3(:,ii)=pskdemod(yy1(:,ii),M,pi/4);
            yy=yy-s((indx1-1)*N+1:indx1*N,ii)*h(ii,:);
        
            h=h(1:ii-1,:);
        end

        x2=[x2;temp2];                      % 非理想干扰消除的解调结果
        x3=[x3;temp3];                      % 理想干扰消除的解调结果
    end
            
    [temp,ber1(indx)]=biterr(x,x1,log2(M));             % 无干扰消除时的系统误码率
    [temp,ber2(indx)]=biterr(x,x2,log2(M));             % 非理想干扰消除时系统总的误码率
    [temp,ber3(indx)]=biterr(x,x3,log2(M));             % 理想干扰消除时系统总的误码率
    
    [temp,ber24(indx)]=biterr(x(:,1),x2(:,1),log2(M));   % 非理想干扰消除时第4层的误码率
    [temp,ber23(indx)]=biterr(x(:,2),x2(:,2),log2(M));   % 非理想干扰消除时第3层的误码率
    [temp,ber22(indx)]=biterr(x(:,3),x2(:,3),log2(M));   % 非理想干扰消除时第2层的误码率
    [temp,ber21(indx)]=biterr(x(:,4),x2(:,4),log2(M));   % 非理想干扰消除时第1层的误码率
    
    [temp,ber34(indx)]=biterr(x(:,1),x3(:,1),log2(M));   % 理想干扰消除时第4层的误码率
    [temp,ber33(indx)]=biterr(x(:,2),x3(:,2),log2(M));   % 理想干扰消除时第3层的误码率
    [temp,ber32(indx)]=biterr(x(:,3),x3(:,3),log2(M));   % 理想干扰消除时第2层的误码率
    [temp,ber31(indx)]=biterr(x(:,4),x3(:,4),log2(M));   % 理想干扰消除时第1层的误码率


    
end
semilogy(EbNo,ber1,'-k*',EbNo,ber2,'-ko',EbNo,ber3,'-kd')
title('V-BLAST结构MMSE检测算法性能')
legend('无干扰消除','非理想干扰消除','理想干扰消除')
xlabel('EbNo(dB)')
ylabel('BER')

figure
semilogy(EbNo,ber34,'-k*',EbNo,ber33,'-ko',EbNo,ber32,'-kd',EbNo,ber31,'-k^')
title('理想干扰消除时MMSE检测算法各层性能')
legend('第1层','第2层','第3层','第4层')
xlabel('EbNo(dB)')
ylabel('BER')

figure
semilogy(EbNo,ber24,'-k*',EbNo,ber23,'-ko',EbNo,ber22,'-kd',EbNo,ber21,'-k^')
title('非理想干扰消除时MMSE检测算法各层性能')
legend('第1层','第2层','第3层','第4层')
xlabel('EbNo(dB)')
ylabel('BER')
