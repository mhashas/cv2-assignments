function [startDensePointIdx, stopDensePointIdx] = longestNZArray(array)
    %find the longest Non Zero or Non NaN sequence in a vector and return its indeces
    NPoints = length(array);
    continuousNonZeroCounts = 0;
    candidateStartContinuousNZ = 1;
    maxCotinuousNZ = 0;
    maxStartCotinuousNZ = 0;
    for i = 1:NPoints
        if array(i) == 0 || isnan(array(i))
            if continuousNonZeroCounts > maxCotinuousNZ
                maxCotinuousNZ = continuousNonZeroCounts;
                maxStartCotinuousNZ = candidateStartContinuousNZ;
            end
            candidateStartContinuousNZ = i + 1;
            continuousNonZeroCounts = 0;
        else
            continuousNonZeroCounts = continuousNonZeroCounts + 1;
        end
    end
    
    %check the last sequence separately
    if continuousNonZeroCounts > maxCotinuousNZ
        maxCotinuousNZ = continuousNonZeroCounts;
        maxStartCotinuousNZ = candidateStartContinuousNZ;
    end
    
    startDensePointIdx = maxStartCotinuousNZ;
    stopDensePointIdx = maxStartCotinuousNZ+maxCotinuousNZ-1;
end

