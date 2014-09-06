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

function [accuracyOverall, accuracyAvgClass, averagePrecision, averagePrecisionRandom] = ComputeAccuracyAtK(options, parameters, modelClasses, testLabels, dec1Values, dec2Values)  

    numClassifiers = length(modelClasses);    
    if ( numClassifiers == 2 )
        numClassifiers = 1;
    end
    testLabelsMat = repmat(testLabels, 1, numClassifiers);
    
	accuracyOverall  = zeros(numel(dec1Values), numClassifiers);
    accuracyAvgClass = zeros(numel(dec1Values), numClassifiers);
    averagePrecision  = zeros(numel(dec1Values), numClassifiers);
    averagePrecisionRandom = zeros(numel(dec1Values), numClassifiers);
    
    % Make AP computed so modelClasses order on columns
    [~, idxPos] = sort(modelClasses);
    numTest = size(dec1Values{1}, 1);
    binaryLabelsMat = false(numTest, numClassifiers);
    for idxImg = 1:numTest
        binaryLabelsMat(idxImg, idxPos(testLabels(idxImg))) = 1;
    end
    
    for i = 1:numel(dec1Values)
        if ( nargin == 5 )
            maxScore = dec1Values{i};
        else
            maxScore = max(dec1Values{i}, dec2Values{i});
        end
        
        classifierAPs = zeros(numClassifiers, 1);
        randomAPs = zeros(numClassifiers, 1);
        for idxLabels = 1:numClassifiers
            [AP, random] = AveragePrecisionVOC2012(maxScore(:, idxLabels), binaryLabelsMat(:, idxLabels));
            classifierAPs(idxLabels) = mean(AP);
            randomAPs(idxLabels) = random;
        end
        
        averagePrecision(i, :) = classifierAPs;
        averagePrecisionRandom(i, :) = randomAPs;
        
        [~, predIdxs] = sort(maxScore, 2, 'descend');    
        predictions = modelClasses(predIdxs);
        
        acc = cumsum(predictions == testLabelsMat, 2);
        accuracyOverall(i, :) = mean(acc);
        
        classAcc = zeros(numClassifiers, numClassifiers);
        for j = 1:numClassifiers
            classAcc(j, :) = mean(acc( (modelClasses(j)==testLabels), :));
        end
        
        accuracyAvgClass(i, :) = mean(classAcc);
        
    end

end