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

function [accuraciesOverall, accuraciesAvgClass, averagePrecision, averagePrecisionRandom] = ComputeAllAccuraciesZSLCat(options, parameters, datasetID, loadFilename)

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

    if ( options.runINTERACTCatExpDAP ~= 0 )
        offset = 1;
    else
        offset = 0;
    end
    accuraciesOverall = cell(numFeatSets, numBiases, numProbs, numDet+offset, numTrainOnKs);
    accuraciesAvgClass = cell(numFeatSets, numBiases, numProbs, numDet+offset, numTrainOnKs);
    averagePrecision = cell(numFeatSets, numBiases, numProbs, numDet+offset, numTrainOnKs);
    averagePrecisionRandom = cell(numFeatSets, numBiases, numProbs, numDet+offset, numTrainOnKs);

    for nFt = 1:numFeatSets
        featsToUse = featSetsToUse{nFt};
        featsStr = strrep(num2str(featsToUse), '  ', '_');
        for nB = 1:numBiases
            biasTrain = biases(nB);
            for nProb = 1:numProbs
                probTest = probs(nProb);
                for nDet = 1:numDet
                    detMethod = detMethods(nDet);
                    detMethodName = detMethodNames{nDet};
                    for kIdx = 1:length(parameters.trainOnKs)
                        K = parameters.trainOnKs(kIdx);
                        numRandKs = parameters.numRandKs(kIdx);
                        tempOverallAccuracies = cell(numRandKs, 1);
                        tempAvgClassAccuracies = cell(numRandKs, 1);
                        tempAvgPrec = cell(numRandKs, 1);
                        tempAvgPrecRandom = cell(numRandKs, 1);
                        for randIdx = 1:numRandKs
                            curSeedValForK = parameters.seedVal + randIdx;

                            loadString = sprintf(['load ', options.saveModelZSLCatFormatStr, '.mat'], ...
                                loadFilename, datasetID, featsStr, detMethod, biasTrain, probTest, K, curSeedValForK);

                            eval(loadString);

                            modelClasses = models{1}.Label;

                            if ( datasetID == 1 )
                                [overall, avgClass, AP, APRandom] = ...
                                    ComputeAccuracyAtK(options, parameters, modelClasses, testLabels, decValues);
                                %                                 [imgIdxs, correctness] = ComputeQualitativeAtK(options, parameters, modelClasses, testLabels, decValues);
                            else
                                [overall, avgClass, AP, APRandom] = ...
                                    ComputeAccuracyAtK(options, parameters, modelClasses, testLabels, decValues1, decValues2);
                            end

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
                        accuraciesOverall{nFt, nB, nProb, nDet, kIdx}      = temp1/numRandKs;
                        accuraciesAvgClass{nFt, nB, nProb, nDet, kIdx}     = temp2/numRandKs;
                        averagePrecision{nFt, nB, nProb, nDet, kIdx}       = temp3/numRandKs;
                        averagePrecisionRandom{nFt, nB, nProb, nDet, kIdx} = temp4/numRandKs;

                        if ( (options.runINTERACTCatExpDAP ~= 0) && (K == 50) )
                            accuraciesOverall{nFt, nB, nProb, nDet, kIdx}      = temp1/numRandKs;
                            accuraciesAvgClass{nFt, nB, nProb, nDet, kIdx}     = temp2/numRandKs;
                            averagePrecision{nFt, nB, nProb, nDet, kIdx}       = temp3/numRandKs;
                            averagePrecisionRandom{nFt, nB, nProb, nDet, kIdx} = temp4/numRandKs;
                        end
                    end
                end
            end
        end
    end
end