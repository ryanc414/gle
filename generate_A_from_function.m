%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Samples a function f(w) at discrete steps of the sample_rate between w_min
% and w_max, and uses this to generate an approximate mapping of delta-like 
% peaks of width dw. From here, an A matrix corresponding to this power-
% spectrum is generated for use in GLE simulations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function A = generate_A_from_function(f, dw, w_min, w_max, sample_rate)
    % First, sample function between limits at dw.
    [freq_bins, w] = sample_function(f, sample_rate, w_min, w_max);

    w_plot = linspace(w_min, w_max, 500);

    % Re-scale the frequency bins to give correct height deltas.
    freq_bins = scale_height(freq_bins, w, dw, f, w_plot);
    
    % Generate an A matrix using these freq bins
    A = generate_A_from_frequencies(w, dw, freq_bins, 1); 
end


function [freq_bins, w] = sample_function(f, dw, w_min, w_max)
    % Sample function f(w) at in range w_min - w_max at each dw.
    w = w_min:dw:w_max;
    freq_bins = f(w);  
end


function freq_bins = scale_height(freq_bins, w, dw, f, w_plot)
    % Scale the height of each peak
    freq_bins = freq_bins ./ delta_like_peak(w, w, dw, 1);

    f_fit = fitted_function(freq_bins, w, dw, w_plot);
    factor = least_squares_fit(f_fit, f(w_plot));
    freq_bins = freq_bins * factor;
end


function y = delta_like_peak(w, w_0, dw, gamma)
    y = 2 * sqrt(2 / pi) * gamma * dw * (dw ^ 2 + w_0 .^ 2 + w .^ 2) ./ ...
        ((dw ^2 + (w - w_0) .^ 2) .* (dw ^2 + (w + w_0) .^ 2));
end


function f = fitted_function(freq_bins, w_list, dw, w_plot)
    f = 0;

    for i = 1:length(w_list)
        f = f + delta_like_peak(w_plot, w_list(i), dw, freq_bins(i));
    end
end


function factor = least_squares_fit(f_fit, f)
    residual = @(x) x * f_fit - f;
    sum_of_squares = @(x) sum(residual(x) .^ 2);
    factor = fminsearch(sum_of_squares, 1);
end

