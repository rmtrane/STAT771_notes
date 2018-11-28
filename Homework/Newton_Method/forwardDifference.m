function [x, err, iteration] = forwardDifference(f, x0, tolerence, maxIteration)
%
% Forward difference method. An inexact Newton's method that computes
% the numerical approximation of Jacobian of input function.
%
% Input:
%   f - input funtion
%   x0 - inicial value
%   tolerence - tolerance
%   maxIteration - maximum number of iterations
%
% Output:
%   x - aproximation to root
%   err - error estimate
%   iteration - number of iterations
%
% Author: Li Ge
% Version: 1.0
% Date: Nov. 26, 2018
%
%% handling inputs
if nargin == 2
    tolerence = 1e-10;
    maxIteration = 100;
elseif nargin == 3
    maxIteration = 100;
elseif nargin ~= 4
    error('forwardDifference: invalid input parameters');
end
%% main part
iteration = 0;
x = x0;
err = norm(f(x));
d = length(x);
I = eye(d);
while (err > tolerence) && (iteration < maxIteration)
    iteration = iteration + 1;
    eps = 1e-8; % this is for calculating the jacobian,
                % approximately the sqrt(machine error).
                % the exact best epsilon is in proportion to this,
                % but varies with different input function
    for k = 1:d % this part is for calculating the approximate Jacobian
        J(:, k) = (f(x + eps * I(:, k)) - f(x)) / eps;
    end
    x = x - J \ f(x);
    err = norm(f(x));
end

end