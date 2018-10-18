include("../Lecture scripts/Iterative Solvers.jl")

using LinearAlgebra
using Random

Random.seed!(0)


function GS(A,b,x,iterMax=10000)
    n,m = size(A)

    xnext = xc = x

    for j in 1:iterMax
        for i in 1:m
            xnext[i] = (b[i] - A[i, 1:i-1]'*xnext[1:i-1] - A[i,i+1:m]'*xc[i+1:m])/A[i,i]
        end
        xc = xnext
    end

    return xc
end

## Use generateProblem from 'Iterative Solvers.jl'
A, b, x, x0 = generateProblem(10)

GS_me = GS(A,b,x)

## Absolute difference
abs.(x-GS_me)
