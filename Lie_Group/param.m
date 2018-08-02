clear all

% Physical parameters of the Quadrotor known to the controller
P.mc = 2.0;      % Mass of the center, kg
P.mp = 0.25;     % Mass of a prop, kg
P.M = P.mc+4*P.mp; % total mass
P.d = 0.3;       % Distance from center to mid-prop, m
P.R = 0.1;       % Estimated radius of body (assumed spherical)

P.Jx = 2/5*P.mc*P.R^2 + 2*P.d^2*P.mp;
% P.Jy = P.Jx;
P.Jz = 2/5*P.mc*P.R^2 + 4*P.d^2*P.mp;
% P.J = [P.Jx 0 0;0 P.Jy 0;0 0 P.Jz]; % Inertia tensor
clear Jx Jz

P.g = 9.81;      % Gravity, m/s**2
P.mu = 0.1;      % Viscosity?, kg/s
s_eq = 0.55;     % Throttle signal equilibrium (hover)
k1 = P.M*P.g/(4*s_eq);     % F = k1*(s1+s2+s3+s4)
k2 = 0.1;        % This is a guess
P.Fe = s_eq*ones(4,1);%P.g*P.M/40*[1;1;1;1];
P.MM = [k1*ones(1,4);0 -P.d*k1 0 P.d*k1;P.d*k1 0 -P.d*k1 0;-k2 k2 -k2 k2];
% Minv = inv(P.M);
clear k1 k2 s_eq

% parameters for animation
P.test = .01*1;

% Initial Conditions
P.pn0 = 0.0;               % initial position (N), m
P.pe0 = 0.0;               % initial position (E), m
P.h0 = 0.0;                % initial position (-D), m
P.phi0 = 0.0*pi/180;       % initial roll angle, rad
P.theta0 = 0.0*pi/180;     % initial pitch angle, rad
P.psi0 = 0.0*pi/180;       % initial yaw angle, rad
P.u0 = 0.0;                % initial velocity (N), m/s
P.v0 = 0.0;                % initial velocity (E), m/s
P.w0 = 0.0;                % initial velocity (-D), m/s
P.p0 = 0.0;                % initial angular velocity (roll), rad/s
P.q0 = 0.0;                % initial angular velocity (pitch), rad/s
P.r0 = 0.0;                % initial angular velocity (yaw), rad/s

% Simulation Parameters
P.t_start = 0.0;  % Start time of simulation
P.t_end = 50.0;   % End time of simulation
P.Ts = 0.01;      % sample time for simulation
P.t_plot = 0.15;   % the plotting and animation

% MPC
t_settle = 5;
P.steps = 10; % match this with cvxgen
P.ts = t_settle / P.steps;
clear t_settle

% P.A = [zeros(6),eye(6);[zeros(2,3),[0 -P.g 0;P.g 0 0],-P.mu/P.M*eye(2),zeros(2,4)];zeros(4,12)];P.A(3,9) = -1;
P.A = [zeros(6),eye(6);zeros(3),-skew([0;0;9.81]),-P.mu/P.M*eye(3),zeros(3);zeros(3,12)];P.A(3,9) = -1;
P.B = [zeros(8,4);diag([-1/P.M;1/P.Jx;1/P.Jx;1/P.Jz])]*P.MM;
P.C = eye(length(P.A));
P.D = zeros(length(P.C(:,1)),length(P.B(1,:)));

sys = ss(P.A,P.B,P.C,P.D);
sys_d = c2d(sys,P.ts);
[P.Ad,P.Bd,P.Cd,P.Dd] = ssdata(sys_d);
clear sys sys_d