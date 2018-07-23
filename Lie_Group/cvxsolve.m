% Produced by CVXGEN, 2018-06-29 19:19:42 -0400.
% CVXGEN is Copyright (C) 2006-2017 Jacob Mattingley, jem@cvxgen.com.
% The code in this file is Copyright (C) 2006-2017 Jacob Mattingley.
% CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial
% applications without prior written permission from Jacob Mattingley.

% Filename: cvxsolve.m.
% Description: Solution file, via cvx, for use with sample.m.
function [vars, status] = cvxsolve(params, settings)
A = params.A;
B = params.B;
Wu = params.Wu;
Wy = params.Wy;
Wy_final = params.Wy_final;
u_des_0 = params.u_des_0;
if isfield(params, 'u_des_1')
  u_des_1 = params.u_des_1;
elseif isfield(params, 'u_des')
  u_des_1 = params.u_des{1};
else
  error 'could not find u_des_1'
end
if isfield(params, 'u_des_2')
  u_des_2 = params.u_des_2;
elseif isfield(params, 'u_des')
  u_des_2 = params.u_des{2};
else
  error 'could not find u_des_2'
end
if isfield(params, 'u_des_3')
  u_des_3 = params.u_des_3;
elseif isfield(params, 'u_des')
  u_des_3 = params.u_des{3};
else
  error 'could not find u_des_3'
end
if isfield(params, 'u_des_4')
  u_des_4 = params.u_des_4;
elseif isfield(params, 'u_des')
  u_des_4 = params.u_des{4};
else
  error 'could not find u_des_4'
end
if isfield(params, 'u_des_5')
  u_des_5 = params.u_des_5;
elseif isfield(params, 'u_des')
  u_des_5 = params.u_des{5};
else
  error 'could not find u_des_5'
end
if isfield(params, 'u_des_6')
  u_des_6 = params.u_des_6;
elseif isfield(params, 'u_des')
  u_des_6 = params.u_des{6};
else
  error 'could not find u_des_6'
end
if isfield(params, 'u_des_7')
  u_des_7 = params.u_des_7;
elseif isfield(params, 'u_des')
  u_des_7 = params.u_des{7};
else
  error 'could not find u_des_7'
end
if isfield(params, 'u_des_8')
  u_des_8 = params.u_des_8;
elseif isfield(params, 'u_des')
  u_des_8 = params.u_des{8};
else
  error 'could not find u_des_8'
end
if isfield(params, 'u_des_9')
  u_des_9 = params.u_des_9;
elseif isfield(params, 'u_des')
  u_des_9 = params.u_des{9};
else
  error 'could not find u_des_9'
end
if isfield(params, 'u_des_10')
  u_des_10 = params.u_des_10;
elseif isfield(params, 'u_des')
  u_des_10 = params.u_des{10};
else
  error 'could not find u_des_10'
end
u_max = params.u_max;
u_min = params.u_min;
x_0 = params.x_0;
x_des_0 = params.x_des_0;
if isfield(params, 'x_des_1')
  x_des_1 = params.x_des_1;
elseif isfield(params, 'x_des')
  x_des_1 = params.x_des{1};
else
  error 'could not find x_des_1'
end
if isfield(params, 'x_des_2')
  x_des_2 = params.x_des_2;
elseif isfield(params, 'x_des')
  x_des_2 = params.x_des{2};
else
  error 'could not find x_des_2'
end
if isfield(params, 'x_des_3')
  x_des_3 = params.x_des_3;
elseif isfield(params, 'x_des')
  x_des_3 = params.x_des{3};
else
  error 'could not find x_des_3'
end
if isfield(params, 'x_des_4')
  x_des_4 = params.x_des_4;
elseif isfield(params, 'x_des')
  x_des_4 = params.x_des{4};
else
  error 'could not find x_des_4'
end
if isfield(params, 'x_des_5')
  x_des_5 = params.x_des_5;
elseif isfield(params, 'x_des')
  x_des_5 = params.x_des{5};
else
  error 'could not find x_des_5'
end
if isfield(params, 'x_des_6')
  x_des_6 = params.x_des_6;
elseif isfield(params, 'x_des')
  x_des_6 = params.x_des{6};
else
  error 'could not find x_des_6'
end
if isfield(params, 'x_des_7')
  x_des_7 = params.x_des_7;
elseif isfield(params, 'x_des')
  x_des_7 = params.x_des{7};
else
  error 'could not find x_des_7'
end
if isfield(params, 'x_des_8')
  x_des_8 = params.x_des_8;
elseif isfield(params, 'x_des')
  x_des_8 = params.x_des{8};
else
  error 'could not find x_des_8'
end
if isfield(params, 'x_des_9')
  x_des_9 = params.x_des_9;
elseif isfield(params, 'x_des')
  x_des_9 = params.x_des{9};
else
  error 'could not find x_des_9'
end
if isfield(params, 'x_des_10')
  x_des_10 = params.x_des_10;
elseif isfield(params, 'x_des')
  x_des_10 = params.x_des{10};
else
  error 'could not find x_des_10'
end
if isfield(params, 'x_des_11')
  x_des_11 = params.x_des_11;
