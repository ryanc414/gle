%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interface between Simulink model and Matlab code for n-dimensional           
% trajectories. Shuffles RNG and returns position, momentum and     
% time data as arrays.                                              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [r, p, t] = sim_gle(params, r_init, p_init, n)
    % Simulate the GLE using calculated parameters. Return position, momentum
    % and time as arrays.
    sim_name = 'gle.slx';  % Name of the Simulink model on disk.
    seed_limit = 100000;  % Upper limit for integer seed values. 

    % Seed the rng.
    rng('shuffle');

    for i = 1:n
        params.seed_values = randi(seed_limit, params.momenta_dimension, 1);
        params = set_initial_conditions(params, r_init, p_init, i);
        [r(:, i), p(:, i), t] = sim_single_direction(params, sim_name);
    end     
end


function [r, p, t] = sim_single_direction(params, sim_name)
    % Simulate the GLE for a single spatial direction.
    assignin('base', 'params', params); 
    sim(sim_name);
    r = position.Data;
    p = momentum.Data;
    t = position.Time;
end


function params = set_initial_conditions(params, r_init, p_init, i)
    % Set the initial conditions for the simulation.
    params.r_init = r_init(i);
    params.p_init = p_init(i, :);
end

