clear all
m=4;                    %每个信息符号包含的比特数
n=15;                   %码字长度
k=11;                   %码字中的信息符号数
t=(n-k)/2;              %码的纠错能力
N=1000;                 %信息符号的行数
msg=randint(N,k,2^m);   %信息符号
msg1=gf(msg,m);         
msg1=rsenc(msg1,n,k).'; %(15,11)RS编码
msg2=de2bi(double(msg1.x),'left-msb');  %转换为二进制
y=bsc(msg2,0.01);                       %通过二进制对称信道        
y=bi2de(y,'left-msb');                  %转换为10进制
y=reshape(y,n,N).';         
dec_x=rsdec(gf(y,4),n,k);               %RS解码
[err,ber]=biterr(msg,double(dec_x.x),m) %解码后的误比特率


msg3 = pskmod(msg1,8)
