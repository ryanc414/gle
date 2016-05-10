%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the simulation parameters based on physical inputs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function params = calculate_sim_params(k_B, N, T, mass, A);
    % Calculate the parameters needed by the Simulnk GLE solver 
    params.A = A;
    params.mass = mass;
    params.momenta_dimension = length(A);
    params.sample_time = calculate_sample_time(A);
    params.B = calculate_B(A, mass, k_B, T);
    params.psd = ones(1, params.momenta_dimension);
    params.stop_time = (N - 1) * params.sample_time;
    
    % Set defaults for data output (output everything).
    params.decimation = 1;
    params.last_position = inf;
    params.last_momenta = inf;
end


function t0 = calculate_sample_time(A)
    % Calculate the sample time based on fastest system dynamics.
    sample_factor  = (2 * pi) / 1000;
    t0 = sample_factor / max(A(:));
end


function B = calculate_B(A, m, k_B, T)
    % Calculate the B matrix coefficients.
    B = real(sqrtm(m * k_B * T * (A + A.')));
end

