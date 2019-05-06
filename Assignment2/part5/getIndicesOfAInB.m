function [indices] = getIndicesOfAInB(A, B)
    %all elements of A must be in B in the same order, but there might be
    %other elements in B
    indices = [];
    idxB = 1;
    for idxA = 1:length(A)
        while B(idxB) ~= A(idxA)
            idxB = idxB + 1;
        end
        indices = [indices, idxB];
    end
end