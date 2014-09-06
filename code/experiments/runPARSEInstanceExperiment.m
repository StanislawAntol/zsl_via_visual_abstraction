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

% function runPARSEInstanceExperiment

datasetNum = 1;
%     options.whichData = [ 1 2 3 4 5];
options.whichData = [6 7 8 9];
for i = 1:length(options.whichData)
    load(options.classificationDataFile{options.whichData(i)});
end

allPARSEImgIdxs = 1:length(allPARSEImgGTLabels);

uniqueImgLabels = unique(allPARSEImgGTLabels);
numUniqueImgLabels = length(uniqueImgLabels);

numFeatSets = length(parameters.featSets);
numDetMethods = length(parameters.detMethods);
numMapMethods = length(parameters.mapMethods);
numGRNNMethods = length(parameters.trainGRNNMethods);

for nFt = 1:numFeatSets
    featsToUse = parameters.featSets{nFt};
    featsStr = strrep(num2str(featsToUse), '  ', '_');
    
    allImgFiles = allPARSEImgGTImgFilename;
    allPARSEImgGTLabelsFinal = dlmread(options.filePARSECategorizationFinal);
    allImgIdxs = [1:length(allPARSEImgGTLabelsFinal)]';
    % Image Features
    trainImgLogIdxs = (allPARSEImgGTLabelsFinal == 0) | (allPARSEImgGTLabelsFinal >= 15);
    testImgLogIdxs  = ~trainImgLogIdxs;
    for nDetMethods = 1:numDetMethods
        if ( nDetMethods == 1)
            allImgFeats{nDetMethods, 1} = cell2mat(allPARSEImgGTFeatures(featsToUse, 1)');
            allImgPoses{nDetMethods, 1} = cell2mat(allPARSEImgGTFeatures(8, 1)');
        elseif (nDetMethods == 2)
            allImgFeats{nDetMethods, 1} = cell2mat(allPARSEImgYRDFeatures(featsToUse, 1)');
            allImgPoses{nDetMethods, 1} = cell2mat(allPARSEImgYRDFeatures(8, 1)');
        end
        allImgLabels{nDetMethods}   = allPARSEImgGTLabels;
        trainImgFeats{nDetMethods, 1} = allImgFeats{nDetMethods, 1}(trainImgLogIdxs, :);
        trainImgLabels{nDetMethods} = allImgLabels{nDetMethods}(trainImgLogIdxs);
        trainImgIdxs = allImgIdxs(trainImgLogIdxs);
        testImgFeats{nDetMethods, 1}  = allImgFeats{nDetMethods, 1}(testImgLogIdxs, :);
        testImgLabels{nDetMethods} = allImgLabels{nDetMethods}(testImgLogIdxs);
        testImgIdxs = allImgIdxs(testImgLogIdxs);
        testImgFiles = allPARSEImgGTImgFilename(testImgLogIdxs);
        testImgPoses{nDetMethods, 1}  = allImgPoses{nDetMethods, 1}(testImgLogIdxs, :);
    end
    
    % Clipart Instance Features
    allClipFeats{1} = cell2mat(allPARSEClipInstFeatures(featsToUse, 1)');
    allClipLabels = allPARSEClipInstLabels;
    allClipFiles = allPARSEClipInstImgFilename;
    
    % Assumes PARSE imgs are in order
    trainClipLogIdxs = ismember(allClipLabels, find(trainImgLogIdxs));
    testClipLogIdxs  = ~trainClipLogIdxs;
    testClipFiles    = allClipFiles(testClipLogIdxs);
    
    trainClipFeats{1} = allClipFeats{1}(trainClipLogIdxs, :);
    trainClipLabels   = allClipLabels(trainClipLogIdxs);
    testClipFeats{1}  = allClipFeats{1}(testClipLogIdxs, :);
    testClipLabels    = allClipLabels(testClipLogIdxs); 
        
    recallAtKNumDivs = parameters.recallAtKNumDivs;
        
    if ( options.runPARSEInstExpTrain ~= 0 )
        rankMeanAvgZSL   = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        rankMedianAvgZSL = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAt1AvgZSL  = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAtKAvgZSL  = zeros(numDetMethods, numMapMethods, numGRNNMethods, recallAtKNumDivs);
        
        rankMeanAvgSBIR   = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        rankMedianAvgSBIR = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAt1AvgSBIR  = zeros(numDetMethods, numMapMethods, numGRNNMethods);
        recallAtKAvgSBIR  = zeros(numDetMethods, numMapMethods, numGRNNMethods, recallAtKNumDivs);
        
        trainImgDuplicateIdxs = allImgIdxs(trainClipLabels);
        
        for idxMap = 1:numMapMethods
            mapMethod = parameters.mapMethods(idxMap);
            mapMethodName = parameters.mapMethodsNames{mapMethod};
            
            spread = parameters.spread;
            yToX = parameters.yToX;
            
            for idxDet = 1:numDetMethods
                detMethod     = parameters.detMethods(idxDet);
                detMethodName = parameters.detMethodsNames{detMethod};
                
                curName = sprintf('%10s', sprintf('%s-%s', detMethodName, mapMethodName));
                
                for idxGRNNMeth = 1:numGRNNMethods
                    trainGRNNMethod     = parameters.trainGRNNMethods(idxGRNNMeth);
                    trainGRNNMethodName = parameters.trainGRNNMethodsNames{idxGRNNMeth};
                    
                    if ( strcmp(mapMethodName, 'None') )
                        if ( strcmp(trainGRNNMethodName, 'self') )
                            
                            trainImgFeatsForExp  = allImgFeats{idxDet}(trainImgDuplicateIdxs, :);
                            trainClipFeatsForExp = trainClipFeats{1};
                            testImgFeatsForExp   = testImgFeats{idxDet};
                            testClipFeatsForExp  = testClipFeats{1};
                            
                            [predIdxsC2R, predIdxsR2C, isOrd1] = NearestNeighborMatching(testImgFeatsForExp, testClipFeatsForExp);
                            [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                            fprintf('%s  ZSL: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                            [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
                            %                         fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);
                            
                            saveString = sprintf(['save ', options.saveModelZSLInstFormatStr, '.mat predIdxsC2R predIdxsR2C ' ...
                                'trainImgFeatsForExp trainClipFeatsForExp testImgFeatsForExp testClipFeatsForExp testImgIdxs testClipLabels'], ...
                                options.classificationModelFileInst, datasetNum, parameters.featsStr, detMethod, mapMethod, trainGRNNMethod);
                            eval(saveString);
                        elseif ( strcmp(trainGRNNMethodName, 'PP') )
                            rankMeanZSL  = -1; rankMedianZSL  = -1; recallAt1ZSL  = -1; recallAtKZSL  = -1*ones(1, recallAtKNumDivs);
                            rankMeanSBIR = -1; rankMedianSBIR = -1; recallAt1SBIR = -1; recallAtKSBIR = -1*ones(1, recallAtKNumDivs);
                        end
                    elseif ( strcmp(mapMethodName, 'GRNN') )
                        
                        if ( strcmp(trainGRNNMethodName, 'PP') )
                            detMethodIdxPP = parameters.detMethods( strcmp(parameters.detMethodsNames, 'PP'));
                            trainImgFeatsForExp  = allImgFeats{detMethodIdxPP}(trainImgDuplicateIdxs, :);
                            trainClipFeatsForExp = trainClipFeats{1};
                            testImgFeatsForExp   = testImgFeats{idxDet};
                            testClipFeatsForExp  = testClipFeats{1};
                        elseif ( strcmp(trainGRNNMethodName, 'self') )
                            trainImgFeatsForExp  = allImgFeats{idxDet}(trainImgDuplicateIdxs, :);
                            trainClipFeatsForExp = trainClipFeats{1};
                            testImgFeatsForExp   = testImgFeats{idxDet};
                            testClipFeatsForExp  = testClipFeats{1};
                        end
                        [nNet, predIdxsC2R, predIdxsR2C, isOrd1, testClipFeatsAsReal] = ...
                            GRNN(options, parameters, yToX, spread, ...
                            trainImgFeatsForExp, trainClipFeatsForExp,...
                            testImgFeatsForExp, testClipFeatsForExp);
      
                        [rankMeanZSL, rankMedianZSL, recallAt1ZSL, recallAtKZSL] = ComputeAccuracyInstanceMetrics(predIdxsR2C, testImgIdxs, testClipLabels, recallAtKNumDivs);
                        fprintf('%s  ZSL: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanZSL, rankMedianZSL, recallAt1ZSL);
                        [rankMeanSBIR, rankMedianSBIR, recallAt1SBIR, recallAtKSBIR] = ComputeAccuracyInstanceMetrics(predIdxsC2R, testClipLabels, testImgIdxs, recallAtKNumDivs);
%                         fprintf('%s SBIR: [%05.3f, %05.3f, %05.3f]\n', curName, rankMeanSBIR, rankMedianSBIR, recallAt1SBIR);

                        saveString = sprintf(['save ', options.saveModelZSLInstFormatStr, '.mat nNet predIdxsC2R predIdxsR2C ' ...
                            'trainImgFeatsForExp trainClipFeatsForExp testImgFeatsForExp testClipFeatsForExp testClipFeatsAsReal testImgIdxs testClipLabels'], ...
                            options.classificationModelFileInst, datasetNum, parameters.featsStr, detMethod, mapMethod, trainGRNNMethod);
                        eval(saveString);
                    end
                    
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
        
        fprintf('\n');

        for idxMap = 1:numMapMethods
            mapMethod = parameters.mapMethods(idxMap);
            mapMethodName = parameters.mapMethodsNames{mapMethod};
            
            for idxDet = 1:numDetMethods
                detMethod     = parameters.detMethods(idxDet);
                detMethodName = parameters.detMethodsNames{detMethod};
                
                for idxGRNNMeth = 1:numGRNNMethods
                    trainGRNNMethod     = parameters.trainGRNNMethods(idxGRNNMeth);
                    trainGRNNMethodName = parameters.trainGRNNMethodsNames{idxGRNNMeth};
                    
                    numRandSplits = 1;
                    
                    avgZSLData = [];
                    avgZSLData.featsToUse    = featsToUse;
                    avgZSLData.numRandSplits = numRandSplits;
                    avgZSLData.detMethod     = parameters.detMethods(idxDet);
                    avgZSLData.mapMethod     = parameters.mapMethods(idxMap);
                    avgZSLData.trainGRNNMethod = parameters.trainGRNNMethods(idxGRNNMeth);
                    avgZSLData.rankMean      = rankMeanAvgZSL(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                    avgZSLData.rankMedian    = rankMedianAvgZSL(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                    avgZSLData.recallAt1     = recallAt1AvgZSL(idxDet, idxMap, idxGRNNMeth)/numRandSplits;
                    avgZSLData.recallAt1Ranks= length(testClipLabels);
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
                    avgSBIRData.recallAt1Ranks= length(testImgIdxs);
                    avgSBIRData.recallAtK     = squeeze(recallAtKAvgSBIR(idxDet, idxMap, idxGRNNMeth, :)/numRandSplits);
                    
                    dataFilename = sprintf(options.saveAccuraciesZSLInstFormatStr, ...
                        options.classificationAccuraciesFile, datasetNum, parameters.featsStr, detMethod, mapMethod, trainGRNNMethod);
                    save([dataFilename, '.mat'], 'avgZSLData', 'avgSBIRData');
                end
            end
        end
    end
end

if ( options.runPARSEInstExpAccPlot ~= 0 )
     ClassificationInstanceAccuracyPlot(options, parameters, datasetNum);
end
    
% @TODO
if ( options.runPARSEInstExpQual ~= 0 )
    
    idxCorrectClipartCell = FirstClipartIdxsAndCorrectness(options, parameters, datasetNum);
    
    [idxToInspect, clipFiles1, clipFiles2 ] = FinalImgListPARSE(options, parameters, idxCorrectClipartCell);
    idxToInspectImg = find(idxToInspect);
    clipartInstanceFolder = fullfile(options.foldersLocal{options.idxPARSEClipInstColl}{options.idxDataOutput}, 'rendered_illustrations');
    
    clipIdxs = idxCorrectClipartCell{2,2,2}(:, 2);
    clipartCorrectFiles = testClipFiles(clipIdxs(idxToInspect));
    imgCorrectFiles     = testImgFiles(idxToInspect);
    
    idxsToDup = zeros(size(idxToInspect, 1), 1);
    for idxClip = 1:size(idxToInspect, 1)
        idxsToDup(idxClip) = find( testClipLabels(idxClip) == testImgIdxs );
    end
    
    featSize1 = 1;
    featSize2 = 30;
    for i = 1:length(clipartCorrectFiles)
        subplot(2,4,1);
        %     imshow(fullfile(options.folderINTERACTImgs, imgCorrectFiles{1}));
%         OverlayPoseOnImg(options, options.folderYRPARSE, imgCorrectFiles{i}, testImgPoses{1}(idxToInspectImg(i), :));
        OverlayPoseOnImg(options, options.folderYRPARSE, allImgFiles{testClipLabels(clipFiles1(i))}, testImgPoses{2}(idxToInspectImg(i), :));
        subplot(2,4,2);
        image(255*repmat(testImgFeats{2}(idxToInspectImg(i), :)', featSize1, featSize2));
        axis image;
        subplot(2,4,4);
        %     imshow(fullfile(options.folderINTERACTImgs, imgCorrectFiles{1}));
        OverlayPoseOnImg(options, options.folderYRPARSE, imgCorrectFiles{i}, testImgPoses{2}(idxToInspectImg(i), :));
%         imshow(fullfile(options.folderYRPARSE, imgCorrectFiles{i}));
        subplot(2,4,3);
        image(255*repmat(testImgFeats{2}(idxToInspectImg(i), :)', featSize1, featSize2));
        axis image;
        subplot(2,4,5)
        imshow( fullfile(clipartInstanceFolder, testClipFiles{clipFiles1(i)}) );
        subplot(2,4,6);
        image(255*repmat(testClipFeats{1}(clipFiles1(i), :)', featSize1, featSize2));
        axis image;
        subplot(2,4,8)
        imshow( fullfile(clipartInstanceFolder, testClipFiles{clipFiles2(i)}) );
        subplot(2,4,7);
        image(255*repmat(testClipFeats{1}(clipFiles2(i), :)', featSize1, featSize2));
        axis image;
            pause();
    end
    
end