function [indexList] = commonNZSequence(array1, array2)
%   commonNZSequence - returns the list of indices where both array1 and array2 are non zero
% Inputs:
%   array1, array2 - two arrays
% Outputs:
%    the list of indices where both array1 and array2 are non zero
N = length(array1);
if N > length(array2)
    N = length(array2);
end

indexList = [];
for idx = 1:N
    if array1(idx) ~= 0 && array2(idx) ~= 0
        indexList = [indexList idx];
    end
end

end

