clear all
%%%%%%%%%%%%% 参数设置部分 %%%%%%%%%%%%%%%%%

Nsp=52;             %系统子载波数（不包括直流载波）
Nfft=64;            % FFT 长度
Ncp=16;             % 循环前缀长度
Ns=Nfft+Ncp;        % 1个完整OFDM符号长度
noc=53;             % 包含直流载波的总的子载波数
Nd=6;               % 每帧包含的OFDM符号数(不包括训练符号)
M1=4;               % QPSK调制
M2=16;              % 16-QAM调制
sr=250000;          % OFDM符号速率
EbNo=0:2:30;      	% 归一化信噪比
Nfrm=10000;                         % 每种信噪比下的仿真帧数
ts=1/sr/Ns;                         % OFDM符号抽样时间间隔
t=0:ts:(Ns*(Nd+1)*Nfrm-1)*ts;      % 抽样时刻
fd=100;                             % 最大多普勒频移
h=rayleigh(fd,t);                   % 生成单径Rayleigh衰落信道
h1=sqrt(2/3)*h;
h2=sqrt(1/3)*rayleigh(fd,t);
h2=[zeros(1,4) h2(1:end-4)];



%训练符号频域数据,采用802.11a中的长训练符号数据
Preamble=[1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 ...
    1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1];
Preamble1=zeros(1,Nfft);
Preamble1(2:27)=Preamble(27:end);                   % 前导重排后的数据
Preamble1(39:end)=Preamble(1:26);
preamble1=ifft(Preamble1);                          % 训练符号时域数据
preamble1=[preamble1(Nfft-Ncp+1:end) preamble1];    % 加入循环前缀

