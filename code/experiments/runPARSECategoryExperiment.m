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

% function runPARSECategoryExperiment

datasetNum = 1;
%     options.whichData = [ 1 2 3 4 5];
options.whichData = [ 6 8 9];
for i = 1:length(options.whichData)
    load(options.classificationDataFile{options.whichData(i)});
end

allPARSEImgIdxs = 1:length(allPARSEImgGTLabels);

uniqueImgLabels = unique(allPARSEImgGTLabels);
numUniqueImgLabels = length(uniqueImgLabels);

numFeatSets = length(parameters.featSets);
numDetTypes = length(parameters.detMethods);

for nFt = 1:numFeatSets
    featsToUse = parameters.featSets{nFt};
    featsStr = strrep(num2str(featsToUse), '  ', '_');
    
    % Clipart Category Features
    allPARSEImgGTLabelsFinal = dlmread(options.filePARSECategorizationFinal);
    relevantTrainLogIdxs = (allPARSEClipCatLabels > 0)    & (allPARSEClipCatLabels < 15);
    relevantTestLogIdxs  = (allPARSEImgGTLabelsFinal > 0) & (allPARSEImgGTLabelsFinal < 15);
    
    allTrainDataFeats{1, 1} = cell2mat(allPARSEClipCatFeatures(featsToUse, 1)');
    allTrainDataFeats{1, 1} = allTrainDataFeats{1, 1}(relevantTrainLogIdxs, :);
    
    allTrainDataLabels{1}   = allPARSEClipCatLabels(relevantTrainLogIdxs);
    allTrainDataIdxs{1}     = 1:length(allPARSEClipCatLabels(relevantTrainLogIdxs));
    
    % Test Categories different detection: Perfect Pose, YR, YR w/ BB
    for nDetType = 1:numDetTypes % TODO: Fix to be variable with detection schemes
        if (nDetType == 1)
            allTestDataFeats{nDetType, 1} = cell2mat(allPARSEImgGTFeatures(featsToUse, 1)');
            allTestDataFeats{nDetType, 1} = allTestDataFeats{nDetType, 1}(relevantTestLogIdxs, :);
            allTestDataLabels{nDetType}   = allPARSEImgGTLabels(relevantTestLogIdxs);
        elseif (nDetType == 2)
            allTestDataFeats{nDetType, 1} = cell2mat(allPARSEImgYRDFeatures(featsToUse, 1)');
            allTestDataFeats{nDetType, 1} = allTestDataFeats{nDetType, 1}(relevantTestLogIdxs, :);
            allTestDataLabels{nDetType}   = allPARSEImgGTLabels(relevantTestLogIdxs);
        end
    end
    
    if ( options.runPARSECatExpTrain ~= 0 )
        for biasTrainIdx = 1:length(parameters.biasTrain)
            biasTrain = parameters.biasTrain(biasTrainIdx);
            for probTestIdx = 1:length(parameters.probTest)
                probTest = parameters.probTest(probTestIdx);
                for kIdx = 1:length(parameters.trainOnKs)
                    K = parameters.trainOnKs(kIdx);
                    
                    for randIdx = 1:parameters.numRandKs(kIdx)
                        
                        % Select the random K illustrations (per category) for training
                        curSeedValForK = parameters.seedVal + randIdx;
                        seed = RandStream('mt19937ar', 'Seed', curSeedValForK);
                        trainIdxs = [];
                        for idx = 1:length(uniqueImgLabels)
                            label = uniqueImgLabels(idx);
                            verbIdxs = allTrainDataIdxs{1}(allTrainDataLabels{1} == label)';
                            numVerbIdxs = length(verbIdxs);
                            maxTrainImgNum = min([numVerbIdxs, K]);
                            randIdxs = randperm(seed, numVerbIdxs, maxTrainImgNum)';
                            trainIdxs = [trainIdxs; verbIdxs(randIdxs)];
                        end
                        
                        trainSubsetIdxs = sort(trainIdxs);
                        trainLabels = allTrainDataLabels{1}(trainSubsetIdxs);
                        trainFeatMat = allTrainDataFeats{1, 1}(trainSubsetIdxs, :); % Order 1 which should be the GT ordering
                        
                        for nDetType = 1:numDetTypes
                            detMethod = parameters.detMethods(nDetType);
                            testLabels = allTestDataLabels{nDetType};
                            modelParams = parameters.Cs;
                            models      = TrainLinearSVMModels(options, parameters, biasTrain, trainLabels, trainFeatMat);
                            decValues =  TestLinearSVMModelsIndv(options, parameters, probTest, models, testLabels, allTestDataFeats{nDetType, 1});
                            
                            saveString = sprintf(['save ', options.saveModelZSLCatFormatStr, '.mat models modelParams decValues testLabels'], ...
                                options.classificationModelFileCat, datasetNum, featsStr, detMethod, biasTrain, probTest, K, curSeedValForK);
                            eval(saveString);
                        end
                    end
                end
            end
        end
    end
end

if ( options.runPARSECatExpAccCalc ~= 0 )
    [accuraciesOverall, accuraciesAvgClass, averagePrecision, averagePrecisionRandom] = ComputeAllAccuraciesZSLCat(options, parameters, datasetNum, options.classificationModelFileCat);
    accOv = squeeze(accuraciesOverall);
    accCl = squeeze(accuraciesAvgClass);
    AP = squeeze(averagePrecision);
    APR = squeeze(averagePrecisionRandom);

    saveString = sprintf(['save ', options.saveAccuraciesZSLCatFormatStr, '.mat', ...
        ' accuraciesOverall accuraciesAvgClass averagePrecision averagePrecisionRandom'], ...
        options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.detMethodsStr, ...
        parameters.biasTrainStr, parameters.probTestStr, parameters.trainOnKsStr, parameters.numRandKsStr);
    eval(saveString);
end

if ( options.runPARSECatExpAccPlot ~= 0 )
    filename = sprintf([options.saveAccuraciesZSLCatFormatStr, '.mat'], ...
        options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.detMethodsStr, ...
        parameters.biasTrainStr, parameters.probTestStr, parameters.trainOnKsStr, parameters.numRandKsStr);
    load(filename);
    ClassificationCategoryAccuracyAtKPlot(options, parameters, accuraciesOverall, accuraciesAvgClass, datasetNum);
%     ClassificationCategoryAccuracyAtKPlot(options, parameters,
%     accuraciesAvgClass, accuraciesOverall, datasetNum); % incorrect way
end

if ( options.runPARSECatExpQual ~= 0 )
    parameters = CreateParametersPARSECatExpQual();
    CreateQualitativeResults(options, parameters, datasetNum, ...
        options.classificationModelFileCat, allPARSEImgGTImgFilename(relevantTestLogIdxs), ...
        allPARSEClipCatLabels, allPARSEClipCatImgFilename);    
end

if ( options.runPARSECatExpConfMat ~= 0 )
   parameters = CreateParametersPARSECatExpQual();
   CreateConfusionMatrices(options, parameters, datasetNum, ...
       options.classificationModelFileCat);
end