%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate an A matrix for a comb of delta-like peaks at frequencies w_list,
% each with width dw and height proportional to each of gamma_list.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function A = generate_A_from_frequencies_multiple_gamma(...
        w_list, dw, gamma_list, tau)
    % Determine the size of A and allocate a matrix of zeros.
    n = 2 * length(w_list) + 1;
    A = zeros(n, n);

    % Now fill out the rest of the matrix. 
    for i = 2:n
        A = fill_in_values(A, i, gamma_list(floor(i / 2)), tau, dw, w_list);
    end
end


function A = fill_in_values(A, i, gamma, tau, dw, w_list)
    % Fills out the i'th row, collumn and diagonal elements of A.

    % First row
    A(1, i) = sqrt(gamma / tau);

    % First collumn
    A(i, 1) = -sqrt(gamma / tau);

    % Populate the rest of the main diagonal with dw
    A(i, i) = dw;

    if mod(i, 2) == 0 
        % Populate the next diagonal along with the frequencies contained
        % in w_list.
        A(i + 1, i) = w_list(i / 2);
    
        % Finally, populate the preceding diagonal with the negative of the 
        % frequencies contained in w_list.
        A(i, i + 1) = - w_list(i / 2);
    end
end    

