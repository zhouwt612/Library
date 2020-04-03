%the example of switch-case
function s=myfun1(x)
 
switch x
    case 1
        s=2;
    case 2
        s=3;
    case 3
        s=5;
    otherwise 
        s=6;
end