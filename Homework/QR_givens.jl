using LinearAlgebra

function givens(a,i,j)
    """
    Computes the Givens Rotation for a
    vector a at indices i and j, where
    the index at j is set to zero.
    """
    d = length(a)
    (i > d || j > d) && error("Index out of range.")
    l = sqrt(a[i]^2 + a[j]^2)
    λ = a[i]/l
    σ = a[j]/l
    G = ones(d)
    G[i] = λ
    G[j] = λ
    G = diagm(0 => G)
    G[i,j] = σ
    G[j,i] = -σ
    return G
end


function QR_givens(A)
    n,m = size(A)

    Q = Matrix{Float64}(I,n,n)
    R = A

    for i in 1:m
        for j in n:-1:i+1
            #print(i,j)
            G = givens(R[:,i], j-1, j)
            R = G*R
            Q = Q*G'
        end
    end

    return Q, R
end

A = rand(4,4)

QR_givens(A)

QR_givens(A)[1]'*QR_givens(A)[1]
