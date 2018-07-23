function R = rot(Z,Y,X)

% X = phi;Y=theta;Z=psi;
Rx = [1 0 0;0 cos(X) sin(X);0 -sin(X) cos(X)];

Ry = [cos(Y) 0 -sin(Y);0 1 0;sin(Y) 0 cos(Y)];

Rz = [cos(Z) sin(Z) 0 ;-sin(Z) cos(Z) 0;0 0 1];

R = Rx*Ry*Rz; % puts into body frame

% R1 = [cos(Y)*cos(Z),cos(Y)*sin(Z),-sin(Y);
%     sin(X)*sin(Y)*cos(Z)-cos(X)*sin(Z),sin(X)*sin(Y)*sin(Z)+cos(X)*cos(Z),sin(X)*cos(Y);
%     cos(X)*sin(Y)*cos(Z)+sin(X)*sin(Z),cos(X)*sin(Y)*sin(Z)-sin(X)*cos(Z),cos(X)*cos(Y)];

% Rx = [1 0 0;0 cos(X) -sin(X);0 sin(X) cos(Y)];
% Ry = [cos(Y) 0 sin(Y);0 1 0;-sin(Y) 0 cos(Y)];
% Rz = [cos(Z) -sin(Z) 0;sin(Z) cos(Z) 0;0 0 1];
% 
% R1 = Rz*Ry*Rx; % puts into vehicle frame

R = R'; % puts into vehicle frame

end