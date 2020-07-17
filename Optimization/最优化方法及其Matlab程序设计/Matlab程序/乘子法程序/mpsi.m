function psi=mpsi(x,fun,hf,gf,dfun,dhf,dgf,mu,lambda,sigma)
f=feval(fun,x);  he=feval(hf,x);  gi=feval(gf,x);
l=length(he); m=length(gi);
psi=f;  s1=0.0;
for(i=1:l)
    psi=psi-he(i)*mu(i);
    s1=s1+he(i)^2;
end
psi=psi+0.5*sigma*s1;
s2=0.0;
for(i=1:m)
    s3=max(0.0, lambda(i) - sigma*gi(i));
    s2=s2+s3^2-lambda(i)^2;
end
psi=psi+s2/(2.0*sigma);