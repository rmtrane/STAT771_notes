include("invert_upper_tri.jl")

#Solving Linear System

function consistentLS(A,b)
    """
    Solves a consistent linear system given
    the coefficient matrix A and the constant
    vector b. Assumes A is consistent.
    """
    n, m = size(A)
    F = qr(A, Val(true))
    d = F.Q'*b
    c = invertUpperTri(F.R)*d[1:m]
    return F.P*c
end


print(
"EXAMPLE 1: Randomly Generated System\n")
n, m = 10, 4
println("Dimension of A: $n by $m")
A = rand(10,4)
x = rand(4)
b = A*x
println("Error between consistentLS and  'truth':
    $(norm(consistentLS(A,b) - x))")
