%<FUNCTIONNAME> <Function description.>
%
%  [<outputs>] = <FunctionName>(<inputs>) is for <description>.
%
%  INPUT
%    -<input1>:     <input1 description>
%    -<input2>:     <input2 description>
%
%  OUTPUT
%    -<output1>:    <output2 description>
%
%  Author: Stanislaw Antol (santol@vt.edu)                 Date: 2014-08-18

function [predIdxsYtoX, predIdxsXtoY, isOrd1] = NearestNeighborMatching(XTest, YTestOrd1, YTestOrd2)
    
    if (nargin == 2 )
        minDists = pdist2(YTestOrd1, XTest);
        isOrd1 = ones(size(minDists));
    else
        dist1 = pdist2(YTestOrd1, XTest);
        dist2 = pdist2(YTestOrd2, XTest);
        minDists = min(dist1, dist2);
        isOrd1 = dist1 == minDists;
    end
    
    [A1, predIdxsYtoX] = sort(minDists, 2, 'ascend');
    [A2, predIdxsXtoY] = sort(minDists', 2, 'ascend');
    
    B = unique(A2, 'rows');
end