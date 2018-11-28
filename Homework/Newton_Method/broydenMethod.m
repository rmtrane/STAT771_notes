function [x, err, iteration] = broydenMethod(f, jacobianInv, x0, tolerence, MaxIteration)
%
% Broyden's method. An inexact Newton's method that compute Jacobian by
% magic. (The idea behind Broyden's method is to compute the whole 
% Jacobian only at the first iteration and to do rank-one updates at other 
% iterations.
%
%
% Input:
%   f - input funtion
%   jacobianInv - initial Jacobian inverse
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
% Reference: https://en.wikipedia.org/wiki/Broyden's_method
%
%% handling inputs
if nargin == 3
    tolerence = 1e-10;
    maxIteration = 100;
elseif nargin == 4
    maxIteration = 100;
elseif nargin ~= 5
    error('broydenMethod: invalid input parameters');
end
%% main part
iteration = 0;
x = x0;
err = norm(f(x));
r = f(x);
while (err > tolerence) && (iteration < maxIteration)
    iteration = iteration + 1;
    s = -jacobianInv * r; % x_c - x_-
    x = x + s;
    r_ = r; % last time's residue
    r = f(x);
    jacobianInv = jacobianInv + (s - jacobianInv * (r - r_)) * s' * ...
        jacobianInv / (s' * jacobianInv * (r - r_));
    err = norm(r);
end

end