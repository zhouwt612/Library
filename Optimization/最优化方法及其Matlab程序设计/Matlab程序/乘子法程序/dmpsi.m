function dpsi=dmpsi(x,fun,hf,gf,dfun,dhf,dgf,mu,lambda,sigma)
dpsi=feval(dfun,x);
he=feval(hf,x);  gi=feval(gf,x);
dhe=feval(dhf,x);  dgi=feval(dgf,x);
l=length(he); m=length(gi);
for(i=1:l)
    dpsi=dpsi+(sigma*he(i)-mu(i))*dhe(:,i);
end
for(i=1:m)
    dpsi=dpsi+(sigma*gi(i)-lambda(i))*dgi(:,i);
end