% Objective function for least squares parameter estimation
function f = objFun(L,xdata) 
Lp = L(1);
Lda = L(2);
p = xdata(:,1);
da = xdata(:,2);
f = Lp*p+Lda*da;

end
