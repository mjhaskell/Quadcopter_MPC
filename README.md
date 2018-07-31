# Quadcopter_MPC
This repo has 2 functional MATLAB simulations of a quadcopter using an MPC controller. One simulation uses Euler angles (roll,pitch,yaw) to represent attitude while the other uses the Lie Group SO(3) representation. Both simulations have been tested and tuned (at least a decent amount) to fly an hourglass/figure-8 waypoint path. It can be seen that, since the Lie Group representation works on the manifold when controlling heading, it always spins the shortest distance to get to the desired heading and has no angle wrapping issues.
## Licensing
This repo uses code gererated from CVXGEN with an academic use only license. CVXGEN is an online code generator for convex optimization. It is used to solve the optimization in the MPC controller.
## Dependencies
I used MATLAB 2018a. To open the simulink files, you must be using MATLAB 2018a or newer.

This repo uses some of the functions from Peter Corke's Robotics Toolbox for MATLAB. It is a pretty simple installation. After downloading the toolbox, open MATLAB, navigate to the directory with the toolbox download, and double-click the toolbox download inside of MATLAB. This with automatically set it up for you. Here is a link to the download: http://petercorke.com/wordpress/toolboxes/robotics-toolbox#Downloading_the_Toolbox
## How to Use
This repo contains 2 directories: Lie_Group and Euler_Angles. Both of these directories contain similar code files and 1 simulink (.slx) file each. The Simulink can be opened within MATLAB and all you should have to do is click run to see the simulation. The reference commands are easily adjustable to fly different paths if desired.
## Code Explained
### control.m
This function is called in Simulink in the controller block. It takes in the reference commands, current states, and curret time then uses MPC to calculate the desired control effort. The output of this function is 4 throttle commands, 1 for each motor of the quadcopter. This function calls getA() to update the A state-space matrix at every time step. Note that the A of the current time step is not updated as MPC predicts into the future as this is much more computationally expensive.
### dynamics.m
This s-function models the plant in Simulink. The inputs are the 4 motor commands and the outputs are all of the current states used in the feedback loop and in the animation. Note that the Lie Group dynamics function has 18 states and outputs rather than 12. This is because all 9 parameters of the SO(3) rotation matrix are used as states. This rotation matrix is shaped into a column vector with 9 elements and is reshaped inside of the animation and controller back into a 3x3 rotation matrix. This was done to model the Lie Group kinematics more accurately.
### animation.m
This function animates the quadcopter simulation. The inputs are the current position and attitude of the quadcopter. Handles are used with each plotting object so as to not replot but rather update the objects information. This allows the animation to run faster.
### getA.m
This function is used by the controller to update the A state-space matrix based of the current states. Inside the code are 3 sections which can be used, 2 of which should always be commented out. The 1st section allows you to use a static A matrix based off all true equilibrium values. The 2nd uses the current R as equilibrium and works the best for this simulation. The last section uses the current states (or trajectory states when following a trajectory) as equilibrium. The function returns the updated A matrix.
### param.m
This is a file containing a struct of parameters. It contains the properties needed for modeling the quadrotor, the initial conditions for the simulation, and the equilibrium values used for control. This function is called automatically when the play/run button is clicked in Simulink.
### All other files
Any file not previously explained will not be explained due to either simplicity or because it was auto-generated code from CVXGEN.
