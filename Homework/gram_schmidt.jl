using LinearAlgebra

function GS_process(A)
    """
    Takes a matrix with r linearly independent
    vectors and returns a matrix with r linearly
    independent, orthonormal vectors
    """

    n, r = size(A)

    # Create matrix of 0s to hold results
    Q = zeros(n,r)

    # Fill out columns with q vectors
    for i = 1:r
        # Get a_r
        a = A[:, i]
        # This will eventually hold the q vector. We initialize with 0s
        p = zeros(n)


        # For all previously calculated q's...
        for j = 1:(i-1)
            # ... get q'*a_r*q and add them
            p[1:n] += Q[:, j]'*A[:,i]*Q[:,j]
        end

        # Calculate new q
        q = A[:,i]-p[1:n]
        Q[:,i] = q/norm(q)
    end

    return Q

end


A = rand(4,4)

aq=GS_process(A)

AQ'*AQ
