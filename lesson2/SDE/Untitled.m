%clc; clear;
syms x y z t; % define variables x, y, z, lang t
f(x,y,z)=x + 2*y+3*z;
g = x^2 + y^2 + z^2 - 4; % set x^2 + y^2 + z^2 - 4 = 0 as the constraint
L = f - t * g;
sln = solve(diff(L, x) == 0, diff(L, y) == 0, diff(L, z) == 0, g==0);
eval(f(sln.x, sln.y, sln.z));