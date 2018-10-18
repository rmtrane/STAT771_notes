using Random
Random.seed!(0);
using LinearAlgebra

include("least_squares.jl")
include("consistent_linear_systems.jl")

function constrainedLS(A,b,C,d)
    p,m = size(C)
    F = qr(C')
    AQ = A*F.Q
    AQ1 = AQ[1:end,1:p]
    AQ2 = AQ[1:end,(p+1):end]
    R = F.R[1:p,1:end]
    y1 = consistentLS(R', d)
    b2 = b - AQ1*y1
    y2 = least_squares(AQ2,b2)
    return F.Q*vcat(y1,y2[1])
end


## Example
n = 10
m = 4
p = 2
A = rand(n,m)
x = rand(m)
b = A*x
C = rand(p,m)
d = C*x
println(x)
x_hat= constrainedLS(A,b,C,d)
println(x_hat)
