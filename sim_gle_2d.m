%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interface between Simulink model and Matlab code for 2D           
% trajectories. Shuffles RNG and returns position, momentum and     
% time data as arrays.                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [r, p, t] = sim_gle(params, r_init, p_init)
    % Simulate the GLE using calculated parameters. Return position, momentum
    % and time as arrays.
    sim_name = 'gle.slx';  % Name of the Simulink model on disk.
    seed_limit = 100000;  % Upper limit for integer seed values. 

    % Seed the rng.
    rng('shuffle');
    params.seed_values = randi(seed_limit, params.momenta_dimension, 1);

    % Now simulate the gle for x-direction.
    params.r_init = r_init(1);
    params.p_init = p_init(1, :);
    assignin('base', 'params', params); 
    sim(sim_name);
    r(:, 1) = position.Data;
    p(:, 1) = momentum.Data;

    % Re-seed RNG and apply initial conditions for y-direction
    params.seed_values = randi(seed_limit, params.momenta_dimension, 1);
    params.r_init = r_init(2);
    params.p_init = p_init(2, :);

    % Simulate the gle for y-direction.
    assignin('base', 'params', params); 
    sim(sim_name);
    r(:, 2) = position.Data;
    p(:, 2) = momentum.Data;
    t = position.Time;
end

