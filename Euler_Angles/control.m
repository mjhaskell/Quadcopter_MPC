function out = control(in,P)
persistent dt_prev

pn_r = in(1);
pe_r = in(2);
h_r  = in(3);
psi_r = in(4);
x_k = [in(5);in(6);in(7);in(8);in(9);in(10);in(11);in(12);in(13);in(14);in(15);in(16)];
t = in(17);

if t==0,dt_prev = []; end

r = [pn_r;pe_r;h_r;0;0;psi_r;0;0;0;0;0;0];
% if dt < .01
%     dt_prev = [dt_prev;dt(6)];
%     figure(2)
%     plot(dt_prev)
%     title('Optimization Solve Time')
%     xlabel('Iteration #')
%     ylabel('Solve Time (s)')
% end

% params.A = P.Ad;
params.A = getA(in(8),in(9),in(10),P);
params.B = P.Bd;

params.u_des_0 = P.Fe;
params.u_des_1 = P.Fe;
params.u_des_2 = P.Fe;
params.u_des_3 = P.Fe;
params.u_des_4 = P.Fe;
params.u_des_5 = P.Fe;
params.u_des_6 = P.Fe;
params.u_des_7 = P.Fe;
params.u_des_8 = P.Fe;
params.u_des_9 = P.Fe;
params.u_des_10 = P.Fe;

params.x_des_0 = r;
% params.x_des_1 = [ref_sq(P.z_r.A,0.04,0,t+1*P.ts);ref_sq(1.0,0.05,1.5,t+1*P.ts);0;0;0;0];
% params.x_des_2 = [ref_sq(P.z_r.A,0.04,0,t+2*P.ts);ref_sq(1.0,0.05,1.5,t+2*P.ts);0;0;0;0];
% params.x_des_3 = [ref_sq(P.z_r.A,0.04,0,t+3*P.ts);ref_sq(1.0,0.05,1.5,t+3*P.ts);0;0;0;0];
% params.x_des_4 = [ref_sq(P.z_r.A,0.04,0,t+4*P.ts);ref_sq(1.0,0.05,1.5,t+4*P.ts);0;0;0;0];
% params.x_des_5 = [ref_sq(P.z_r.A,0.04,0,t+5*P.ts);ref_sq(1.0,0.05,1.5,t+5*P.ts);0;0;0;0];
% params.x_des_6 = [ref_sq(P.z_r.A,0.04,0,t+6*P.ts);ref_sq(1.0,0.05,1.5,t+6*P.ts);0;0;0;0];
% params.x_des_7 = [ref_sq(P.z_r.A,0.04,0,t+7*P.ts);ref_sq(1.0,0.05,1.5,t+7*P.ts);0;0;0;0];
% params.x_des_8 = [ref_sq(P.z_r.A,0.04,0,t+8*P.ts);ref_sq(1.0,0.05,1.5,t+8*P.ts);0;0;0;0];
% params.x_des_9 = [ref_sq(P.z_r.A,0.04,0,t+9*P.ts);ref_sq(1.0,0.05,1.5,t+9*P.ts);0;0;0;0];
% params.x_des_10 = [ref_sq(P.z_r.A,0.04,0,t+10*P.ts);ref_sq(1.0,0.05,1.5,t+10*P.ts);0;0;0;0];
% params.x_des_11 = [ref_sq(P.z_r.A,0.04,0,t+11*P.ts);ref_sq(1.0,0.05,1.5,t+11*P.ts);0;0;0;0];
params.x_des_1 = r;
params.x_des_2 = r;
params.x_des_3 = r;
params.x_des_4 = r;
params.x_des_5 = r;
params.x_des_6 = r;
params.x_des_7 = r;
params.x_des_8 = r;
params.x_des_9 = r;
params.x_des_10 = r;
params.x_des_11 = r;


params.u_max = 1;
params.u_min = 0;
params.x_0 = x_k;

% Weights for static A
% params.S = 100*0;
% params.Wu = diag(0.1*[1,1,1,1]);
% params.Wy = diag([2,2,30, 10,10,1, 2,2,15, 75,75,1]);
% params.Wy_final = diag([5,5,50, 10,10,1, 10,10,20, 100,100,1]);

% Weights for dynamic A (slow psi)
% params.Wu = diag(0.1*[1,1,1,1]);
% params.Wy = diag([1.5,1.5,20, 1,1,1, 2,2,2, 50,50,5]);
% params.Wy_final = params.Wy;

% Weights for dynamic A (fast psi)
params.Wu = diag(0.1*[1,1,1,1]);
params.Wy = diag([1.5,1.5,20, 1,1,5, 2,2,2, 50,50,1]);
params.Wy_final = params.Wy;

% Create a new settings structure, with some example settings.
settings.verbose = 1;  % disable output of solver progress w/ 0.
settings.max_iters = 25;  % reduce the maximum iteration count, from 25.
settings.eps = 1e-6;  % reduce the required objective tolerance, from 1e-6.
settings.resid_tol = 1e-4;  % reduce the required residual tolerances, from 1e-4.
c1 = clock;
[vars,status] = csolve(params,settings);
c2 = clock;
if ~status.converged, print('csolve failed to converge'); end

dt = c2-c1;
% if dt < .01
%     dt_prev = [dt_prev;dt(6)];
%     figure(2)
%     plot(dt_prev)
%     title('Optimization Solve Time')
%     xlabel('Iteration #')
%     ylabel('Solve Time (s)')
% end
    
u = vars.u_0;
    
out = u;
end