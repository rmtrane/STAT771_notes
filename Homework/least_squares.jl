include("invert_upper_tri.jl")

function least_squares(A,b)
    """
    Solves the linear squares regression problem given
    the coefficient matrix A and the constant vector b
    """

    n,m = size(A)

    # Get QR decomposition
    F = qr(A, Val(true))

    # Rank = m

    # Calculate c
    c = (F.Q'b)[1:m]

    # Create Pi matrix
    Pi = zeros(m, m)

    for i = 1:m
        Pi[F.p[i], i] = 1
    end

    # Calculate x
    x = Pi*invertUpperTri(F.R)*c

    return x,c
end

n, m = 10, 4
A = rand(n,m)
#b = rand(n)
x = rand(m)
b = A*x
ls=least_squares(A,b)
