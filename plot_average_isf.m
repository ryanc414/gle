%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the average ISF, averaged over N_runs trajectories.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Number of spatial dimensions to simulate.
D = 2;

N_runs = 10;
dk = (1 / sqrt(2)) * [1, 1];  % Specify dk as a 2D vector.

% Define fundamental constants
k_B = 0.8314;  % Boltzmann constant in A^2 amu ps^-2 K^-1

% Simulation Parameters:
N_steps = 1E6; % Integer number of steps to integrate over
T = 298.0; % Temperature / K
mass = 20; % particle mass / amu

% A coefficient matrix:
gamma = 1;
tau = 10;
A = [0, - sqrt(gamma / tau); ...
     sqrt(gamma / tau), 1 / tau];

% Specify initial conditions.
r_init = zeros(D, 1);
p_init = zeros(D, length(A));  

% Calculate the rest of the simulation parameters based on these.
params = calculate_sim_params(k_B, N_steps, T, mass, A);

% Manually set the sample time
params.sample_time = (2 * pi) / 1000.0;
params.stop_time = N_steps * params.sample_time;

% Calcualate the average ISF of N runs
tic;
[I, t] = calculate_average_isf(N_runs, params, dk, r_init, p_init);
toc;

% Resample the data before saving/plotting:
% WARNING: NOT COMPATIBLE WITH MATLAB 2014b OR EARLIER.
sample_factor = 100;
[t, I] = resample_data(t, I, sample_factor);

% Now save the results to disk:
save('isf_data', 'I', 't');

% Plot the data:
figure;
semilogx(t, I);
xlabel('t / ps');
ylabel('Normalised ISF');

% Save the figure to disk with desired size
fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0, 0, 10, 8.5];
print('isf', '-dpng');

