/* Produced by CVXGEN, 2018-06-29 19:19:59 -0400.  */
/* CVXGEN is Copyright (C) 2006-2017 Jacob Mattingley, jem@cvxgen.com. */
/* The code in this file is Copyright (C) 2006-2017 Jacob Mattingley. */
/* CVXGEN, or solvers produced by CVXGEN, cannot be used for commercial */
/* applications without prior written permission from Jacob Mattingley. */

/* Filename: solver.h. */
/* Description: Header file with relevant definitions. */
#ifndef SOLVER_H
#define SOLVER_H
/* Uncomment the next line to remove all library dependencies. */
/*#define ZERO_LIBRARY_MODE */
#ifdef MATLAB_MEX_FILE
/* Matlab functions. MATLAB_MEX_FILE will be defined by the mex compiler. */
/* If you are not using the mex compiler, this functionality will not intrude, */
/* as it will be completely disabled at compile-time. */
#include "mex.h"
#else
#ifndef ZERO_LIBRARY_MODE
#include <stdio.h>
#endif
#endif
/* Space must be allocated somewhere (testsolver.c, csolve.c or your own */
/* program) for the global variables vars, params, work and settings. */
/* At the bottom of this file, they are externed. */
#ifndef ZERO_LIBRARY_MODE
#include <math.h>
#define pm(A, m, n) printmatrix(#A, A, m, n, 1)
#endif
typedef struct Params_t {
  double x_0[12];
  double x_des_0[12];
  double Wy[12];
  double u_des_0[4];
  double Wu[4];
  double x_des_1[12];
  double u_des_1[4];
  double x_des_2[12];
  double u_des_2[4];
  double x_des_3[12];
  double u_des_3[4];
  double x_des_4[12];
  double u_des_4[4];
  double x_des_5[12];
  double u_des_5[4];
  double x_des_6[12];
  double u_des_6[4];
  double x_des_7[12];
  double u_des_7[4];
  double x_des_8[12];
  double u_des_8[4];
  double x_des_9[12];
  double u_des_9[4];
  double x_des_10[12];
  double u_des_10[4];
  double x_des_11[12];
  double Wy_final[12];
  double A[144];
  double B[48];
  double u_min[1];
  double u_max[1];
  double *x[1];
  double *x_des[12];
  double *u_des[11];
} Params;
typedef struct Vars_t {
  double *u_0; /* 4 rows. */
  double *x_1; /* 12 rows. */
  double *u_1; /* 4 rows. */
  double *x_2; /* 12 rows. */
  double *u_2; /* 4 rows. */
  double *x_3; /* 12 rows. */
  double *u_3; /* 4 rows. */
  double *x_4; /* 12 rows. */
  double *u_4; /* 4 rows. */
  double *x_5; /* 12 rows. */
  double *u_5; /* 4 rows. */
  double *x_6; /* 12 rows. */
  double *u_6; /* 4 rows. */
  double *x_7; /* 12 rows. */
  double *u_7; /* 4 rows. */
  double *x_8; /* 12 rows. */
  double *u_8; /* 4 rows. */
  double *x_9; /* 12 rows. */
  double *u_9; /* 4 rows. */
  double *x_10; /* 12 rows. */
  double *u_10; /* 4 rows. */
  double *x_11; /* 12 rows. */
  double *u[11];
  double *x[12];
} Vars;
typedef struct Workspace_t {
  double h[88];
  double s_inv[88];
  double s_inv_z[88];
  double b[132];
  double q[176];
  double rhs[484];
  double x[484];
  double *s;
  double *z;
  double *y;
  double lhs_aff[484];
  double lhs_cc[484];
  double buffer[484];
  double buffer2[484];
  double KKT[2628];
  double L[4352];
  double d[484];
  double v[484];
  double d_inv[484];
  double gap;
  double optval;
  double ineq_resid_squared;
  double eq_resid_squared;
  double block_33[1];
  /* Pre-op symbols. */
  double quad_851572719616[1];
  double quad_191419691008[1];
  double quad_769265315840[1];
  double quad_394743967744[1];
  double quad_771568988160[1];
  double quad_437546663936[1];
  double quad_939734863872[1];
  double quad_194884124672[1];
  double quad_734055882752[1];
  double quad_847357476864[1];
  double quad_955949862912[1];
  double quad_13349224448[1];
  double quad_103084154880[1];
  double quad_372001710080[1];
  double quad_411422265344[1];
  double quad_161101369344[1];
  double quad_631712628736[1];
  double quad_652743294976[1];
  double quad_97738092544[1];
  double quad_319781425152[1];
  double quad_755044708352[1];
  double quad_406487670784[1];
  double quad_54433812480[1];
  int converged;
} Workspace;
typedef struct Settings_t {
  double resid_tol;
  double eps;
  int max_iters;
  int refine_steps;
  int better_start;
  /* Better start obviates the need for s_init and z_init. */
  double s_init;
  double z_init;
  int verbose;
  /* Show extra details of the iterative refinement steps. */
  int verbose_refinement;
  int debug;
  /* For regularization. Minimum value of abs(D_ii) in the kkt D factor. */
  double kkt_reg;
} Settings;
extern Vars vars;
extern Params params;
extern Workspace work;
extern Settings settings;
/* Function definitions in ldl.c: */
void ldl_solve(double *target, double *var);
void ldl_factor(void);
double check_factorization(void);
void matrix_multiply(double *result, double *source);
double check_residual(double *target, double *multiplicand);
void fill_KKT(void);

/* Function definitions in matrix_support.c: */
void multbymA(double *lhs, double *rhs);
void multbymAT(double *lhs, double *rhs);
void multbymG(double *lhs, double *rhs);
void multbymGT(double *lhs, double *rhs);
void multbyP(double *lhs, double *rhs);
void fillq(void);
void fillh(void);
void fillb(void);
void pre_ops(void);

/* Function definitions in solver.c: */
double eval_gap(void);
void set_defaults(void);
void setup_pointers(void);
void setup_indexed_params(void);
void setup_indexed_optvars(void);
void setup_indexing(void);
void set_start(void);
double eval_objv(void);
void fillrhs_aff(void);
void fillrhs_cc(void);
void refine(double *target, double *var);
double calc_ineq_resid_squared(void);
double calc_eq_resid_squared(void);
void better_start(void);
void fillrhs_start(void);
long solve(void);

/* Function definitions in testsolver.c: */
int main(int argc, char **argv);
void load_default_data(void);

/* Function definitions in util.c: */
void tic(void);
float toc(void);
float tocq(void);
void printmatrix(char *name, double *A, int m, int n, int sparse);
double unif(double lower, double upper);
float ran1(long*idum, int reset);
float randn_internal(long *idum, int reset);
double randn(void);
void reset_rand(void);

#endif
