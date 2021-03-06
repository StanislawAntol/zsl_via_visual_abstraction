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

function ClassificationCategoryAccuracyPartPlot(options, parameters, accuraciesOverall, accuraciesAvgClass, datasetID, accuraciesOverallDAP, accuraciesAvgClassDAP)

if ( nargin <= 5 )
    accuraciesOverallDAP = 0;
    accuraciesAvgClassDAP = 0;
end

partThresholds = parameters.partThreshold;
featSetsToUse = parameters.featSets;
biases = parameters.biasTrain;
probs  = parameters.probTest;
trainOnKs = parameters.trainOnKs;
detMethods = parameters.detMethods;
detMethodNames = parameters.detMethodsNames;

numPartThresholds = length(partThresholds);
numFeatSets = length(featSetsToUse);
numBiases = length(biases);
numProbs = length(probs);
numTrainOnKs = length(trainOnKs);
numDetMethods = length(detMethods);

modelParams = parameters.Cs;
numModelParams = length(modelParams);

maxMPsOverall  = zeros(numPartThresholds, numFeatSets, numBiases, numProbs, numDetMethods, numTrainOnKs);
maxMPsAvgClass = zeros(numPartThresholds, numFeatSets, numBiases, numProbs, numDetMethods, numTrainOnKs);

% realHumanAgreement = dlmread(options.humanAgreementRealDataFile);

randomChance = @(dims, x) (1./x).*ones(size(dims));
for nPT = 1:numPartThresholds
    partThreshold = partThresholds(nPT);
    for nFt = 1:numFeatSets
        for nB = 1:numBiases
            for nProb = 1:numProbs
                for nDet = 1:numDetMethods
                    for kIdx = 1:length(parameters.trainOnKs)
                        curOverallAccuracy = accuraciesOverall{nPT, nFt, nB, nProb, nDet, kIdx};
                        [maxAcc, maxMP] = max(curOverallAccuracy(:, 1));
                        maxMPsOverall(nPT, nFt, nB, nProb, nDet, kIdx) = maxMP;
                        
                        curAvgClassAccuracy = accuraciesAvgClass{nPT, nFt, nB, nProb, nDet, kIdx};
                        [maxAcc, maxMP] = max(curAvgClassAccuracy(:, 1));
                        maxMPsAvgClass(nPT, nFt, nB, nProb, nDet, kIdx) = maxMP;
                    end
                end
            end
        end
    end
end

% squeeze(maxMPsOverall)'
% squeeze(maxMPsAvgClass)'

