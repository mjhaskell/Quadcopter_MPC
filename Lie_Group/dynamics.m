function [sys,x0,str,ts,simStateCompliance] = dynamics(t,x,u,flag,P)
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

sizes.NumContStates  = 18;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 18;
sizes.NumInputs      = 4;
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
x0  = [P.pn0;P.pe0;P.h0;1;0;0;0;1;0;0;0;1;P.u0;P.v0;P.w0;P.p0;P.q0;P.r0];

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
  p         = x(1:3);
  Rb2v      = reshape(x(4:12),3,3);
  v         = x(13:15);
  w         = x(16:18);
  
  F_T       = P.MM*u_in;
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
    g  = [0;0;P.g]; % the gravity vector is well known and so we don't change it.
%     d  = P.d;
  end
  
  % Rotation Matrices
%   Rb2v = rot(psi,theta,phi); % rotate from vehicle frame to body frame
  
  % define system dynamics xdot=f(x,u)
  pd = Rb2v*v;% - Rb2v*skew([u,v,w])*PHI;
  pd(3) = -1 * pd(3);
  
%   attd = [1 sin(phi)*tan(theta) cos(phi)*tan(theta);0 cos(phi) -sin(phi);...
%           0 sin(phi)/cos(theta) cos(phi)/cos(theta)] * [p;q;r];

%   attd = abs(vex(logm(Rb2v * skew([p;q;r]))));
  Rd = Rb2v*skew(w);
  Rd = Rd(:);

%   phid   = p;
%   thetad = q;
%   psid   = r;

  vd = skew(v)*w - F/(4*mp+mc) + Rb2v'*g - mu/(4*mp+mc)*v;
  
%   ud = r*v-q*w - g*sin(theta) - mu/(4*mp+mc)*u;
%   vd = p*w-r*u + g*cos(theta)*sin(phi) - mu/(4*mp+mc)*v;
%   wd = q*u-p*v + g*cos(theta)*cos(phi) - F/(4*mp+mc) - mu/(4*mp+mc)*w;

%   ud = r*v-q*w + g*Rb2v(1,3) - mu/(4*mp+mc)*u;
%   vd = p*w-r*u + g*Rb2v(2,3) - mu/(4*mp+mc)*v;
%   wd = q*u-p*v + g*Rb2v(3,3) - F/(4*mp+mc) - mu/(4*mp+mc)*w;

  J = diag([Jx,Jy,Jz]);
  wd = inv(J)*(-skew(w)*J*w + T);

%   pd = (Jy-Jz)/Jx * q*r + T_phi/Jx;
%   qd = (Jz-Jx)/Jy * p*r + T_theta/Jy;
%   rd = (Jx-Jy)/Jz * p*q + T_psi/Jz;
    
sys = [pd;Rd;vd;wd];

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
%     p_m       = x(1:3);
%     R_m       = reshape(x(4:12),3,3);
%     PHI       = vex(logm(R_m));
%     v_m       = x(13:15);
%     w_m       = x(16:18);
    
    % add Gaussian noise to the outputs
%     z_m = z;% + 0.01*randn;
%     theta_m = theta;% + 0.001*randn;
% sys = [p_m;PHI;v_m;w_m];
sys = x;


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
