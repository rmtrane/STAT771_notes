include("../Lecture scripts/Iterative Solvers.jl")

using LinearAlgebra
using Random

Random.seed!(0)

function jacobi(A,b,x,iterMax=10000)

    n,m = size(A)

    xnext = xc = x

    for j in 1:iterMax
        for i in 1:m
            xnext[i] = (b[i] - vcat(A[i,1:i-1], A[i,i+1:m])'*xc[vcat(1:i-1, i+1:m)])/A[i,i]
        end
        xc = xnext
    end

    return xc
end

A, b, x, x0 = generateProblem(10)

jacobi_me = jacobi(A,b,x0)

# Difference
abs.(jacobi_me - x)
