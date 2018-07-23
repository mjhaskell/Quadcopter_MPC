function out = new_control(in,P)
persistent dt_prev

pn_r = in(1);
pe_r = in(2);
h_r  = in(3);
psi_r = in(4);

p_k = in(5:7);
R_k = reshape(in(8:16),3,3); % Rb2v
v_k = in(17:19);
w_k = in(20:22);
% x_k = [in(5);in(6);in(7);in(8);in(9);in(10);in(11);in(12);in(13);in(14);in(15);in(16)];
t = in(23);

if t==0,dt_prev = []; end

R_des = rotz(psi_r);
PHI_k = vex(logm(R_des'*R_k));
% PHI_k = 0.5*vex(R_des'*R_k-R_k'*R_des);%.*w_k;

x_k = [p_k;PHI_k;v_k;w_k];

r = [pn_r;pe_r;h_r;0;0;0;0;0;0;0;0;0];
% if dt < .01
%     dt_prev = [dt_prev;dt(6)];
%     figure(2)
%     plot(dt_prev)
%     title('Optimization Solve Time')
%     xlabel('Iteration #')
%     ylabel('Solve Time (s)')
% end

% params.A = P.Ad;

params.A = getA(R_k,v_k,w_k,P);
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

% Current gains for simple A
% params.Wu = diag(1*[1,1,1,1]);
% params.Wy = diag([18,18,250, .01,.01,20, 30.75,30.75,15, .1,.1,1]);
% params.Wy_final = diag([50,50,100, .1,.1,2, 60,60,115, 1,1,2]);

% Current gains for more complex A
params.Wu = diag(1*[1,1,1,1]);
params.Wy = diag([20,20,250, .01,.01,15, 30.75,30.75,15, .1,.1,1.1]);
params.Wy_final = diag([50,50,100, .1,.1,2, 60,60,115, 1,1,2]);

% testing gains for full A
% params.Wu = diag(1*[1,1,1,1]);
% params.Wy = diag([18,18,50, .01,.01,50, 25.75,25.75,15, .1,.1,1]);
% params.Wy_final = diag([50,50,100, .1,.1,2, 60,60,115, 1,1,2]);

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