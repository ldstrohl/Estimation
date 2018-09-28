% Rolling Motion State Equation
% Lloyd Strohl
% 09/06/18
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xk = RollMotionSE(x,u)
xk = [x(2);...
      x(3)*x(2)+x(4)*u;...
      0;...
      0];
end
