function [sys,x0,str,ts,simStateCompliance] = error_dynamics(t,x,u,flag,P)
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(P);

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u,P);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes(P)

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 12;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 12;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [P.pn0;P.pe0;P.h0;P.phi0;P.theta0;P.psi0;P.u0;P.v0;P.w0;P.p0;P.q0;P.r0];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u_in,P)
%   pn        = x(1);
%   pe        = x(2);
%   h         = x(3);
  p         = x(1:3);
  
%   phi       = x(4);
%   theta     = x(5);
%   psi       = x(6);
  PHI       = [x(4);x(5);x(6)];
  Rb2v      = expm(skew(PHI));
  
  v         = x(7:9);
%   u         = x(7);
%   v         = x(8);
%   w         = x(9);
 
  w         = x(10:12);
%   p         = x(10);
%   q         = x(11);
%   r         = x(12);
  
  F_T       = P.MM*u_in;
%   F         = F_T(1);
%   T_phi     = F_T(2);
%   T_theta   = F_T(3);
%   T_psi     = F_T(4);
  F         = [0;0;F_T(1)];
  T         = F_T(2:4);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % The parameters for any physical system are never known exactly.  Feedback
  % systems need to be designed to be robust to this uncertainty.  In the simulation
  % we model uncertainty by changing the physical parameters by a uniform random variable
  % that represents alpha*100 % of the parameter, i.e., alpha = 0.2, means that the parameter
  % may change by up to 20%.  A different parameter value is chosen every time the simulation
  % is run.
  persistent mp
  persistent mc
  persistent Jx Jy Jz
  persistent g mu
%   persistent d
  if t==0
    alpha1 = 0.0;  % uncertainty parameter
    alpha2 = 0.0;  % uncertainty parameter
    mp = P.mp * (1+2*alpha1*rand-alpha1);  % kg
    mc = P.mc * (1+2*alpha1*rand-alpha1);  % kg
    Jx = P.Jx * (1+2*alpha2*rand-alpha2); %
    Jy = Jx;
    Jz = P.Jz * (1+2*alpha2*rand-alpha2); %
    mu = P.mu * (1+2*alpha2*rand-alpha2); % 
    g  = P.g; % the gravity vector is well known and so we don't change it.
%     d  = P.d;
  end
  
  % Rotation Matrices
%   Rb2v = rot(psi,theta,phi); % rotate from vehicle frame to body frame
  
  % define system dynamics xdot=f(x,u)
%   posd = Rb2v*[u;v;w];% - Rb2v*skew([u,v,w])*PHI;
%   pnd = posd(1);
%   ped = posd(2);
%   hd  = -posd(3);
  pd = Rb2v * v;
  pd(3) = -pd(3);

%   attd = [1 sin(phi)*tan(theta) cos(phi)*tan(theta);0 cos(phi) -sin(phi);...
%           0 sin(phi)/cos(theta) cos(phi)/cos(theta)] * [p;q;r];

%   attd = abs(vex(logm(Rb2v * skew([p;q;r]))));
%   attd   = Rb2v*[p;q;r];
%   phid   = attd(1);
%   thetad = attd(2);
%   psid   = attd(3);
  PHId = Rb2v*w;

%   phid   = p;
%   thetad = q;
%   psid   = r;

%   veld = skew([u,v,w])*[p;q;r] - [0;0;F/(4*mp+mc)] + Rb2v'*g;
  
%   ud = r*v-q*w - g*sin(theta) - mu/(4*mp+mc)*u;
%   vd = p*w-r*u + g*cos(theta)*sin(phi) - mu/(4*mp+mc)*v;
%   wd = q*u-p*v + g*cos(theta)*cos(phi) - F/(4*mp+mc) - mu/(4*mp+mc)*w;

%   ud = r*v-q*w + g*Rb2v(3,1) - mu/(4*mp+mc)*u;
%   vd = p*w-r*u + g*Rb2v(3,2) - mu/(4*mp+mc)*v;
%   wd = q*u-p*v + g*Rb2v(3,3) - F/(4*mp+mc) - mu/(4*mp+mc)*w;
  vd = skew(v)*w + Rb2v*[0;0;g] - F/(4*mp+mc) - mu*v;

%   pd = (Jy-Jz)/Jx * q*r + T_phi/Jx;
%   qd = (Jz-Jx)/Jy * p*r + T_theta/Jy;
%   rd = (Jx-Jy)/Jz * p*q + T_psi/Jz;
  J = diag([Jx;Jy,Jz]);
  wd = inv(J)*(-skew(w)*J*w+T);

% sys = [pnd;ped;hd;phid;thetad;psid;ud;vd;wd;pd;qd;rd];
sys = [pd;PHId;vd;wd];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];

% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
%     pn_m       = x(1);
%     pe_m       = x(2);
%     h_m        = x(3);
%     theta_m    = x(5);
    % add Gaussian noise to the outputs
%     z_m = z;% + 0.01*randn;
%     theta_m = theta;% + 0.001*randn;
sys = x;
% sys = [zv_m; h_m; theta_m; x_lon; x_lat];


% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
