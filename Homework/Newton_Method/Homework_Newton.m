%% Initialization
f = @(x) [...
    (1.5 - x(1) + x(1) * x(2)) * (x(2) - 1) + ...
    (2.25 - x(1) + x(1) * x(2) ^ 2) * (x(2) ^ 2 - 1) + ...
    (2.625 - x(1) + x(1) * x(2) ^ 3) * (x(2) ^ 3 - 1); ...
    (1.5 - x(1) + x(1) * x(2)) * x(1) + ...
    (2.25 - x(1) + x(1) * x(2) ^ 2) * 2 * x(1) * x(2) + ...
    (2.625 - x(1) + x(1) * x(2) ^ 3) * 3 * x(2) ^ 2 * x(1)];
df = @(x) [...
    (x(2) ^ 3 - 1) ^ 2 + (x(2) ^ 2 - 1) ^ 2 + (x(2) - 1) ^ 2, ...
    x(1) * (6 * x(2) ^ 5 + 4 * x(2) ^ 3 - 6 * x(2) ^ 2 - 2 * x(2) - 2) + ...
    7.875 * x(2) ^ 2 + 4.5 * x(2) + 1.5; ...
    x(1) * (6 * x(2) ^ 5 + 4 * x(2) ^ 3 - 6 * x(2) ^ 2 - 2 * x(2) - 2) + ...
    7.875 * x(2) ^ 2 + 4.5 * x(2) + 1.5, ...
    x(1) * (x(1) * (15 * x(2) ^ 4 + 6 * x(2) ^ 2 - 6 * x(2) - 1) + 15.75 * x(2) + 4.5)];
x0 = [1.5; 1.5];

%% Newton's Method
tic;
% for ii = 0:100
    [x, error, iteration] = newton(f, df, x0)
% end
toc;

%% Chord's Method
tic;
% for ii = 0:100
    [x, error, iteration] = chordMethod(f, df, x0)
% end
toc;

%% Forward Difference Method
tic;
% for ii = 0:100
    [x, error, iteration] = forwardDifference(f, x0)
% end
toc;

%% Broyden's Method
tic;
% for ii = 0:100
    [x, error, iteration] = broydenMethod(f, inv(df(x0)), x0)
% end
toc;