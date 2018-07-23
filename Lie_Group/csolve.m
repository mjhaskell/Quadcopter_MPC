% csolve  Solves a custom quadratic program very rapidly.
%
% [vars, status] = csolve(params, settings)
%
% solves the convex optimization problem
%
%   minimize(quad_form(x_0 - x_des_0, Wy) + quad_form(u_0 - u_des_0, Wu) + quad_form(x_1 - x_des_1, Wy) + quad_form(u_1 - u_des_1, Wu) + quad_form(x_2 - x_des_2, Wy) + quad_form(u_2 - u_des_2, Wu) + quad_form(x_3 - x_des_3, Wy) + quad_form(u_3 - u_des_3, Wu) + quad_form(x_4 - x_des_4, Wy) + quad_form(u_4 - u_des_4, Wu) + quad_form(x_5 - x_des_5, Wy) + quad_form(u_5 - u_des_5, Wu) + quad_form(x_6 - x_des_6, Wy) + quad_form(u_6 - u_des_6, Wu) + quad_form(x_7 - x_des_7, Wy) + quad_form(u_7 - u_des_7, Wu) + quad_form(x_8 - x_des_8, Wy) + quad_form(u_8 - u_des_8, Wu) + quad_form(x_9 - x_des_9, Wy) + quad_form(u_9 - u_des_9, Wu) + quad_form(x_10 - x_des_10, Wy) + quad_form(u_10 - u_des_10, Wu) + quad_form(x_des_11 - x_11, Wy_final))
%   subject to
%     x_1 == A*x_0 + B*(u_0 - u_des_0)
%     x_2 == A*x_1 + B*(u_1 - u_des_1)
%     x_3 == A*x_2 + B*(u_2 - u_des_2)
%     x_4 == A*x_3 + B*(u_3 - u_des_3)
%     x_5 == A*x_4 + B*(u_4 - u_des_4)
%     x_6 == A*x_5 + B*(u_5 - u_des_5)
%     x_7 == A*x_6 + B*(u_6 - u_des_6)
%     x_8 == A*x_7 + B*(u_7 - u_des_7)
%     x_9 == A*x_8 + B*(u_8 - u_des_8)
%     x_10 == A*x_9 + B*(u_9 - u_des_9)
%     x_11 == A*x_10 + B*(u_10 - u_des_10)
%     u_min <= u_0
%     u_min <= u_1
%     u_min <= u_2
%     u_min <= u_3
%     u_min <= u_4
%     u_min <= u_5
%     u_min <= u_6
%     u_min <= u_7
%     u_min <= u_8
%     u_min <= u_9
%     u_min <= u_10
%     u_0 <= u_max
%     u_1 <= u_max
%     u_2 <= u_max
%     u_3 <= u_max
%     u_4 <= u_max
%     u_5 <= u_max
%     u_6 <= u_max
%     u_7 <= u_max
%     u_8 <= u_max
%     u_9 <= u_max
%     u_10 <= u_max
%
% with variables
%      u_0   4 x 1
%      u_1   4 x 1
%      u_2   4 x 1
%      u_3   4 x 1
%      u_4   4 x 1
%      u_5   4 x 1
%      u_6   4 x 1
%      u_7   4 x 1
%      u_8   4 x 1
%      u_9   4 x 1
%     u_10   4 x 1
%      x_1  12 x 1
%      x_2  12 x 1
%      x_3  12 x 1
%      x_4  12 x 1
%      x_5  12 x 1
%      x_6  12 x 1
%      x_7  12 x 1
%      x_8  12 x 1
%      x_9  12 x 1
%     x_10  12 x 1
%     x_11  12 x 1
%
% and parameters
%        A  12 x 12
%        B  12 x 4
%       Wu   4 x 4    PSD, diagonal
%       Wy  12 x 12   PSD, diagonal
% Wy_final  12 x 12   PSD, diagonal
%  u_des_0   4 x 1
%  u_des_1   4 x 1
%  u_des_2   4 x 1
%  u_des_3   4 x 1
%  u_des_4   4 x 1
%  u_des_5   4 x 1
%  u_des_6   4 x 1
%  u_des_7   4 x 1
%  u_des_8   4 x 1
%  u_des_9   4 x 1
% u_des_10   4 x 1
%    u_max   1 x 1    positive
%    u_min   1 x 1    positive
%      x_0  12 x 1
%  x_des_0  12 x 1
%  x_des_1  12 x 1
%  x_des_2  12 x 1
%  x_des_3  12 x 1
%  x_des_4  12 x 1
%  x_des_5  12 x 1
%  x_des_6  12 x 1
%  x_des_7  12 x 1
%  x_des_8  12 x 1
%  x_des_9  12 x 1
% x_des_10  12 x 1
% x_des_11  12 x 1
%
% Note:
%   - Check status.converged, which will be 1 if optimization succeeded.
%   - You don't have to specify settings if you don't want to.
%   - To hide output, use settings.verbose = 0.
%   - To change iterations, use settings.max_iters = 20.
%   - You may wish to compare with cvxsolve to check the solver is correct.
%
% Specify params.A, ..., params.x_des_11, then run
%   [vars, status] = csolve(params, settings)
% Produced by CVXGEN, 2018-06-29 19:19:42 -0400.
% CVXGEN is Copyright (C) 2006-2017 Jacob Mattingley, jem@cvxgen.com.
% The code in this file is Copyright (C) 2006-2017 Jacob Mattingley.
% CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial
% applications without prior written permission from Jacob Mattingley.

% Filename: csolve.m.
% Description: Help file for the Matlab solver interface.
