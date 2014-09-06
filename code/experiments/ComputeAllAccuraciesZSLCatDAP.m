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

function [accuraciesOverall, accuraciesAvgClass, averagePrecision, averagePrecisionRandom] = ComputeAllAccuraciesZSLCatDAP(options, parameters)

featSetsToUse = parameters.featSets;
biases = parameters.biasTrain;
probs  = parameters.probTest;
trainOnKs = parameters.trainOnKs;
detMethods = parameters.detMethods;
detMethodNames = parameters.detMethodsNames;

numFeatSets = length(featSetsToUse);
numBiases = length(biases);
numProbs = length(probs);
numDet = length(detMethods);

numTrainOnKs = length(trainOnKs);

accuraciesOverall = cell(numFeatSets, numBiases, numProbs, 1, numTrainOnKs);
accuraciesAvgClass = cell(numFeatSets, numBiases, numProbs, 1, numTrainOnKs);
averagePrecision = cell(numFeatSets, numBiases, numProbs, 1, numTrainOnKs);
averagePrecisionRandom = cell(numFeatSets, numBiases, numProbs, 1, numTrainOnKs);

for nFt = 1:numFeatSets
    featsToUse = featSetsToUse{nFt};
    featsStr = strrep(num2str(featsToUse), '  ', '_');
    for nB = 1:numBiases
        biasTrain = biases(nB);
        for nProb = 1:numProbs
            probTest = probs(nProb);
            
            for kIdx = 1:length(parameters.trainOnKs)
                K = parameters.trainOnKs(kIdx);
                
                if (K == 50)
                    numRandKs = parameters.numRandKs(kIdx);
                    tempOverallAccuracies = cell(numRandKs, 1);
                    tempAvgClassAccuracies = cell(numRandKs, 1);
                    tempAvgPrec = cell(numRandKs, 1);
                    tempAvgPrecRandom = cell(numRandKs, 1);
                    for randIdx = 1:numRandKs
                        curSeedValForK = parameters.seedVal + randIdx;
                        
                        loadString = sprintf(['load ', options.saveModelDAPFormatStr, '.mat'], ...
                            options.classificationModelFileCat, 2, featsStr, 1, biasTrain, probTest, K, curSeedValForK);
                        
                        eval(loadString);
                        
                        modelClasses = modelLabels;
                        
                        [overall, avgClass, AP, APRandom] = ...
                            ComputeAccuracyAtK(options, parameters, modelClasses, testLabels, decValues1, decValues2);
                        
                        tempOverallAccuracies{randIdx}  = overall;
                        tempAvgClassAccuracies{randIdx} = avgClass;
                        tempAvgPrec{randIdx} = AP;
                        tempAvgPrecRandom{randIdx} = APRandom;
                    end
                    
                    temp1 = tempOverallAccuracies{1};
                    temp2 = tempAvgClassAccuracies{1};
                    temp3 = tempAvgPrec{1};
                    temp4 = tempAvgPrecRandom{1};
                    for randIdx = 2:numRandKs
                        temp1 = temp1 + tempOverallAccuracies{randIdx};
                        temp2 = temp2 + tempAvgClassAccuracies{randIdx};
                        temp3 = temp3 + tempAvgPrec{randIdx};
                        temp4 = temp4 + tempAvgPrecRandom{randIdx};
                    end
                    
                    accuraciesOverall{nFt, nB, nProb, 1, kIdx}      = temp1/numRandKs;
                    accuraciesAvgClass{nFt, nB, nProb, 1, kIdx}     = temp2/numRandKs;
                    averagePrecision{nFt, nB, nProb, 1, kIdx}       = temp3/numRandKs;
                    averagePrecisionRandom{nFt, nB, nProb, 1, kIdx} = temp4/numRandKs;
                else
                    accuraciesOverall{nFt, nB, nProb, 1, kIdx}      = 0;
                    accuraciesAvgClass{nFt, nB, nProb, 1, kIdx}     = 0;
                    averagePrecision{nFt, nB, nProb, 1, kIdx}       = 0;
                    averagePrecisionRandom{nFt, nB, nProb, 1, kIdx} = 0;
                end
            end
        end
    end
end
end