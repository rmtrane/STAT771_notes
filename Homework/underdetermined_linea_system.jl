include("invert_upper_tri.jl")
include("consistent_linear_systems.jl")

# Under determined Least Squares
function underLS(A,b; ϵ = 1e-14)
    """
    Solves an underdetermined linear system given
    the coefficient matrix A and the constant
    vector b. Returns the least norm solution.
    """
    n, m = size(A)
    s = min(n,m)
    F = qr(A, Val(true))

    #Compute rank approximation r
    Rtrm = F.R[1:s,1:s]
    r = maximum(findall(abs.(diag(Rtrm)) .>= ϵ))
    l = m - r

    #Generate R and S
    R, S = F.R[1:r,1:r], F.R[1:r,r+1:end]
    d, P = invertUpperTri(R)*(F.Q'*b)[1:r], invertUpperTri(R)*S
    z2 = consistentLS(P'*P + I, P'*d)
    z1 = d - P*z2
    return F.P*vcat(z1,z2)
end

print("EXAMPLE 2: Fat Matrix\n")
n, m = 4, 10
A = rand(n,m)
b = rand(n)
println("A is an $n by $m matrix")
println("Error between underLS and 'truth':
    $(norm(underLS(A,b) - A\b))")
