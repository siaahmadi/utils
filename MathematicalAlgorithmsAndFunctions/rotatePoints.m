function [rotatedX, rotatedY] = rotatePoints(xVec, yVec, rotation)
[rotatedX, rotatedY] = rotatePoint(xVec, yVec, rotation);

function [rotatedX, rotatedY] = rotatePoint(x, y, rotation)
rho = eucldist(x, y, 0, 0);
theta = atan2(y, x) + rotation;

rotatedX = rho .* cos(theta);
rotatedY = rho .* sin(theta);
