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

% function runINTERACTInstanceExperiment

testingNewTrainMethod = 0;
recomputingAccuracyFile = 0;

spread = parameters.spread;
datasetNum = 2;
%     options.whichData = [ 1 2 3 4 5];
options.whichData = [1 2 3 4 5];
for i = 1:length(options.whichData)
    load(options.classificationDataFile{options.whichData(i)});
end

if (options.runINTERACTInstExpOrder ~= 0)
    % Creates GT ordering for instance-level clipart images
    fid = fopen(options.fileINTERACTClipInstWho);
    colsAsCells = textscan(fid, '%d%s', 'Delimiter', ';');
    fclose(fid);
    order = double(colsAsCells{1});
    clipartImgNames = colsAsCells{2};
    
    % whichData = 2 is for INTERACT instance-level clipart
    load(options.classificationDataFile{2});
    
    orderings = ones(length(allINTERACTClipInstImgFilename), 1);
    for idx = 1:length(clipartImgNames)
        whichIdx = find(strcmp(allINTERACTClipInstImgFilename, clipartImgNames{idx}));
        orderings(whichIdx, 1) = order(idx);
    end
    
    dlmwrite(options.fileINTERACTClipInstOrdering, orderings, ';');
end

allINTERACTImgIdxs = 1:length(allINTERACTImgGTLabels);

uniqueImgLabels = unique(allINTERACTImgGTLabels);
numUniqueImgLabels = length(uniqueImgLabels);

numFeatSets = length(parameters.featSets);
numDetMethods = length(parameters.detMethods);
numMapMethods = length(parameters.mapMethods);
recallAtKNumDivs = parameters.recallAtKNumDivs;
numTrainPercs = length(parameters.trainingPercs);
numRandTrainSplits = parameters.randTrainSplits;
numGRNNMethods = length(parameters.trainGRNNMethods);

fid = fopen(options.fileINTERACTClipInstOrdering);
colsAsCells = textscan(fid, '%d', 'Delimiter', ';');
fclose(fid);
allClipInstGTOrderingVec = double(colsAsCells{1});