elseif isfield(params, 'x_des')
  x_des_11 = params.x_des{11};
else
  error 'could not find x_des_11'
end
cvx_begin
  % Caution: automatically generated by cvxgen. May be incorrect.
  variable u_0(4, 1);
  variable x_1(12, 1);
  variable u_1(4, 1);
  variable x_2(12, 1);
  variable u_2(4, 1);
  variable x_3(12, 1);
  variable u_3(4, 1);
  variable x_4(12, 1);
  variable u_4(4, 1);
  variable x_5(12, 1);
  variable u_5(4, 1);
  variable x_6(12, 1);
  variable u_6(4, 1);
  variable x_7(12, 1);
  variable u_7(4, 1);
  variable x_8(12, 1);
  variable u_8(4, 1);
  variable x_9(12, 1);
  variable u_9(4, 1);
  variable x_10(12, 1);
  variable u_10(4, 1);
  variable x_11(12, 1);

  minimize(quad_form(x_0 - x_des_0, Wy) + quad_form(u_0 - u_des_0, Wu) + quad_form(x_1 - x_des_1, Wy) + quad_form(u_1 - u_des_1, Wu) + quad_form(x_2 - x_des_2, Wy) + quad_form(u_2 - u_des_2, Wu) + quad_form(x_3 - x_des_3, Wy) + quad_form(u_3 - u_des_3, Wu) + quad_form(x_4 - x_des_4, Wy) + quad_form(u_4 - u_des_4, Wu) + quad_form(x_5 - x_des_5, Wy) + quad_form(u_5 - u_des_5, Wu) + quad_form(x_6 - x_des_6, Wy) + quad_form(u_6 - u_des_6, Wu) + quad_form(x_7 - x_des_7, Wy) + quad_form(u_7 - u_des_7, Wu) + quad_form(x_8 - x_des_8, Wy) + quad_form(u_8 - u_des_8, Wu) + quad_form(x_9 - x_des_9, Wy) + quad_form(u_9 - u_des_9, Wu) + quad_form(x_10 - x_des_10, Wy) + quad_form(u_10 - u_des_10, Wu) + quad_form(x_des_11 - x_11, Wy_final));
  subject to
    x_1 == A*x_0 + B*(u_0 - u_des_0);
    x_2 == A*x_1 + B*(u_1 - u_des_1);
    x_3 == A*x_2 + B*(u_2 - u_des_2);
    x_4 == A*x_3 + B*(u_3 - u_des_3);
    x_5 == A*x_4 + B*(u_4 - u_des_4);
    x_6 == A*x_5 + B*(u_5 - u_des_5);
    x_7 == A*x_6 + B*(u_6 - u_des_6);
    x_8 == A*x_7 + B*(u_7 - u_des_7);
    x_9 == A*x_8 + B*(u_8 - u_des_8);
    x_10 == A*x_9 + B*(u_9 - u_des_9);
    x_11 == A*x_10 + B*(u_10 - u_des_10);
    u_min <= u_0;
    u_min <= u_1;
    u_min <= u_2;
    u_min <= u_3;
    u_min <= u_4;
    u_min <= u_5;
    u_min <= u_6;
    u_min <= u_7;
    u_min <= u_8;
    u_min <= u_9;
    u_min <= u_10;
    u_0 <= u_max;
    u_1 <= u_max;
    u_2 <= u_max;
    u_3 <= u_max;
    u_4 <= u_max;
    u_5 <= u_max;
    u_6 <= u_max;
    u_7 <= u_max;
    u_8 <= u_max;
    u_9 <= u_max;
    u_10 <= u_max;
cvx_end
vars.u_0 = u_0;
vars.u_1 = u_1;
vars.u{1} = u_1;
vars.u_2 = u_2;
vars.u{2} = u_2;
vars.u_3 = u_3;
vars.u{3} = u_3;
vars.u_4 = u_4;
vars.u{4} = u_4;
vars.u_5 = u_5;
vars.u{5} = u_5;
vars.u_6 = u_6;
vars.u{6} = u_6;
vars.u_7 = u_7;
vars.u{7} = u_7;
vars.u_8 = u_8;
vars.u{8} = u_8;
vars.u_9 = u_9;
vars.u{9} = u_9;
vars.u_10 = u_10;
vars.u{10} = u_10;
vars.x_1 = x_1;
vars.x{1} = x_1;
vars.x_2 = x_2;
vars.x{2} = x_2;
vars.x_3 = x_3;
vars.x{3} = x_3;
vars.x_4 = x_4;
vars.x{4} = x_4;
vars.x_5 = x_5;
vars.x{5} = x_5;
vars.x_6 = x_6;
vars.x{6} = x_6;
vars.x_7 = x_7;
vars.x{7} = x_7;
vars.x_8 = x_8;
vars.x{8} = x_8;
vars.x_9 = x_9;
vars.x{9} = x_9;
vars.x_10 = x_10;
vars.x{10} = x_10;
vars.x_11 = x_11;
vars.x{11} = x_11;
status.cvx_status = cvx_status;
% Provide a drop-in replacement for csolve.
status.optval = cvx_optval;
status.converged = strcmp(cvx_status, 'Solved');