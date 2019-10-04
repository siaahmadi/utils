function arm = rad2arm(x)
%RAD2ARM Turn an angle to arm on the 8-arm radial maze
%
% arm = RAD2ARM(x)

arm = interp1([0, pi/4, pi/2, 3*pi/4, pi, 5*pi/4, 3*pi/2, 7*pi/4, 2*pi], [1:8, 1], mod(2*pi-x, 2*pi), 'nearest');