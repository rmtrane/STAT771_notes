using LinearAlgebra

function modified_GS_process(A)
    """
    Takes a matrix with r linearly independent
    vectors and returns a matrix with r linearly
    independent, orthonormal vectors
    """

    n, r = size(A)

    # Create matrix of 0s to hold results
    Q = zeros(n,r)

    # Fill out first vector
    Q[:,1] = A[:,1]/norm(A[:,1])

    # Fill out columns with q vectors
    for i = 2:r
        # Get a_r
        a = A[:, i]

        Q[:,i] = a
        # For all previously calculated q's...
        for j = 1:(i-1)
            # ... get q'*a_r*q and add them
            Q[:,i] -= Q[:, i]'*Q[:,j]/(Q[:,j]'*Q[:,j])*Q[:,j]
        end

        # Calculate new q
        Q[:,i] = Q[:,i]/norm(Q[:,i])
    end

    R = Q'*A

    return Q, R

end


A = [1 1 1; 1 1 0; 1 0 2; 1 0 0]
A

modified_GS_process(A)
