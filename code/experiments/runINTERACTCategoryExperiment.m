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

% function runINTERACTCategoryExperiment

datasetNum = 2;
%     options.whichData = [ 1 2 3 4 5];
options.whichData = [ 1 3 4 5 ];
for i = 1:length(options.whichData)
    load(options.classificationDataFile{options.whichData(i)});
end

allINTERACTImgIdxs = 1:length(allINTERACTImgGTLabels);

uniqueImgLabels = unique(allINTERACTImgGTLabels);
numUniqueImgLabels = length(uniqueImgLabels);

numFeatSets = length(parameters.featSets);
numDetTypes = length(parameters.detMethods);

for nFt = 1:numFeatSets
    featsToUse = parameters.featSets{nFt};
    featsStr = strrep(num2str(featsToUse), '  ', '_');
    
    % Clipart Category Features Order 1 and 2, although Order 1
    % is the actual order (use 2 if testing on clipart...).
    allTrainDataFeats{1, 1} = cell2mat(allINTERACTClipCatFeatures(featsToUse, 1)');
    allTrainDataFeats{1, 2} = cell2mat(allINTERACTClipCatFeatures(featsToUse, 2)');
    allTrainDataLabels{1}   = allINTERACTClipCatLabels;
    allTrainDataIdxs{1}     = 1:length(allINTERACTClipCatLabels);
    
    % Test Categories different detection: Perfect Pose, YR, YR w/ BB
    for nDetType = 1:numDetTypes 
        if (nDetType == 1)
            allTestDataFeats{nDetType, 1} = cell2mat(allINTERACTImgGTFeatures(featsToUse, 1)');
            allTestDataFeats{nDetType, 2} = cell2mat(allINTERACTImgGTFeatures(featsToUse, 2)');
            allTestDataLabels{nDetType}   = allINTERACTImgGTLabels;
        elseif (nDetType == 2)
            allTestDataFeats{nDetType, 1} = cell2mat(allINTERACTImgYRDFeatures(featsToUse, 1)');
            allTestDataFeats{nDetType, 2} = cell2mat(allINTERACTImgYRDFeatures(featsToUse, 2)');
            allTestDataLabels{nDetType}   = allINTERACTImgGTLabels;
        elseif (nDetType == 3)
            allTestDataFeats{nDetType, 1} = cell2mat(allINTERACTImgYRBBFeatures(featsToUse, 1)');
            allTestDataFeats{nDetType, 2} = cell2mat(allINTERACTImgYRBBFeatures(featsToUse, 2)');
            allTestDataLabels{nDetType}   = allINTERACTImgGTLabels;
        end
    end
    
    if ( options.runINTERACTCatExpTrain ~= 0 )
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
                        modelParams = parameters.Cs;
                        models      = TrainLinearSVMModels(options, parameters, biasTrain, trainLabels, trainFeatMat);
                        
                        for nDetType = 1:numDetTypes
                            detMethod = parameters.detMethods(nDetType);
                            testLabels = allTestDataLabels{nDetType};
                            [decValues1, decValues2] =  TestLinearSVMModels(options, parameters, probTest, models, testLabels, allTestDataFeats{nDetType, 1}, allTestDataFeats{nDetType, 2});
                            
                            saveString = sprintf(['save ', options.saveModelZSLCatFormatStr, '.mat models modelParams decValues1 decValues2 testLabels'], ...
                                options.classificationModelFileCat, datasetNum, featsStr, detMethod, biasTrain, probTest, K, curSeedValForK);
                            eval(saveString);
                        end
                        
                                                
                        if ( (options.runINTERACTCatExpDAP ~= 0) && (K == 50))
                            perfectPose = 1; % Assuming running on at least PP detection
                          
                            allTestDataDAP = allINTERACTImgGTFeatures;
                            % If using contact (kind of need to), remove
                            % self-contact from the original contact
                            % features
                            if (sum(parameters.featsToUseDAP == 2) > 0 )
                                allTestDataDAP{2, 1} = SimplifyContactFeatures(allTestDataDAP{2, 1});
                                allTestDataDAP{2, 2} = SimplifyContactFeatures(allTestDataDAP{2, 2});
                            end
                            allTestDataFeatsDAP{perfectPose, 1} = cell2mat(allTestDataDAP(parameters.featsToUseDAP, 1)');
                            allTestDataFeatsDAP{perfectPose, 2} = cell2mat(allTestDataDAP(parameters.featsToUseDAP, 2)');
                            
                            load(options.fileINTERACTAttributeData); % Loads verbPhraseAttrData
                            testDAPData  = verbPhraseAttrData; % All classes used
                            testDAPBinMat  = ConvertDAPDataToBinMat(options,  testDAPData);

                            [predictionsOrd1, decValues1] = DAP(testDAPBinMat, testDAPBinMat, allTestDataFeatsDAP{perfectPose, 1});
                            [predictionsOrd2, decValues2] = DAP(testDAPBinMat, testDAPBinMat, allTestDataFeatsDAP{perfectPose, 2});

                            decValues1 = {decValues1};
                            decValues2 = {decValues2};
                            testLabels = allTestDataLabels{perfectPose};
                            modelLabels = uniqueImgLabels;
                            
                            saveString = sprintf(['save ', options.saveModelDAPFormatStr, '.mat modelLabels decValues1 decValues2 testLabels'], ...
                                options.classificationModelFileCat, datasetNum, featsStr, perfectPose, biasTrain, probTest, K, curSeedValForK);
                            eval(saveString);
                        end
                        
                    end
                end
            end
        end
    end
end

if ( options.runINTERACTCatExpAccCalc ~= 0 )
    [accuraciesOverall, accuraciesAvgClass, averagePrecision, averagePrecisionRandom] = ComputeAllAccuraciesZSLCat(options, parameters, datasetNum, options.classificationModelFileCat);
    
    saveString = sprintf(['save ', options.saveAccuraciesZSLCatFormatStr, '.mat', ...
        ' accuraciesOverall accuraciesAvgClass averagePrecision averagePrecisionRandom'], ...
        options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.detMethodsStr, ...
        parameters.biasTrainStr, parameters.probTestStr, parameters.trainOnKsStr, parameters.numRandKsStr);
    eval(saveString);
    
    accOv = squeeze(accuraciesOverall);
    accCl = squeeze(accuraciesAvgClass);
%     accClAt1 = cellfun(@(x) x(1), accCl);
    AP = squeeze(averagePrecision);
    APR = squeeze(averagePrecisionRandom);
    
    if ( options.runINTERACTCatExpDAP ~= 0 )
        [accuraciesOverallDAP, accuraciesAvgClassDAP, averagePrecisionDAP, averagePrecisionRandomDAP] = ComputeAllAccuraciesZSLCatDAP(options, parameters);
        saveString = sprintf(['save ', options.saveAccuraciesDAPFormatStr, '.mat', ...
            ' accuraciesOverallDAP accuraciesAvgClassDAP averagePrecisionDAP averagePrecisionRandomDAP'], ...
            options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.detMethodsStr, ...
            parameters.biasTrainStr, parameters.probTestStr, parameters.trainOnKsStr, parameters.numRandKsStr);
        eval(saveString);
    end
end

if ( options.runINTERACTCatExpAccPlot ~= 0 )
    filename = sprintf([options.saveAccuraciesZSLCatFormatStr, '.mat'], ...
        options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.detMethodsStr, ...
        parameters.biasTrainStr, parameters.probTestStr, parameters.trainOnKsStr, parameters.numRandKsStr);
    load(filename);
    
    if ( options.runINTERACTCatExpDAP ~= 0 )
        loadString = sprintf(['load ', options.saveAccuraciesDAPFormatStr, '.mat'], ...
            options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.detMethodsStr, ...
            parameters.biasTrainStr, parameters.probTestStr, parameters.trainOnKsStr, parameters.numRandKsStr);
        eval(loadString);  
        ClassificationCategoryAccuracyAtKPlot(options, parameters, accuraciesOverall, accuraciesAvgClass, datasetNum, accuraciesOverallDAP, accuraciesAvgClassDAP);
    else
        ClassificationCategoryAccuracyAtKPlot(options, parameters, accuraciesOverall, accuraciesAvgClass, datasetNum);
    end
end

if ( options.runINTERACTCatExpQual ~= 0 )
    parameters = CreateParametersINTERACTCatExpQual();
    CreateQualitativeResults(options, parameters, datasetNum, ...
        options.classificationModelFileCat, allINTERACTImgGTImgFilename, ...
        allINTERACTClipCatLabels, allINTERACTClipCatImgFilename);
end

if ( options.runINTERACTCatExpConfMat ~= 0 )
    parameters = CreateParametersINTERACTCatExpQual();
    % @TODO Output Confusion matrices directly to file
    CreateConfusionMatrices(options, parameters, datasetNum, ...
        options.classificationModelFileCat); 
end        