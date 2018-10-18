using LinearAlgebra
using Random

function generateProblem(n)
    A = randn(n,n)  + sqrt(n)*I
    x = randn(n)
    x0 = randn(n)
    b = A*x
    return A, b, x, x0
end

Random.seed!(0)

function SOR(A,b,x,w; maxIter = 1000)

    n,m = size(A)

    xnext = x

    for j in 1:maxIter
        xc = xnext
        for i in 1:m
            xnext[i] = (1-w)*xc[i] - w/A[i,i]*A[i,i+1:m]'*xc[i+1:m] - w*A[i,1:i-1]'*xnext[1:i-1]/A[i,i] + w*b[i]/A[i,i]
        end
    end

    return x
end

A,b,x,x0 = generateProblem(10)

SOR_solution = SOR(A,b,x0,0.2, maxIter=1000)

norm(x-SOR_solution)
