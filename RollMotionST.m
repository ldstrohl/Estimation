% Rolling Motion State Transition function
% Lloyd Strohl
% 09/05/18

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function xk = RollMotionST(x,u,dt)
xk = [x(1) + x(2)*dt;...
      (x(2)*x(3)+x(4)*u)*dt + x(2);...
      x(3);...
      x(4)];      
end
