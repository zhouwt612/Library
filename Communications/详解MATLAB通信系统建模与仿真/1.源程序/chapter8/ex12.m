clear all
N=10000;            
k=4;                        %编码消息比特长度
n=7;                        %编码码字长度
x=randint(N*k,1);           %消息比特
code=encode(x,n,k);         %（7，4）Hamming编码
code1=matintrlv(code,N/10,10*n);                        %(N/10,10*n)矩阵交织
noise=randerr(N,n,[0:n-3;0.8 0.09 0.07 0.03 0.01]);     %信道差错，包括独立差错和突发差错
noise=reshape(noise.',N*n,1);
y=bitxor(code,noise);           %无交织接收信号
y=decode(y,n,k);                %Hamming译码
[err,ber]=biterr(x,y);          %统计误比特率

y1=bitxor(code1,noise);         %有交织接收信号
y1=matdeintrlv(y1,N/10,10*n);   %解交织
y1=decode(y1,n,k);              %Hamming译码
[err1,ber1]=biterr(x,y1);       %统计误比特率
disp('无交织时的误比特率:');
ber
disp('有交织时的误比特率:');
ber1



