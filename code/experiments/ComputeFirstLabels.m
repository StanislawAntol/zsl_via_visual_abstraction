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

function [isCorrect, clipartIdx, ordIdx] = ComputeFirstLabels(predIdxs, isOrd1, testLabels, testLabelsMap)

    predImgLabels = testLabelsMap(predIdxs);
    
    isCorrect = predImgLabels(:, 1) == testLabels;
    clipartIdx = predIdxs(:, 1);
    
    if ( size(predIdxs, 1) == size(isOrd1, 1) )
        ordIdx = 2.*ones(size(predIdxs, 1), 1);
        ordIdx(isOrd1(:, 1), 1) = 1;
    else
        ordIdx = 2.*ones(size(predIdxs, 1), 1);
        ordIdx(isOrd1(1, :), 1) = 1;
    end
%     testLabelsMat = repmat(testLabels, 1, size(predImgLabels, 2));
%     rankMat = testLabelsMat == predImgLabels;
%     
%     rankMatCell = num2cell(rankMat, 2);
%     indexOfFirstCorrectLabel = cellfun(@(row) find(row, 1, 'first'), rankMatCell);
    
end