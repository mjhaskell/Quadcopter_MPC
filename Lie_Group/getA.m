function Ad = getA(R,v,w,P)

% simple A
%     A = [zeros(3,3),zeros(3),diag([1;1;-1]),zeros(3);
%          zeros(3,9),eye(3);
%          zeros(3),skew([0;0;P.g]),-P.mu/P.M*eye(3),zeros(3,3);
%          zeros(3,12)];

% more complex A
    A = [zeros(3,3),zeros(3),diag([1;1;-1])*R,zeros(3);
         zeros(3,9),eye(3);
         zeros(3),skew(R'*[0;0;P.g]),-P.mu/P.M*eye(3),zeros(3);
         zeros(3,12)];
     
% full A
%     J = diag([P.Jx;P.Jx;P.Jz]);
%     A = [zeros(3,3),diag([1;1;-1])*-R*skew(v),diag([1;1;-1])*R,zeros(3);
%          zeros(3,9),eye(3);
%          zeros(3),skew(R'*[0;0;P.g]),-P.mu/P.M*eye(3)-skew(w),skew(v);
%          zeros(3,9),inv(J)*(skew(J*w)-skew(w)*J)];     
     
    sys = ss(A,P.B,P.C,P.D);
    sys_d = c2d(sys,P.ts);
    [Ad,Bd,Cd,Dd] = ssdata(sys_d);
    
end