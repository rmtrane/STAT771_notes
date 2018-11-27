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
function gradientDescentStrat1(A,b,x,xstar;epsilon=1e-15, maxIter=1000)
    # Get current residual
    rc = A*x-b
    # Get current error
    ec = norm(xstar - x)
    i = 0
    while norm(A'rc) >= epsilon && i < maxIter
        i += 1
        print(i)
        alpha = norm(A'*rc)^2/norm(A*A'*rc)^2
        x = SingleStepGS(alpha,A,x,b)
        rc = A*x-b
        ec = vcat(ec, norm(x - xstar))
    end

    return x, ec
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

A,b,x,x0 = generateProblem(10)
gradientDescentStrat1(A,b,x,x0)

function gradientDescent1(A,x,b, xreal;alpha_strategy = 1,ϵ = 1e-15,maxIter=1000)
    k = 1
    r_c = A*x - b
    r = norm(x - xreal)
    while norm(A'* r_c) >= ϵ && k <= maxIter
        alpha = norm(A'*r_c)^2 / norm(A*A'*r_c)^2
        x = singleGradDescent(A,x,b,alpha)
        r_c = A*x - b
        k = k+1
        r = vcat(r, norm(x - xreal))
    end
    return x, r, k
end

gradientDescent1(A,x,b,x0)