for nFt = 1:numFeatSets
    featsToUse = featSetsToUse{nFt};
    featsStr = strrep(num2str(featsToUse), '  ', '_');
    for nB = 1:numBiases
        biasTrain = biases(nB);
        for nProb = 1:numProbs
            probTest = probs(nProb);
            
            set(0,'defaulttextinterpreter','latex')
            set(0,'defaulttextfontsize', 21);
            set(0,'defaultaxesfontsize', 40)
            
            % Plot everything
            figure(1)
            clf
            hold on
            
            legendStr = 'legendHandle = legend(';
            plottedData = [];
            
            plotDetMethods = parameters.plotOrder(ismember(parameters.plotOrder, detMethods));
            
            for nDet = 1:length(plotDetMethods)
                detMethod = detMethods(plotDetMethods(nDet));
                
                detMethodName = detMethodNames{detMethod};
          
                legendStr = [legendStr, sprintf('''%s''', detMethodName) ','];
                accuracyOverallAtKs = zeros(numPartThresholds, 1);
                accuracyAvgClassAtKs = zeros(numPartThresholds, 1);
                for nPT = 1:numPartThresholds
                    for kIdx = 1:1
                        curOverallAccuracy = accuraciesOverall{nPT, nFt, nB, nProb, detMethod, kIdx};
                        curAvgClassAccuracy = accuraciesAvgClass{nPT, nFt, nB, nProb, detMethod, kIdx};
                        accuracyOverallAtKs(nPT) = curOverallAccuracy(maxMPsOverall(nPT, nFt, nB, nProb, detMethod, kIdx), 1);
                        accuracyAvgClassAtKs(nPT) = curAvgClassAccuracy(maxMPsAvgClass(nPT, nFt, nB, nProb, detMethod, kIdx), 1);
                    end
                end
                
                marker = [parameters.markerType{detMethod}, parameters.markerLine{1}];
                color  = parameters.markerColor{detMethod};
                plot(partThresholds, accuracyAvgClassAtKs, marker, 'Color', color, 'LineWidth', 3, 'MarkerSize', 10);
                    
                plottedData = [plottedData; accuracyAvgClassAtKs'];
                
            end
            
            markerRand = [parameters.markerLine{1}, parameters.markerType{parameters.idxRandom}];
            colorRand  = parameters.markerColor{parameters.idxRandom};
            plot(partThresholds, randomChance(partThresholds, size(curOverallAccuracy, 2)), markerRand, 'Color', colorRand, 'LineWidth', 3, 'MarkerSize', 10);
            plottedData = [plottedData; randomChance(partThresholds, size(curOverallAccuracy, 2)); partThresholds];
            legendStr = [legendStr, '''Random'', ''Location'', ''Northwest'');'];
            eval(legendStr);
            set(legendHandle,'FontSize', 34);
            
            set(gca, 'LineWidth', 3);
            xlim([0 max(partThresholds)+1]);
            if (datasetID == 1 )
                titleStr = 'PARSE Dataset';
                ylim([0 0.32])
            else
                titleStr = 'INTERACT Dataset';
                ylim([0 0.24]);
            end
            title(titleStr, 'FontSize', 30);
            xlabel('Part Threshold');
            ylabel('Mean Class Raw Accuracies');
            
            % Make full screen
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            set(gcf, 'PaperPositionMode', 'auto')
            
            filenameStr = sprintf(options.zslCatPartPlotFileFmt, ...
                datasetID, parameters.featsStr, parameters.detMethodsStr, biasTrain, probTest, featsStr, parameters.trainOnKsStr, parameters.numRandKsStr);
            filenameEPS = [filenameStr, '.eps'];
            filenamePNG = [filenameStr, '.png'];
            filenameCSV = [filenameStr, '.csv'];
            
            dlmwrite(filenameCSV, plottedData, ',');
            print(gcf, '-depsc2', filenameEPS);
            
            % Convert eps to png
            eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
            system(eps2pngStr);    
        end
    end
end

if ( 0 )
    set(0,'defaulttextinterpreter','latex')
    set(0,'defaulttextfontsize', 18);
    set(0,'defaultaxesfontsize', 20)
    
    % Plot everything
    figure(1)
    clf
    hold on
    legendStr = 'legend(';
    for nFt = 1:numFeatSets
        featsToUse = featSetsToUse{nFt};
        featsStr = strrep(num2str(featsToUse), '  ', '_');
        for nB = 1:numBiases
            biasTrain = biases(nB);
            for nProb = 1:numProbs
                probTest = probs(nProb);
                
                
                for nZSL = 1:numZSLMethods
                    zslMethod = zslMethods{nZSL};
                    legendFeatStr = sprintf('%s+', parameters.featTypeNames{featsToUse});
                    legendFeatStr = legendFeatStr(1:end-1);
                    legendStr = [legendStr, sprintf('''%s:%s''', zslMethod, legendFeatStr) ','];
                    accuracyOverallAtKs = zeros(length(parameters.trainOnKs), 1);
                    accuracyAvgClassAtKs = zeros(length(parameters.trainOnKs), 1);
                    for kIdx = 1:length(parameters.trainOnKs)
                        curOverallAccuracy = accuraciesOverall{nFt, nB, nProb, nZSL, kIdx};
                        curAvgClassAccuracy = accuraciesAvgClass{nFt, nB, nProb, nZSL, kIdx};
                        accuracyOverallAtKs(kIdx) = curOverallAccuracy(maxMPsOverall(nFt, nB, nProb, nZSL, kIdx), 1);
                        accuracyAvgClassAtKs(kIdx) = curAvgClassAccuracy(maxMPsAvgClass(nFt, nB, nProb, nZSL, kIdx), 1);
                    end
                    onesKs = ones(size(trainOnKs));
                    %                     plot(trainOnKs, accuracyOverallAtKs, parameters.markerStyle, 'LineWidth', 3);
                    plot(trainOnKs, accuracyAvgClassAtKs, parameters.markerStyle{nZSL}, 'Color', parameters.markerColor{nFt}, 'LineWidth', 3);
                    %                 plot(trainOnKs, realHumanAgreement(1)*onesKs, 'LineWidth', 3);
                    
                end
            end
        end
    end
    plot(trainOnKs, randomChance(trainOnKs, size(curOverallAccuracy, 2)), '-k', 'LineWidth', 3);
    legendStr = [legendStr, '''Random'', ''Location'', ''Southeast'');'];
    %                 legend(zslMethods{1}, 'linearSVM', 'Random', 'Location', 'SouthEast');
    eval(legendStr);
    set(gca, 'LineWidth', 2);
    xlim([0 max(trainOnKs)]);
    ylim([0 80]);
    xlabel('(Max) Number of Training Examples Per Category');
    ylabel('Accuracy ($\%$)');
    
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    
    filenameStr = sprintf('%sImages_Worth_Ablation_Exp_%d_classifier_%s_biasTrain_%d_probTest_%d_feats_%s_trainOnKs_%s', ...
        figurePath, expType, 'linearSVM', biasTrain, probTest, parameters.featsStr, parameters.trainOnKsStr);
    filenameEPS = [filenameStr, '.eps'];
    filenamePNG = [filenameStr, '.png'];
    print(gcf, '-depsc2', filenameEPS);
    
    % Convert eps to png
    eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
    system(eps2pngStr);
    
end


end