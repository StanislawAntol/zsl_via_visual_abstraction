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

function [rankMean, rankMedian, recallAt1, recallAtK] = ComputeAccuracyInstanceMetrics(predIdxs, testLabels, testLabelsMap, numDivs)

    predImgLabels = testLabelsMap(predIdxs);
    testLabelsMat = repmat(testLabels, 1, size(predImgLabels, 2));
    rankMat = testLabelsMat == predImgLabels;
    
    rankMatCell = num2cell(rankMat, 2);
    indexOfFirstCorrectLabel = cellfun(@(row) find(row, 1, 'first'), rankMatCell);

    numRanks = size(predImgLabels, 2);
    rankMean = mean(indexOfFirstCorrectLabel)./numRanks;
    rankMedian = median(indexOfFirstCorrectLabel)./numRanks;
    
    x1 = linspace(1/numRanks, 1, numRanks)';
    recallAtKUnnorm = mean(cumsum(rankMat, 2) >= 1)';
    recallAt1 = recallAtKUnnorm(1);

    x2 = linspace(1/numDivs, 1, numDivs)';
    recallAtK = interp1q(x1, recallAtKUnnorm, x2)'; 
    
end