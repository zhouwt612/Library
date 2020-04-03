clear all
N=10;                       %信息比特的行数
n=7;                        %Hamming码组长度n=2^m-1
m=3;                        %监督位长度
[H,G]=hammgen(m);           %产生(n,n-m)Hamming码的生成矩阵和校验矩阵
x=randint(N,n-m);           %产生比特数据
y=mod(x*G,2);               %Hamming编码        
y1=mod(y+randerr(N,n),2);   %在每个编码码组中引入一个随机比特错误
mat1=eye(n);                %生成n*n的单位矩阵，其中每一行中的1代表错误比特位置
errvec=mat1*H.';            %校验结果对应的所有错误向量
y2=mod(y1*H.',2);           %译码
for indx=1:N
    for indx1=1:n
        if(y2(indx,:)==errvec(indx1,:))
            y1(indx,:)=mod(y1(indx,:)+mat1(indx1,:),2); %根据译码结果对应的错误向量找出错误比特的位置，并纠错
        end
    end
end
x_dec=y1(:,m+1:end);        %恢复原始信息比特
s=find(x~=x_dec)            %纠错后的信息比特与原始信息比特对比
