%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Resample input data logarithmically in x, to save disk space.
% WARNING: INCOMPATIBLE WITH MATLAB R2014b OR EARLIER.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [x, y] = resample_data(x, y, f)
    start_point = floor(length(x) / 2 + 2);
    x = x(start_point:end);  % cut to positive x only
    x = log10(x);  % take log.
    
    y = y(start_point:end);  % cut y data corresponding to x.
    y = real(y);  % only consider real y.
    
    % Now, resample data according to factor f.
    [y, x] = resample(y, x, f);
    
    % Remove first 10 data points as the resampling distorts them. 
    cutoff_first = 10;
    x = x(cutoff_first:end);
    y = y(cutoff_first:end);

    % Undo logarithm to return x data in same basis it was given in.
    x = 10 .^ x;
end