for nTPs = 1:numTrainPercs
    trainPerc = parameters.trainingPercs(nTPs);
    numRandTrainSplits = parameters.randTrainSplits(nTPs);
    
    for nFt = 1:numFeatSets
        featsToUse = parameters.featSets{nFt};
        featsStr = strrep(num2str(featsToUse), '  ', '_');
        
        % Clipart Instance Features
        allClipFeats{1, 1} = cell2mat(allINTERACTClipInstFeatures(featsToUse, 1)');
        allClipFeats{1, 2} = cell2mat(allINTERACTClipInstFeatures(featsToUse, 2)');
        curNumFeatures = size(allClipFeats{1, 1}, 2);
        allClipGTOrderingMat = repmat(allClipInstGTOrderingVec, 1, curNumFeatures);
        allClipFeatsOrderGT{1, 1} = allClipFeats{1, 1}.*(allClipGTOrderingMat == 1) + allClipFeats{1, 2}.*(allClipGTOrderingMat == 2);
        allClipLabels = allINTERACTClipInstLabels;
        allClipFiles = allINTERACTClipInstImgFilename;
        
        allImgFiles = allINTERACTImgGTImgFilename;
        allINTERACTImgGTLabelsFinal = allINTERACTImgGTLabels;
        allImgIdxs = [1:length(allINTERACTImgGTLabelsFinal)]';
        
        allImgFeats  = cell(numDetMethods, 2);
        allImgLabels = cell(numDetMethods, 1);
        for nDetMethods = 1:numDetMethods
            if ( nDetMethods == 1)
                allImgFeats{nDetMethods, 1} = cell2mat(allINTERACTImgGTFeatures(featsToUse, 1)');
                allImgFeats{nDetMethods, 2} = cell2mat(allINTERACTImgGTFeatures(featsToUse, 2)');
                allImgPoses{nDetMethods, 1} = cell2mat(allINTERACTImgGTFeatures(8, 1)');
                allImgPoses{nDetMethods, 2} = cell2mat(allINTERACTImgGTFeatures(8, 2)');
            elseif (nDetMethods == 2)
                allImgFeats{nDetMethods, 1} = cell2mat(allINTERACTImgYRDFeatures(featsToUse, 1)');
                allImgFeats{nDetMethods, 2} = cell2mat(allINTERACTImgYRDFeatures(featsToUse, 2)');
                allImgPoses{nDetMethods, 1} = cell2mat(allINTERACTImgYRDFeatures(8, 1)');
                allImgPoses{nDetMethods, 2} = cell2mat(allINTERACTImgYRDFeatures(8, 2)');
            elseif (nDetMethods == 3)
                allImgFeats{nDetMethods, 1} = cell2mat(allINTERACTImgYRBBFeatures(featsToUse, 1)');
                allImgFeats{nDetMethods, 2} = cell2mat(allINTERACTImgYRBBFeatures(featsToUse, 2)');
                allImgPoses{nDetMethods, 1} = cell2mat(allINTERACTImgYRBBFeatures(8, 1)');
                allImgPoses{nDetMethods, 2} = cell2mat(allINTERACTImgYRBBFeatures(8, 2)');
            end
            allImgLabels{nDetMethods}   = allINTERACTImgGTLabels;
        end
        
        uniqueImgLabels = unique(allINTERACTImgGTLabels);
        numUniqueImgLabels = length(uniqueImgLabels);
        numTrainImgsLabels = ceil(numUniqueImgLabels*(trainPerc/100));
        
        totalNumClipTest = 0;
        totalNumImgTest  = 0;
        
        rankMeanAvgZSL   = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        rankMedianAvgZSL = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAt1AvgZSL  = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAtKAvgZSL  = zeros(numDetMethods, numMapMethods, numGRNNMethods, recallAtKNumDivs);
        
        rankMeanAvgSBIR   = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        rankMedianAvgSBIR = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAt1AvgSBIR  = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAtKAvgSBIR  = zeros(numDetMethods, numMapMethods, numGRNNMethods, recallAtKNumDivs);
        
        for nRS = 1:numRandTrainSplits
            
            curSeedValForTrain = parameters.seedVal + nRS;
            seed = RandStream('mt19937ar','Seed', curSeedValForTrain); % Trying to make it more consistent between different sessions
            
            trainImgCatLabels = uniqueImgLabels(randperm(seed, numUniqueImgLabels, numTrainImgsLabels));
            testImgCatLabels = setdiff(uniqueImgLabels, trainImgCatLabels);
            
            trainImgLogIdxs = ismember(allINTERACTImgGTLabels, trainImgCatLabels);
            testImgLogIdxs  = ~trainImgLogIdxs;
            
            for nDetMethods = 1:numDetMethods
                trainImgFeats{nDetMethods, 1} = allImgFeats{nDetMethods, 1}(trainImgLogIdxs, :);
                trainImgLabels{nDetMethods} = allImgLabels{nDetMethods}(trainImgLogIdxs);
                trainImgIdxs = allImgIdxs(trainImgLogIdxs);
                testImgFeats{nDetMethods, 1}  = allImgFeats{nDetMethods, 1}(testImgLogIdxs, :);
                testImgLabels{nDetMethods} = allImgLabels{nDetMethods}(testImgLogIdxs);
                testImgIdxs = allImgIdxs(testImgLogIdxs);
                testImgFiles = allINTERACTImgGTImgFilename(testImgLogIdxs);
                testImgPoses{nDetMethods, 1}  = allImgPoses{nDetMethods, 1}(testImgLogIdxs, :);
            end
            
            % Assumes INTERACT imgs are in order
            trainClipLogIdxs = ismember(allClipLabels, find(trainImgLogIdxs));
            testClipLogIdxs  = ~trainClipLogIdxs;
            testClipFiles    = allClipFiles(testClipLogIdxs);
            
            trainClipFeats{1, 1} = allClipFeats{1, 1}(trainClipLogIdxs, :);
            trainClipFeats{1, 2} = allClipFeats{1, 2}(trainClipLogIdxs, :);
            trainClipLabels      = allClipLabels(trainClipLogIdxs);
            testClipFeats{1, 1}  = allClipFeats{1, 1}(testClipLogIdxs, :);
            testClipFeats{1, 2}  = allClipFeats{1, 2}(testClipLogIdxs, :);
            testClipLabels       = allClipLabels(testClipLogIdxs);
            
            totalNumClipTest = totalNumClipTest + length(testClipLabels);
            totalNumImgTest  = totalNumImgTest  + length(testImgIdxs);
            
            if ( options.runINTERACTInstExpTrain ~= 0 )
                
                trainImgDuplicateIdxs = allImgIdxs(trainClipLabels);
                
                for idxMap = 1:numMapMethods
                    mapMethod = parameters.mapMethods(idxMap);
                    mapMethodName = parameters.mapMethodsNames{mapMethod};
                    

                    yToX = parameters.yToX;
                    
                    detMethodIdxPP   = parameters.detMethods( strcmp(parameters.detMethodsNames, 'PP'));
                    detMethodIdxYR   = parameters.detMethods( strcmp(parameters.detMethodsNames, 'YR'));
                    detMethodIdxYRBB = parameters.detMethods( strcmp(parameters.detMethodsNames, 'YR-BB'));
                    
                    for idxDet = 1:numDetMethods
                        detMethod        = parameters.detMethods(idxDet);
                        detMethodName    = parameters.detMethodsNames{detMethod};
                        
                        curName = sprintf('%10s', sprintf('%s-%s', detMethodName, mapMethodName));
                        
                        for idxGRNNMeth = 1:numGRNNMethods
                            trainGRNNMethod     = parameters.trainGRNNMethods(idxGRNNMeth);
                            trainGRNNMethodName = parameters.trainGRNNMethodsNames{trainGRNNMethod};
                            
                            skipThisMethod = 1;
                            randNNMatching = 0;
                            trainImgIdxs    = allImgIdxs(trainImgLogIdxs);
                            trainClipLabels = allClipLabels(trainClipLogIdxs);
                            testImgIdxs     = allImgIdxs(testImgLogIdxs);
                            testClipLabels  = allClipLabels(testClipLogIdxs);
                            
                            if ( strcmp(mapMethodName, 'None') )
                                if ( strcmp(trainGRNNMethodName, 'self') )
                                    
                                    trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                    trainClipFeatsForExp  = trainClipFeats{1, 1};
                                    testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                    testClipFeats1ForExp  = testClipFeats{1, 1};
                                    testClipFeats2ForExp  = testClipFeats{1, 2};
                                    
                                    if ( testingNewTrainMethod )
                                        saveString = sprintf(['touch ', [options.saveModelZSLInstFormatStr, sprintf('_randTrainSplit_%03d', curSeedValForTrain)], '.mat'], ...
                                            options.classificationModelFileInst, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                        system(saveString);
                                    else
                                        [predIdxsC2R, predIdxsR2C, isOrd1] = NearestNeighborMatching(testImgFeatsForExp, testClipFeats1ForExp, testClipFeats2ForExp);
                                        [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                                        fprintf('%s  ZSL: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                                        [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
                                        %       fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);
                                        saveString = sprintf(['save ', [options.saveModelZSLInstFormatStr, sprintf('_randTrainSplit_%03d', curSeedValForTrain)], '.mat predIdxsC2R predIdxsR2C ' ...
                                            'trainImgFeatsForExp trainClipFeatsForExp testImgFeatsForExp testClipFeats1ForExp testClipFeats2ForExp testImgIdxs testClipLabels isOrd1'], ...
                                            options.classificationModelFileInst, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                        eval(saveString);
                                    end

                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(mapMethodName, 'GRNN') )
                                if ( strcmp(trainGRNNMethodName, 'PP') )
                                    if ( ~strcmp(detMethodName, 'PP') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxPP, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(trainGRNNMethodName, 'self') )
                                    trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                    trainClipFeatsForExp  = trainClipFeats{1, 1};
                                    testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                    testClipFeats1ForExp  = testClipFeats{1, 1};
                                    testClipFeats2ForExp  = testClipFeats{1, 2};
                                    skipThisMethod = 0;
                                elseif ( strcmp(trainGRNNMethodName, 'swap') )
                                    if ( strcmp(detMethodName, 'YR') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxYRBB, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        skipThisMethod = 0;
                                    elseif ( strcmp(detMethodName, 'YR-BB') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxYR, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(trainGRNNMethodName, 'self-rand') )
                                    if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                        selfRandSeed = RandStream('mt19937ar','Seed', curSeedValForTrain + detMethod); % Trying to make it more consistent between different sessions
                                        randOrder = randi(selfRandSeed, [1, 2], length(trainImgDuplicateIdxs), 1);
                                        trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1}.*(repmat(randOrder, 1, curNumFeatures)==1) + trainClipFeats{1, 2}.*(repmat(randOrder, 1, curNumFeatures)==2);
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(trainGRNNMethodName, 'swap-rand') )
                                    selfRandSeed = RandStream('mt19937ar','Seed', curSeedValForTrain + detMethod); % Trying to make it more consistent between different sessions
                                    randOrder = randi(selfRandSeed, [1, 2], length(trainImgDuplicateIdxs), 1);
                                    if ( strcmp(detMethodName, 'YR') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxYRBB, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1}.*(repmat(randOrder, 1, curNumFeatures)==1) + trainClipFeats{1, 2}.*(repmat(randOrder, 1, curNumFeatures)==2);
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        skipThisMethod = 0;
                                    elseif ( strcmp(detMethodName, 'YR-BB') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxYR, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1}.*(repmat(randOrder, 1, curNumFeatures)==1) + trainClipFeats{1, 2}.*(repmat(randOrder, 1, curNumFeatures)==2);
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end   
                                elseif ( strcmp(trainGRNNMethodName, 'train-rand') )
                                    trainRandSeed = RandStream('mt19937ar','Seed', curSeedValForTrain + detMethod); % Trying to make it more consistent between different sessions
                                    trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                    trainClipFeatsForExp  = rand(trainRandSeed, size(trainClipFeats{1,1}));
                                    testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                    testClipFeats1ForExp  = testClipFeats{1, 1};
                                    testClipFeats2ForExp  = testClipFeats{1, 2};
                                    skipThisMethod = 0;          
                                elseif ( strcmp(trainGRNNMethodName, 'self-test-rand') )
                                    if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                        testRandSeed = RandStream('mt19937ar','Seed', curSeedValForTrain + detMethod); % Trying to make it more consistent between different sessions
                                        trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = rand(testRandSeed, size(testClipFeats{1, 1}));
                                        testClipFeats2ForExp  = rand(testRandSeed, size(testClipFeats{1, 2}));
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(trainGRNNMethodName, 'rand-NN') )
                                    if ( strcmp(detMethodName, 'PP') )
                                        trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = testImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = testClipFeats{1, 1};
                                        testClipFeats2ForExp  = testClipFeats{1, 2};
                                        randNNMatching = 1;
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(trainGRNNMethodName, 'test-on-train') )
                                    trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                    trainClipFeatsForExp  = trainClipFeats{1, 1};
                                    testImgFeatsForExp    = trainImgFeats{idxDet, 1};
                                    testClipFeats1ForExp  = trainClipFeats{1, 1};
                                    testClipFeats2ForExp  = trainClipFeats{1, 2};
                                    
                                    trainImgIdxs    = allImgIdxs(trainImgLogIdxs);
                                    trainClipLabels = allClipLabels(trainClipLogIdxs);
                                    testImgIdxs     = allImgIdxs(trainImgLogIdxs);
                                    testClipLabels  = allClipLabels(trainClipLogIdxs);
                                    skipThisMethod = 0;
                                elseif ( strcmp(trainGRNNMethodName, 'test-on-train-swap') )
                                    if ( strcmp(detMethodName, 'YR') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxYRBB, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = trainImgFeats{detMethodIdxYR, 1};
                                        testClipFeats1ForExp  = trainClipFeats{1, 1};
                                        testClipFeats2ForExp  = trainClipFeats{1, 2};
                                        
                                        trainImgIdxs    = allImgIdxs(trainImgLogIdxs);
                                        trainClipLabels = allClipLabels(trainClipLogIdxs);
                                        testImgIdxs     = allImgIdxs(trainImgLogIdxs);
                                        testClipLabels  = allClipLabels(trainClipLogIdxs);
                                        skipThisMethod = 0;
                                    elseif ( strcmp(detMethodName, 'YR-BB') )
                                        trainImgFeatsForExp   = allImgFeats{detMethodIdxYR, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = trainImgFeats{detMethodIdxYRBB, 1};
                                        testClipFeats1ForExp  = trainClipFeats{1, 1};
                                        testClipFeats2ForExp  = trainClipFeats{1, 2};
                                        
                                        trainImgIdxs    = allImgIdxs(trainImgLogIdxs);
                                        trainClipLabels = allClipLabels(trainClipLogIdxs);
                                        testImgIdxs     = allImgIdxs(trainImgLogIdxs);
                                        testClipLabels  = allClipLabels(trainClipLogIdxs);
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(trainGRNNMethodName, 'rand-NN-train') )
                                    if ( strcmp(detMethodName, 'PP') )
                                        trainImgFeatsForExp   = allImgFeats{idxDet, 1}(trainImgDuplicateIdxs, :);
                                        trainClipFeatsForExp  = trainClipFeats{1, 1};
                                        testImgFeatsForExp    = trainImgFeats{idxDet, 1};
                                        testClipFeats1ForExp  = trainClipFeats{1, 1};
                                        testClipFeats2ForExp  = trainClipFeats{1, 2};
                                        
                                        trainImgIdxs    = allImgIdxs(trainImgLogIdxs);
                                        trainClipLabels = allClipLabels(trainClipLogIdxs);
                                        testImgIdxs     = allImgIdxs(trainImgLogIdxs);
                                        testClipLabels  = allClipLabels(trainClipLogIdxs);
                                        
                                        randNNMatching = 1;
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                end
                                
                                if ( ~skipThisMethod )
                                    if ( testingNewTrainMethod )
                                        saveString = sprintf(['touch ', [options.saveModelZSLInstFormatStr, sprintf('_randTrainSplit_%03d', curSeedValForTrain)], '.mat'], ...
                                            options.classificationModelFileInst, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                        system(saveString);
                                    else
                                        if ( randNNMatching )
                                            randNNSeed = RandStream('mt19937ar','Seed', curSeedValForTrain + detMethodIdxPP); % Trying to make it more consistent between different sessions
                                            [predIdxsC2R, predIdxsR2C, isOrd1] = RandNearestNeighborMatching(randNNSeed, testImgFeatsForExp, testClipFeats1ForExp, testClipFeats2ForExp);
                                            testClipFeats1AsReal = testClipFeats1ForExp;
                                            testClipFeats2AsReal = testClipFeats2ForExp;
                                            nNet = [];
                                            
                                            [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                                            fprintf('rand-NN ZSL: [%05.3f, %05.3f, %05.3f]\n', rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                                            [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
                                            %                         fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);
                                        else
                                            [nNet, predIdxsC2R, predIdxsR2C, isOrd1, testClipFeats1AsReal, testClipFeats2AsReal] = ...
                                                GRNN(options, parameters, yToX, spread, ...
                                                trainImgFeatsForExp, trainClipFeatsForExp,...
                                                testImgFeatsForExp, testClipFeats1ForExp, testClipFeats2ForExp);
                                            
                                            [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                                            fprintf('%s  ZSL: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                                            [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
                                            %                         fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);
                                        end
                                        saveString = sprintf(['save ', [options.saveModelZSLInstFormatStr, sprintf('_randTrainSplit_%03d', curSeedValForTrain)], '.mat nNet predIdxsC2R predIdxsR2C ' ...
                                            'trainImgFeatsForExp trainClipFeatsForExp testImgFeatsForExp testClipFeats1AsReal testClipFeats2AsReal testImgIdxs testClipLabels isOrd1'], ...
                                            options.classificationModelFileInst, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                        eval(saveString);
                                    end
                                end
                            end
                            
                            if ( ~skipThisMethod )
                                if ( ~testingNewTrainMethod )
                                    
                                    rankMeanAvgZSL(idxDet, idxMap, idxGRNNMeth)     = rankMeanAvgZSL(idxDet, idxMap, idxGRNNMeth)              + rankMeanZSL;
                                    rankMedianAvgZSL(idxDet, idxMap, idxGRNNMeth)   = rankMedianAvgZSL(idxDet, idxMap, idxGRNNMeth)            + rankMedianZSL;
                                    recallAt1AvgZSL(idxDet, idxMap, idxGRNNMeth)    = recallAt1AvgZSL(idxDet, idxMap, idxGRNNMeth)             + recallAt1ZSL;
                                    recallAtKAvgZSL(idxDet, idxMap, idxGRNNMeth, :) = squeeze(recallAtKAvgZSL(idxDet, idxMap, idxGRNNMeth, :)) + recallAtKZSL';
                                    
                                    rankMeanAvgSBIR(idxDet, idxMap, idxGRNNMeth)     = rankMeanAvgSBIR(idxDet, idxMap, idxGRNNMeth)              + rankMeanSBIR;
                                    rankMedianAvgSBIR(idxDet, idxMap, idxGRNNMeth)   = rankMedianAvgSBIR(idxDet, idxMap, idxGRNNMeth)            + rankMedianSBIR;
                                    recallAt1AvgSBIR(idxDet, idxMap, idxGRNNMeth)    = recallAt1AvgSBIR(idxDet, idxMap, idxGRNNMeth)             + recallAt1SBIR;
                                    recallAtKAvgSBIR(idxDet, idxMap, idxGRNNMeth, :) = squeeze(recallAtKAvgSBIR(idxDet, idxMap, idxGRNNMeth, :)) + recallAtKSBIR';
                                end
                            end
                        end
                    end
                end
                
            else
                if ( recomputingAccuracyFile )
                    for idxMap = 1:numMapMethods
                        mapMethod = parameters.mapMethods(idxMap);
                        mapMethodName = parameters.mapMethodsNames{mapMethod};
                        
                        spread = parameters.spread;
                        yToX = parameters.yToX;
                        
                        detMethodIdxPP   = parameters.detMethods( strcmp(parameters.detMethodsNames, 'PP'));
                        detMethodIdxYR   = parameters.detMethods( strcmp(parameters.detMethodsNames, 'YR'));
                        detMethodIdxYRBB = parameters.detMethods( strcmp(parameters.detMethodsNames, 'YR-BB'));
                        
                        for idxDet = 1:numDetMethods
                            detMethod        = parameters.detMethods(idxDet);
                            detMethodName    = parameters.detMethodsNames{detMethod};
                            
                            curName = sprintf('%10s', sprintf('%s-%s', detMethodName, mapMethodName));
                            
                            for idxGRNNMeth = 1:numGRNNMethods
                                trainGRNNMethod     = parameters.trainGRNNMethods(idxGRNNMeth);
                                trainGRNNMethodName = parameters.trainGRNNMethodsNames{trainGRNNMethod};
                                
                                if ( strcmp(mapMethodName, 'None') )
                                    if ( strcmp(trainGRNNMethodName, 'self') )
                                        
                                        loadString = sprintf(['load ', [options.saveModelZSLInstFormatStr, sprintf('_randTrainSplit_%03d', curSeedValForTrain)], '.mat'], ...
                                            options.classificationModelFileInst, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                        eval(loadString);
                                        
                                        [predIdxsC2R, predIdxsR2C, isOrd1] = NearestNeighborMatching(testImgFeatsForExp, testClipFeats1ForExp, testClipFeats2ForExp);
                                        [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                                        fprintf('%s  ZSL: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                                        [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
                                        %                         fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);
                                        
                                        skipThisMethod = 0;
                                    else
                                        skipThisMethod = 1;
                                    end
                                elseif ( strcmp(mapMethodName, 'GRNN') )
                                    if ( strcmp(trainGRNNMethodName, 'PP') )
                                        if ( ~strcmp(detMethodName, 'PP') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'self') )
                                        skipThisMethod = 0;
                                    elseif ( strcmp(trainGRNNMethodName, 'swap') )
                                        if ( strcmp(detMethodName, 'YR') )
                                            skipThisMethod = 0;
                                        elseif ( strcmp(detMethodName, 'YR-BB') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'self-rand') )
                                        if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'swap-rand') )
                                        if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'train-rand') )
                                        skipThisMethod = 0;
                                    elseif ( strcmp(trainGRNNMethodName, 'self-test-rand') )
                                        if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'rand-NN') )
                                        if ( strcmp(detMethodName, 'PP') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'test-on-train') )
                                        skipThisMethod = 0;
                                    elseif ( strcmp(trainGRNNMethodName, 'test-on-train-swap') )
                                        if ( strcmp(detMethodName, 'YR') )
                                            skipThisMethod = 0;
                                        elseif ( strcmp(detMethodName, 'YR-BB') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    elseif ( strcmp(trainGRNNMethodName, 'rand-NN-train') )
                                        if ( strcmp(detMethodName, 'PP') )
                                            skipThisMethod = 0;
                                        else
                                            skipThisMethod = 1;
                                        end
                                    end
                                end
                                
                                if ( ~skipThisMethod )
                                    
                                    loadString = sprintf(['load ', [options.saveModelZSLInstFormatStr, sprintf('_randTrainSplit_%03d', curSeedValForTrain)], '.mat'], ...
                                        options.classificationModelFileInst, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                    eval(loadString);
                                    
                                    [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                                    fprintf('%s  ZSL: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                                    [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
                                    %                         fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);
                                end
                                
                                
                                if ( ~skipThisMethod )
                                    
                                    rankMeanAvgZSL(idxDet, idxMap, idxGRNNMeth)     = rankMeanAvgZSL(idxDet, idxMap, idxGRNNMeth)              + rankMeanZSL;
                                    rankMedianAvgZSL(idxDet, idxMap, idxGRNNMeth)   = rankMedianAvgZSL(idxDet, idxMap, idxGRNNMeth)            + rankMedianZSL;
                                    recallAt1AvgZSL(idxDet, idxMap, idxGRNNMeth)    = recallAt1AvgZSL(idxDet, idxMap, idxGRNNMeth)             + recallAt1ZSL;
                                    recallAtKAvgZSL(idxDet, idxMap, idxGRNNMeth, :) = squeeze(recallAtKAvgZSL(idxDet, idxMap, idxGRNNMeth, :)) + recallAtKZSL';
                                    
                                    rankMeanAvgSBIR(idxDet, idxMap, idxGRNNMeth)     = rankMeanAvgSBIR(idxDet, idxMap, idxGRNNMeth)              + rankMeanSBIR;
                                    rankMedianAvgSBIR(idxDet, idxMap, idxGRNNMeth)   = rankMedianAvgSBIR(idxDet, idxMap, idxGRNNMeth)            + rankMedianSBIR;
                                    recallAt1AvgSBIR(idxDet, idxMap, idxGRNNMeth)    = recallAt1AvgSBIR(idxDet, idxMap, idxGRNNMeth)             + recallAt1SBIR;
                                    recallAtKAvgSBIR(idxDet, idxMap, idxGRNNMeth, :) = squeeze(recallAtKAvgSBIR(idxDet, idxMap, idxGRNNMeth, :)) + recallAtKSBIR';
                                end
                            end
                        end
                    end
                end
            end
        end
        fprintf('\n');
        
        if ( (options.runINTERACTInstExpTrain ~= 0) || recomputingAccuracyFile)
            for idxMap = 1:numMapMethods
                mapMethod = parameters.mapMethods(idxMap);
                mapMethodName = parameters.mapMethodsNames{mapMethod};
                
                for idxDet = 1:numDetMethods
                    detMethod     = parameters.detMethods(idxDet);
                    detMethodName = parameters.detMethodsNames{detMethod};
                    
                    for idxGRNNMeth = 1:numGRNNMethods
                        trainGRNNMethod     = parameters.trainGRNNMethods(idxGRNNMeth);
                        trainGRNNMethodName = parameters.trainGRNNMethodsNames{trainGRNNMethod};
                        
                        if ( strcmp(mapMethodName, 'None') )
                            if ( strcmp(trainGRNNMethodName, 'self') )
                                skipThisMethod = 0;
                            else
                                skipThisMethod = 1;
                            end
                        elseif ( strcmp(mapMethodName, 'GRNN') )
                            if ( strcmp(trainGRNNMethodName, 'PP') )
                                if ( ~strcmp(detMethodName, 'PP') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'self') )
                                skipThisMethod = 0;
                            elseif ( strcmp(trainGRNNMethodName, 'swap') )
                                if ( strcmp(detMethodName, 'YR') )
                                    skipThisMethod = 0;
                                elseif ( strcmp(detMethodName, 'YR-BB') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'self-rand') )
                                if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'swap-rand') )
                                if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'train-rand') )
                                skipThisMethod = 0;
                            elseif ( strcmp(trainGRNNMethodName, 'self-test-rand') )
                                if ( strcmp(detMethodName, 'YR') || strcmp(detMethodName, 'YR-BB') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'rand-NN') )
                                if ( strcmp(detMethodName, 'PP') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'test-on-train') )
                                skipThisMethod = 0;
                            elseif ( strcmp(trainGRNNMethodName, 'test-on-train-swap') )
                                if ( strcmp(detMethodName, 'YR') )
                                    skipThisMethod = 0;
                                elseif ( strcmp(detMethodName, 'YR-BB') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            elseif ( strcmp(trainGRNNMethodName, 'rand-NN-train') )
                                if ( strcmp(detMethodName, 'PP') )
                                    skipThisMethod = 0;
                                else
                                    skipThisMethod = 1;
                                end
                            end
                        end
                        
                        if ( ~skipThisMethod )
                            numRandSplits = numRandTrainSplits;
                            
                            avgZSLData = [];
                            avgZSLData.featsToUse    = featsToUse;
                            avgZSLData.numRandSplits = numRandSplits;
                            avgZSLData.detMethod     = parameters.detMethods(idxDet);
                            avgZSLData.mapMethod     = parameters.mapMethods(idxMap);
                            avgZSLData.trainGRNNMethod = parameters.trainGRNNMethods(idxGRNNMeth);
                            avgZSLData.rankMean      = rankMeanAvgZSL(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                            avgZSLData.rankMedian    = rankMedianAvgZSL(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                            avgZSLData.recallAt1     = recallAt1AvgZSL(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                            avgZSLData.recallAt1Ranks= totalNumClipTest/numRandSplits;
                            avgZSLData.recallAtK     = squeeze(recallAtKAvgZSL(idxDet, idxMap, idxGRNNMeth, :)/numRandSplits);
                            
                            avgSBIRData = [];
                            avgSBIRData.featsToUse    = featsToUse;
                            avgSBIRData.numRandSplits = numRandSplits;
                            avgSBIRData.detMethod     = parameters.detMethods(idxDet);
                            avgSBIRData.mapMethod     = parameters.mapMethods(idxMap);
                            avgSBIRData.trainGRNNMethod = parameters.trainGRNNMethods(idxGRNNMeth);
                            avgSBIRData.rankMean      = rankMeanAvgSBIR(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                            avgSBIRData.rankMedian    = rankMedianAvgSBIR(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                            avgSBIRData.recallAt1     = recallAt1AvgSBIR(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                            avgSBIRData.recallAt1Ranks= totalNumImgTest/numRandSplits;
                            avgSBIRData.recallAtK     = squeeze(recallAtKAvgSBIR(idxDet, idxMap, idxGRNNMeth, :)/numRandSplits);
                            
                            if ( (options.runINTERACTInstExpTrain ~= 0) || recomputingAccuracyFile )
%                             if ( 1 )
                                dataFilename = sprintf(options.saveAccuraciesZSLInstFormatStr, ...
                                    options.classificationAccuraciesFile, datasetNum, parameters.featsStr, spread, mapMethod, trainGRNNMethod, detMethod);
                                save([dataFilename, '.mat'], 'avgZSLData', 'avgSBIRData');
                            end
                        end
                    end
                end
            end
        end
    end
end

if ( options.runINTERACTInstExpAccPlot ~= 0 )
    %      ClassificationInstanceAccuracyPlot(options, parameters, datasetNum);
%     ClassificationInstanceAccuracyPlotNew(options, parameters, datasetNum);
    ClassificationInstanceAccuracyPlotNewSpreads(options, parameters, datasetNum);
end

% @TODO
if ( options.runINTERACTInstExpQual ~= 0 )
    
    for nRS = 1:numRandTrainSplits
        
        curSeedValForTrain = parameters.seedVal + nRS;
        
        [idxCorrectClipartCell, testImgFeats, testClipFeats1, testClipFeats2] = FirstClipartIdxsAndCorrectness(options, parameters, datasetNum, curSeedValForTrain);
        
        [idxToInspect, clipFiles1, clipFiles2] = FinalImgListINTERACT(options, parameters, idxCorrectClipartCell);
        idxToInspectImg = find(idxToInspect);
        
        clipartInstanceFolder = fullfile(options.foldersLocal{options.idxINTERACTClipInstColl}{options.idxDataOutput}, 'rendered_illustrations');
        clipartInstanceFolder = '../../../pose_clipart/data/output/retrieval_clipart/full_exp_1/renderedImgs';
        
        %     clipartCorrectFiles = testClipFiles(clipFiles2(idxToInspect, 1));
        imgCorrectFiles     = testImgFiles(idxToInspect);
        hairColors = { 'blonde', 'brown' };
        titleSize = 30;
        featSize1 = 1;
        featSize2 = 20;
        set(0, 'DefaultAxesFontSize', titleSize);
        for i = 1:length(idxToInspectImg)
            
            subplot(2,6,1);
            OverlayPoseOnImg(options, options.folderINTERACTImgs, allImgFiles{ testClipLabels(clipFiles2(i, 1)) }, allImgPoses{1, 1}(testClipLabels(clipFiles2(i, 1)), :));
            title(sprintf('(%d, %d)\nYRBB Poses', nRS, i), 'FontSize', titleSize);
            
            subplot(2,6,7);
            OverlayPoseOnImg(options, options.folderINTERACTImgs, allImgFiles{ testClipLabels(clipFiles2(i, 1)) }, allImgPoses{1, 1}(testClipLabels(clipFiles2(i, 1)), :));
            title('YR Poses', 'FontSize', titleSize);
            
            subplot(2,6,2);
            imagesc(255*repmat(allImgFeats{3,1}(testClipLabels(clipFiles1(i, 1)), :)', featSize1, featSize2));
            title('YRBB Img');
            %             axis image;
            
            subplot(2,6,8);
            imagesc(255*repmat(allImgFeats{2,1}(testClipLabels(clipFiles2(i, 1)), :)', featSize1, featSize2));
            title('YR Img');
            %             axis image;
            
            subplot(2,6,3);
            if ( clipFiles1(i, 2) == 1 )
                imagesc(255*repmat(testClipFeats1{3,1,2}(clipFiles1(i, 1), :)', featSize1, featSize2));
            elseif ( clipFiles1(i, 2) == 2 )
                imagesc(255*repmat(testClipFeats2{3,1,2}(clipFiles1(i, 1), :)', featSize1, featSize2));
            end
            title('YRBB Clipart');
            %             axis image;
            
            subplot(2,6,9);
            if ( clipFiles2(i, 2) == 1 )
                imagesc(255*repmat(testClipFeats1{2,1,2}(clipFiles2(i, 1), :)', featSize1, featSize2));
            elseif ( clipFiles2(i, 2) == 2 )
                imagesc(255*repmat(testClipFeats2{2,1,2}(clipFiles2(i, 1), :)', featSize1, featSize2));
            end
            title('YR Clipart');
            %             axis image;
            
            subplot(2,6,4);
            if ( clipFiles1(i, 2) == 1 )
                imagesc(255*repmat(testClipFeats1{3,2,1}(clipFiles1(i, 1), :)', featSize1, featSize2));
            elseif ( clipFiles1(i, 2) == 2 )
                imagesc(255*repmat(testClipFeats2{3,2,1}(clipFiles1(i, 1), :)', featSize1, featSize2));
            end
            title('YRBB-GRNN-PP Clipart');
            %             axis image;
            
            subplot(2,6,10);
            if ( clipFiles2(i, 2) == 1 )
                imagesc(255*repmat(testClipFeats1{2,2,1}(clipFiles2(i, 1), :)', featSize1, featSize2));
            elseif ( clipFiles2(i, 2) == 2 )
                imagesc(255*repmat(testClipFeats2{2,2,1}(clipFiles2(i, 1), :)', featSize1, featSize2));
            end
            title('YR-GRNN-PP Clipart');
            %             axis image;
            
            subplot(2,6,5);
            if ( clipFiles1(i, 2) == 1 )
                imagesc(255*repmat(testClipFeats1{1,1,2}(clipFiles1(i, 1), :)', featSize1, featSize2));
            elseif ( clipFiles1(i, 2) == 2 )
                imagesc(255*repmat(testClipFeats2{1,1,2}(clipFiles1(i, 1), :)', featSize1, featSize2));
            end
            title('YRBB-GRNN-YRBB Clipart');
            %             axis image;
            
            subplot(2,6,11);
            if ( clipFiles2(i, 2) == 1 )
                imagesc(255*repmat(testClipFeats1{1,2,2}(clipFiles2(i, 1), :)', featSize1, featSize2));
            elseif ( clipFiles2(i, 2) == 2 )
                imagesc(255*repmat(testClipFeats2{1,2,2}(clipFiles2(i, 1), :)', featSize1, featSize2));
            end
            title('YR-GRNN-YR Clipart');
            %             axis image;
            
            subplot(2,6,6)
            imshow( fullfile(clipartInstanceFolder, testClipFiles{clipFiles1(i, 1)}) );
            title(sprintf('YRBB (%s-haired person is red.)', hairColors{clipFiles1(i, 2)}), 'FontSize', titleSize);
            
            subplot(2,6,12)
            imshow( fullfile(clipartInstanceFolder, testClipFiles{clipFiles2(i, 1)}) );
            title(sprintf('YR (%s-haired person is red.)', hairColors{clipFiles2(i, 2)}), 'FontSize', titleSize);
            drawnow;
            
            saveas(gcf, fullfile(options.foldersLocal{options.idxExperiments}{options.idxDataOutput}, 'plots', sprintf('interact_instance_qual_randIdx_%d_img_%d', nRS, i)), 'png');
            pause(.01);
            
        end
    end
end