%%%%%%%%%%%%%%%%%%%%% 仿真循环 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for ii=1:length(EbNo)
     %**************************发射机部分 *****************************
    msg1=randsrc(Nsp,Nd*Nfrm,[0:M1-1]);         % QPSK信息数据
    msg2=randsrc(Nsp,Nd*Nfrm,[0:M2-1]);         % 16-QAM信息数据

    data1=pskmod(msg1,M1,pi/4);                 % QPSK调制
    data2=qammod(msg2,M2)/sqrt(10);             % 16-QAM调制并归一化

    data3=zeros(Nfft,Nd*Nfrm);                  % 根据FFT要求，对数据重排
    data4=zeros(Nfft,Nd*Nfrm);

    data3(2:27,:)=data1(27:end,:);
    data3(39:end,:)=data1(1:26,:);

    data4(2:27,:)=data2(27:end,:);
    data4(39:end,:)=data2(1:26,:);
        
    clear data1 data2;                           % 清除不需要的临时变量

    data3=ifft(data3);                          % IFFT变换
    data4=ifft(data4);

    data3=[data3(Nfft-Ncp+1:end,:);data3];      % 加入循环前缀
    data4=[data4(Nfft-Ncp+1:end,:);data4];

    spow1=norm(data3,'fro').^2/(Nsp*Nd*Nfrm);   % 计算符号能量
    spow2=norm(data4,'fro').^2/(Nsp*Nd*Nfrm);
        
    data5=zeros(Ns,(Nd+1)*Nfrm);                % 加入训练符号
    data6=data5;
    for indx=1:Nfrm
        data5(:,(indx-1)*(Nd+1)+1)=preamble1.';
        data5(:,(indx-1)*(Nd+1)+2:indx*(Nd+1))=data3(:,(indx-1)*Nd+1:indx*Nd);
         
        data6(:,(indx-1)*(Nd+1)+1)=preamble1.';
        data6(:,(indx-1)*(Nd+1)+2:indx*(Nd+1))=data4(:,(indx-1)*Nd+1:indx*Nd);
    end
        
    clear data3 data4;                                  % 清除不需要的临时变量
        
    data5=reshape(data5,1,Ns*(Nd+1)*Nfrm);               % 并串变换    
    data6=reshape(data6,1,Ns*(Nd+1)*Nfrm);
        
    data51=zeros(1,length(data5));
    data61=zeros(1,length(data6));
    data51(5:end)=data5(1:end-4);
    data61(5:end)=data6(1:end-4);
       
    sigma1=sqrt(1/2*spow1/log2(M1)*10.^(-EbNo(ii)/10)); % 根据EbNo计算噪声标准差
    sigma2=sqrt(1/2*spow2/log2(M2)*10.^(-EbNo(ii)/10));

    for indx=1:Nfrm
        dd1=data5((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));
        dd2=data6((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));
        dd3=data51((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));
        dd4=data61((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));
            
        hh=h((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));      % 当前帧的单径信道参数
        hh1=h1((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));    % 当前帧的2径信道参数
        hh2=h2((indx-1)*Ns*(Nd+1)+1:indx*Ns*(Nd+1));
            
        % 信号通过单径衰落信道，并加入高斯白噪声
        r1=hh.*dd1+sigma1*(randn(1,length(dd1))+j*randn(1,length(dd1)));   
        r2=hh.*dd2+sigma2*(randn(1,length(dd2))+j*randn(1,length(dd2)));
            
        % 信号通过2径衰落信道，并加入高斯白噪声
        r11=hh1.*dd1+hh2.*dd3+sigma1*(randn(1,length(dd1))+j*randn(1,length(dd1)));   
        r21=hh1.*dd2+hh2.*dd4+sigma2*(randn(1,length(dd2))+j*randn(1,length(dd2)));   

        r1=reshape(r1,Ns,Nd+1);                     % 串并变换
        r2=reshape(r2,Ns,Nd+1);

        r11=reshape(r11,Ns,Nd+1);
        r21=reshape(r21,Ns,Nd+1);

        r1=r1(Ncp+1:end,:);                         % 移除循环前缀
        r2=r2(Ncp+1:end,:);            

        r11=r11(Ncp+1:end,:);  
        r21=r21(Ncp+1:end,:);
            
        R1=fft(r1);                                 % fft运算
        R2=fft(r2);

        R11=fft(r11);
        R21=fft(r21);

        R1=[R1(39:end,:);R1(2:27,:)];               % 数据重排
        R2=[R2(39:end,:);R2(2:27,:)];
        R11=[R11(39:end,:);R11(2:27,:)];
        R21=[R21(39:end,:);R21(2:27,:)];
          
        HH1=(Preamble.')./R1(:,1);                  % 信道估计
        HH2=(Preamble.')./R2(:,1);                   
        
        HH11=(Preamble.')./R11(:,1);            
        HH21=(Preamble.')./R21(:,1); 
            
        HH1=HH1*ones(1,Nd);
        HH2=HH2*ones(1,Nd);
        HH11=HH11*ones(1,Nd);
        HH21=HH21*ones(1,Nd);        
            
        x1=R1(:,2:end).*HH1;                        % 信道补偿
        x2=R2(:,2:end).*HH2;
        x3=R11(:,2:end).*HH11;                      
        x4=R21(:,2:end).*HH21;
        
        x1=pskdemod(x1,M1,pi/4);                    % 数据解调
        x2=qamdemod(x2.*sqrt(10),M2);
            
        x3=pskdemod(x3,M1,pi/4);                  
        x4=qamdemod(x4.*sqrt(10),M2);        

        [neb1(indx),temp]=biterr(x1,msg1(:,(indx-1)*Nd+1:indx*Nd),log2(M1)); % 统计一帧中的错误比特数
        [neb2(indx),temp]=biterr(x2,msg2(:,(indx-1)*Nd+1:indx*Nd),log2(M2));
        [neb3(indx),temp]=biterr(x3,msg1(:,(indx-1)*Nd+1:indx*Nd),log2(M1)); 
        [neb4(indx),temp]=biterr(x4,msg2(:,(indx-1)*Nd+1:indx*Nd),log2(M2));
    end
    ber1(ii)=sum(neb1)/(Nsp*log2(M1)*Nd*Nfrm);     % 理想信道估计的误比特率
    ber2(ii)=sum(neb2)/(Nsp*log2(M2)*Nd*Nfrm);

    ber3(ii)=sum(neb3)/(Nsp*log2(M1)*Nd*Nfrm);     % 非理想信道估计的误比特率
    ber4(ii)=sum(neb4)/(Nsp*log2(M2)*Nd*Nfrm);
            
end

semilogy(EbNo,ber1,'-ro',EbNo,ber3,'-rv',EbNo,ber2,'-r*',EbNo,ber4,'-rx')
grid on
title('OFDM系统误比特率性能')
legend('QPSK 单径信道','QPSK 2径信道','16-QAM 单径信道','16-QAM 2径信道')
xlabel('信噪比(EbNo)')
ylabel('误比特率')

    
    
