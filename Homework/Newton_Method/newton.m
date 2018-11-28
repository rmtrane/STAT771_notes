function [x, err, iteration] = newton(f, df, x0, tolerence, maxIteration)
%
% Newton's method that find root for f(x) = 0.
%
% Input:
%   f - input funtion
%   df - input function's Jacobian
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
% Date: Nov. 16, 2018
%
%% handling inputs
if nargin == 3
    tolerence = 1e-10;
    maxIteration = 100;
elseif nargin == 4
    maxIteration = 100;
elseif nargin ~= 5
    error('newton: invalid input parameters');
end
%% main part
iteration = 0;
x = x0;
err = norm(f(x)); % because we are solving f(x) = 0,
                  % the error term has to be ||f(x)||

while (err > tolerence) && (iteration < maxIteration)
    iteration = iteration + 1;
    x = x - df(x) \ f(x);
    err = norm(f(x));
end

end