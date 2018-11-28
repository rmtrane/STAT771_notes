function [x, err, iteration] = chordMethod(f, df, x0, tolerence, maxIteration, v)
%
% Chord's Method. An inexact Newton's method that only compute Jacobian 
% every v iterations.
%
% Input:
%   f - input funtion
%   df - input function's Jacobian
%   x0 - inicial value
%   tolerence - tolerance
%   maxIteration - maximum number of iterations
%   v - number of iterations with Jacobian
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
if nargin == 3
    tolerence = 1e-10;
    maxIteration = 100;
    v = 3;
elseif nargin == 4
    maxIteration = 100;
    v = 3;
elseif nargin == 5
    v = 3;
elseif nargin ~= 6
    error('chordMethod: invalid input parameters');
end
%% main part
iteration = 0;
x = x0;
err = norm(f(x));

while (err > tolerence) && (iteration < maxIteration)
    if (mod(iteration, v) == 0) % only calculate Jacobian every v steps
        J = df(x);
    end
    iteration = iteration + 1;
    x = x - J \ f(x);
    err = norm(f(x));
end

end