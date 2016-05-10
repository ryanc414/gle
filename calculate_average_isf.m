%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate ISFs for multiple runs (same parameters, different random seeds).
% Return the average ISF. The purpose of this is to remove noisy parts.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [isf, t] = calculate_average_isf(N, params, dk, r_init, p_init)
    % Run N simulations and sum the FFTs of the scattering functions. 
    isf = sum_isf(N, params, dk, r_init, p_init);
    
    % Normalise the ISF to unity.
    isf = normalise(isf);

    % Finally, return the timebase as an array.
    % Take decimation into account for the time-step.
    step = params.sample_time * params.decimation;
    t = -params.stop_time:step:params.stop_time;
end


function sum_isf = sum_isf(N, params, dk, r_init, p_init) 
    % Sum the FFTs of the scattering functions of N simulations.
    sum_isf = 0;

    % Run simulations in parallel to reduce execution time.
    parfor i = 1:N
        % Run simulation to get position data.
        r = sim_position(params, r_init, p_init);

        % Calculate the scattered amplitudes for our value of dk.
        A = scattered_amplitudes(dk, r);

        % Calculate the autocorrelation of A.
        A = xcorr(A);

        % Finally, add to the running total ISF.
        sum_isf = sum_isf + A;
    end
end


function r = sim_position(params, r_init, p_init)
    % Simulate using params, return position data and the last position and
    % momenta.
    [r, p, t] = sim_gle_2d(params, r_init, p_init);
end


function A = scattered_amplitudes(delta_k, r)
    % Calculate the scattering amplitude for a given delta_k vector
    A = exp(-1i * (delta_k * r.'));
end


function I = normalise(I)
    % Normalise the ISF to unity
    I = I / max(I);
end

