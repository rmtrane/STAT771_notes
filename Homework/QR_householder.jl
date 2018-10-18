using LinearAlgebra

# Householder Reflection
function householder(a)
    """
    Computes the householder reflection
    given a nonzero vector a.
    """

    a = float(a)

    nrm_a = norm(a,2)
    nrm_a == 0 && error("Input vector is zero.")

    d = length(a)
    v = copy(a)
    v[1] = v[1] - nrm_a

    H = I - (2/dot(v,v))*v*v'

    return H
end

QR_householder = function(A)
    n,m = size(A)

    ## Get e vectors
    Es = Matrix{Float64}(I,m,m)

    H = Matrix{Float64}(I,m,m)

    for i in 1:m
        ai = A[i:m,i]

        htmp = householder(ai)

        if i > 1
            htmp = vcat(hcat(Matrix{Float64}(I, i-1, i-1), zeros(i-1, m-i+1)),
                        hcat(zeros(m-i+1, i-1), htmp))
        end

        H *= htmp
        A = htmp*A

    end

    return H, A
end

A = rand(4,4)

QRH=QR_householder(A)

QRH[1]'*QRH[1]
