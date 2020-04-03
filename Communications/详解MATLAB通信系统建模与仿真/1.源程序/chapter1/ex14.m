%ex1-14
for indx=100:999
    a1=fix(indx/100);               %求indx的百位数字
    a2=rem(fix(indx/10),10);        %求indx的十位数字
    a3=rem(indx,10);                %求indx的个位数字
    if indx==a1.^3+a2.^3+a3.^3
         indx
    end
end
