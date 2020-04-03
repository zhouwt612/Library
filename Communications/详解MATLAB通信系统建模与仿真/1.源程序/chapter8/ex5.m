m = 4; n = 2^m-1;       %码字长度
k = 5;                  %消息长度 
N= 100;                  %消息行数 
msg = randint(N,k);     %消息序列
[genpoly,t] = bchgenpoly(n,k);  %（15，5）BCH码的纠错能力

code = bchenc(gf(msg),n,k);                 %BCH编码
noisycode = code + randerr(N,n,1:t);       %每个码字加入不超过纠错能力的误码
[newmsg,err,ccode] = bchdec(noisycode,n,k); %BCH译码
if ccode==code
   disp('所有错误比特都被纠正。')
end
if newmsg==msg
   disp('译码消息与原消息相同。')
end