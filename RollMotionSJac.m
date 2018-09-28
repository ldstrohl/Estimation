% Rolling Motion State Transition Jacobian
% % Lloyd Strohl
% 09/05/18
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = RollMotionSJac(x,u,dt)
F = [1, dt,        0,       0;...
     0, dt*x(3)+1, dt*x(2), dt*u;...
     0, 0,         1,       0;...
     0, 0,         0,       1];
end
