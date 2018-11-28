using LinearAlgebra

## Single step for user specified alpha
function SingleStepGS(alpha,A,x,b)
    """
    Performs a single step of gradient descent with
    - alpha: step size
    - A: coefficient matrix
    - x: current iterative
    - b: constant vector
    """
    x = x + alpha * A'*(b-A*x)

    return x
end

## Gradient descent for Strategy 1: alpha = ||A'r_c||^2/||AA'r_c||^2
function gradientDescentStrat1(A,b,x,x0;epsilon=1e-14, maxIter=10000)
    # Get current residual
    rc = A*x0-b
    # Get current error
    ec = norm(x0 - x)
    i = 1

    while norm(rc) >= epsilon && i < maxIter
        alpha = norm(A'*rc)^2/norm(A*A'*rc)^2
        x0 = SingleStepGS(alpha,A,x0,b)
        rc = A*x0-b
        ec = vcat(ec, norm(x0 - x))
        i += 1
    end

    return x0, ec
end

## Gradient descent for Strategy 2: alpha = ||A'(x_c - x^*)||^2/||AA'(x_c-x^*)||^2
function gradientDescentStrat2(A,b,x,x0;epsilon=1e-14, maxIter=10000)
    # Get current residual
    rc = A*x0-b
    # Get current error
    ec = norm(x0 - x)
    i = 1

    while norm(rc) > epsilon && i < maxIter
        alpha = norm(A'*(x0-x))^2/norm(A*A'*(x0-x))^2
        x0 = SingleStepGS(alpha,A,x0,b)
        rc = A*x0-b
        ec = vcat(ec, norm(x0 - x))
        i += 1
    end

    return x0, ec
end

## Gradient descent for Strategy 3: alpha = ||A||^2/||AA'||^2
function gradientDescentStrat3(A,b,x,x0;epsilon=1e-14, maxIter=10000)
    # Get current residual
    rc = A*x0-b
    # Get current error
    ec = norm(x0 - x)
    i = 1
    alpha = norm(A)^2/norm(A*A')^2

    while norm(rc) >= epsilon && i < maxIter
        #print(norm(A'*rc))
        x0 = SingleStepGS(alpha,A,x0,b)
        rc = A*x0-b
        ec = vcat(ec, norm(x0 - x))
        i += 1
    end

    return x0, ec
end

## Function to generate problem
function generateProblem(n)
    tmp = randn(n,n)
    A = tmp'*tmp  + sqrt(n)*Matrix{Float64}(I,n,n)
    x = randn(n)
    x0 = randn(n)
    b = A*x
    return A, b, x, x0
end

using Distributions; using Random
Random.seed!(0)
problems = map(x-> generateProblem(sample(5:10)), 1:20)

A,b,x,x0 = problems[1]

gradientDescentStrat1(A,b,x,x0)
gradientDescentStrat2(A,b,x,x0)
gradientDescentStrat3(A,b,x,x0)



function generateProblemEigenvalues(eigenvalues)
    n = length(eigenvalues)
    B = rand(n,n)
    Q = qr(B).Q
    Lambda = diagm(0 => eigenvalues)
    A = Q*Lambda*Q'
    x = randn(n)
    b = A*x
    return A, x, b
end

eigenvalues = rand(4)

A = generateProblemEigenvalues(eigenvalues)[1]

sqrt.(svdvals(A'*A))

Vt = svd(A'*A).Vt

U = svd(A'*A).U



eigen(A).vectors
