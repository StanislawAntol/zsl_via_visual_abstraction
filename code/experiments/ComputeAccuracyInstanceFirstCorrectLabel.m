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

function [indexOfFirstCorrectLabel] = ComputeAccuracyInstanceFirstCorrectLabel(predIdxs, testLabels, testLabelsMap)

    predImgLabels = testLabelsMap(predIdxs);
    testLabelsMat = repmat(testLabels, 1, size(predImgLabels, 2));
    rankMat = testLabelsMat == predImgLabels;
    
    rankMatCell = num2cell(rankMat, 2);
    indexOfFirstCorrectLabel = cellfun(@(row) find(row, 1, 'first'), rankMatCell);
    
end