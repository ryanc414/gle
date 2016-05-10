%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots a particle trajectory for unfiltered white noise.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Physical constants
k_B = 0.8314;  % Boltzmann constant in A^2 amu ps^-2 K^-1

% Specify simulation parameters here:
N = 1E6;  % number of steps to simulate
mass = 20;  % particle mass / amu
T = 298.0;  % temperature / K

% Specify A matrix here to control GLE behaviour:
gamma = 1;
A = gamma;

% Specify initial conditions:
initial_position = [0, 0];  % initial position in x-y plane
initial_momentum = zeros(2, length(A));  

% Calculate the rest of the params needed by the GLE solver:
params = calculate_sim_params(k_B, N, T, mass, A);

% Manually specify other parameters here:
params.sample_time = (2 * pi) / 1000.0;
params.stop_time = N * params.sample_time;

% Now run the simulation:
tic;
[r, p, t] = sim_gle_2d(params, initial_position, initial_momentum);
toc;

% Finally, plot position data. 
figure;
plot(r(:, 1), r(:, 2));
xlabel('x / $\rm{\AA}$', 'interpreter', 'LaTex');
ylabel('y / $\rm{\AA}$', 'interpreter', 'LaTex');
axis equal;

% Save figure to disk as a .png
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0, 0, 10, 8.5];
print('example_trajectory', '-dpng');

