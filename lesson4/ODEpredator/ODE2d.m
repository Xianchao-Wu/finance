%%%%%%%%%%%%%%%%%%%%%%%
% 2d_ODE.m
% Lotka-Volterra predator-prey ODE
%%%%%%%%%%%%%%%%%%%%%%%
function[dy]=ODE2d(t,y,a,b,c,d)
%
% y(1) --> a(tau)
% y(2) --> b(tau)
%
dy = zeros(2,1);    % a column vector
 
% -- predator ---
dy(1) = a * y(1) * y(2) - b*y(1);

% -- prey ----
dy(2) = c*y(2) - d*y(1)*y(2)
