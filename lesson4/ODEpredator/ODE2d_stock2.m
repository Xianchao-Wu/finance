%%%%%%%%%%%%%%%%%%%%%%%
% 2d_ODE.m
% non-linear ODE, two stock error-correction ODE
%%%%%%%%%%%%%%%%%%%%%%%
function[dy]=ODE2d_stock2(t,y,gama1,gama2,beta)
%
% y(1) --> a(tau)
% y(2) --> b(tau)
%
dy = zeros(2,1);    % a column vector

% -- stock 1 ---
dy(1) = gama1 * (y(2) - beta * y(1));

% -- stock 2 ----
dy(2) = gama2 * (y(2) - beta * y(1));
