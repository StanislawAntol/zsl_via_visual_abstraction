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

function parentList = ComputeParentList(model)
    % assuming only one component
    c = model.components{1};
    numParts = length(c);
    parentList = zeros(numParts, 1);
    for k = 2:numParts
        part = c(k);
        parentList(k) = c(k).parent;
    end
end