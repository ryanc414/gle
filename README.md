Generalised Langevin Equation - Numerical Solving Framework
============================================================

Simulation framework for GLE dynamics, written in Matlab and Simulink. Solves for 2D motion on a surface.

Plot Trajectories
-----------------

Use plot_*_trajectory.m to plot a trajectory using the specified coloured noise filter. Modify physical parameters such as mass, temperature, initial conditions etc. within these files, or modify the A matrix to use a different filter type!

Plot ISFs
---------

Use plot_average_isf.m to plot an ISF, averaged over a number of trajectories (default 10). Modify parameters (including the A matrix) inside this file as needed. WARNING: the resmaple_data.m function used to reduce the memory needed to plot an ISF is incompatible with Matlab R2014b or earlier - either upgrade to a later version or disable the resampling by commenting out line 44 of plot_average_isf.m. 

