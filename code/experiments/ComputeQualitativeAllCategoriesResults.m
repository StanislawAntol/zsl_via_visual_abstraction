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

function [imgIdxsCell, imgLabelsCell, testLabelsCell, imgCorrectnessCell] = ComputeQualitativeAllCategoriesResults(options, parameters, datasetID, loadFilename)

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

    imgIdxsCell = cell(numFeatSets, numBiases, numProbs, numDet);
    imgLabelsCell = cell(numFeatSets, numBiases, numProbs, numDet);
    testLabelsCell = cell(numFeatSets, numBiases, numProbs, numDet);
    imgCorrectnessCell = cell(numFeatSets, numBiases, numProbs, numDet);
    
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
                    
                    K = parameters.trainOnKs(1);
                    curSeedValForK = parameters.seedVal + 1;
                    
                    loadString = sprintf(['load ', options.saveModelZSLCatFormatStr, '.mat'], ...
                        loadFilename, datasetID, featsStr, detMethod, biasTrain, probTest, K, curSeedValForK);
                    
                    eval(loadString);
                    
                    modelClasses = models{1}.Label;
                    
                    
                    if ( datasetID == 1 )
                        [imgIdxs, imgLabels, sortedTestLabels, imgCorrectness] = ComputeQualitativeAllCategoriesAtK(options, parameters, modelClasses, testLabels, decValues);
                    else
                        [imgIdxs, imgLabels, sortedTestLabels, imgCorrectness] = ComputeQualitativeAllCategoriesAtK(options, parameters, modelClasses, testLabels, decValues1, decValues2);
                    end
                    
                    imgIdxsCell{nFt, nB, nProb, nDet} = imgIdxs;
                    imgLabelsCell{nFt, nB, nProb, nDet} = imgLabels;
                    testLabelsCell{nFt, nB, nProb, nDet} = sortedTestLabels;
                    imgCorrectnessCell{nFt, nB, nProb, nDet} = imgCorrectness;
                end
                
            end
        end
    end
    
end
