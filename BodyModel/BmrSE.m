% BMR State Equation
function xdot = BmrSE(x,~)
xdot = zeros(4,1);
xdot(1) = (x(2)-x(3))/x(4);

end
