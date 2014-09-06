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

function ClassificationInstanceAccuracyPlotSwappedTrain(options, parameters, datasetNum)

recallAtKNumDivs = parameters.recallAtKNumDivs;

detMethods = parameters.detMethods;
detMethodNames = parameters.detMethodsNames;

numTrainSplits = length(parameters.trainingPercs);
numFeatSets = length(parameters.featSets);
numDetMethods = length(parameters.detMethods);
numMapMethods = length(parameters.mapMethods);
numGRNNMethods = length(parameters.trainGRNNMethods);

recallXAxisVector = 100*linspace(1/recallAtKNumDivs, 1, recallAtKNumDivs);
% plotIdxs = [ceil(linspace(1, recallAtKNumDivs/4, 8)), ceil(linspace(recallAtKNumDivs/3+1, recallAtKNumDivs, 6))];

top10 = 0;
parameters.spread = 0.1;
if ( top10 )
    plotIdxs = [1:2:8, 10:recallAtKNumDivs];
else
    plotIdxs = [1,2, 3 5:5:recallAtKNumDivs];
end

saveIdxs = [1:recallAtKNumDivs];

[~, idx] = min(abs(recallXAxisVector - 0.2));

% recallCurves = recallXAxisVector';

recallCurves = [];
means = [];
medians = [];
plottedData = [];
recallAt1s = [];

for nTS = 1:numTrainSplits
    trainPerc = parameters.trainingPercs(nTS);
    numRandSplits = parameters.randTrainSplits(nTS);
    
    set(0,'defaulttextinterpreter','latex')
    set(0,'defaulttextfontsize', 21);
    set(0,'defaultaxesfontsize', 40)
    
    figure(1);
    clf;
    hold on
    legendStr = '';
    
    testOnTest = 0;
    
    randomPerf = @(x) 100.*linspace(1./length(x), 1, length(x));
    
    for nFt = 1:numFeatSets
        featsToUse = parameters.featSets{nFt};
        featsStr = strrep(num2str(featsToUse), '  ', '_');
        featNameStr = strjoin(parameters.featTypeNames(featsToUse)', '+');
        
        legendStr = 'legendHandle = legend(';
        
        trainSetNums = [1, 2];
        trainDetMethods = { 'YR', 'YR'; ...
            'YRBB', 'YRBB'};
        testDetMethods  = { 'YR', 'YRBB'; ...
            'YR', 'YRBB'};
        
        if ( testOnTest )
            testStr = 'test';
        else
            testStr = 'train';
        end
        curIdx = 1;
        for idxTSN = 1:2
            trainSetNum = trainSetNums(idxTSN);
            for idxTrDM = 1:2
                for idxTeDM = 1:2
                    
                    trainDetMethod = trainDetMethods{idxTrDM, idxTeDM};
                    testDetMethod  = testDetMethods{idxTrDM, idxTeDM};
                    
                    methodStr = sprintf('train_train%s%d_test_%s%s1', trainDetMethod, trainSetNum, testStr, testDetMethod);
                    methodNameStr = sprintf('train:train%s%d, test:%s%s1', trainDetMethod, trainSetNum, testStr, testDetMethod);
                    
                    dataFilename = sprintf([options.saveAccuraciesZSLInstFormatStrNew, '_', methodStr], ...
                        options.classificationAccuraciesFile, datasetNum, parameters.featsStr, parameters.spread);
                    load([dataFilename, '.mat']);
                    
                    if ( isempty(recallCurves) )
                        recallCurves = [100/avgZSLData.recallAt1Ranks; recallXAxisVector'];
                    end

                    marker = [parameters.markerType{2, idxTrDM}, parameters.markerLineInst{idxTSN, 1}];
                    color  = parameters.markerColor{idxTeDM+1};
                    
                    recallCurves = [recallCurves, 100*[avgZSLData.recallAt1; avgZSLData.recallAtK]];
                    recallAt1s   = [recallAt1s, 100*avgZSLData.recallAt1];
                    means = [means, 100*avgZSLData.rankMean];
                    medians = [medians, 100*avgZSLData.rankMedian];
                    
                    X = [100/avgZSLData.recallAt1Ranks, recallXAxisVector(plotIdxs)]';
                    Y = [100*avgZSLData.recallAt1; 100*avgZSLData.recallAtK(plotIdxs)];
                    plot(X, Y, marker, 'Color', color, 'LineWidth', 3, 'MarkerSize', 15);
                    legendStr = [legendStr, sprintf('''%s''', methodNameStr), ','];
                    
%                     fprintf('%s Mean    : %3.3f\n', methodNameStr, 100*avgZSLData.rankMean);
%                     fprintf('%s Median  : %3.3f\n', methodNameStr, 100*avgZSLData.rankMedian);
                    fprintf('%s Recall@1: %3.3f\n', methodNameStr, 100*avgZSLData.recallAt1);
                    
                    curIdx = curIdx + 1;

                end
            end
        end

        
        set(gca, 'LineWidth', 3);
        if ( top10 )
            xlim([0 11]);
        end
        %         xlim([-1 100]);
        %         ylim([0 102]);
        %         if (datasetNum == 1 )
        %             ylim([0 0.35])
        %         else
        %             ylim([0 0.225]);
        %         end
        
        %         title( sprintf('CBIR Ranking Results\nPCA threshold:%.2f', PCAKeepCutoff/100), 'FontSize', 32); % mean, median?
        xlabel('Top $\%$ (Normalized) NN Searched');
        ylabel('$\%$ With Correct Label');
        if ( datasetNum == 1 )
            titleStr = 'PARSE Dataset';
        else
            titleStr = sprintf('INTERACT Dataset, spread=%.2e', parameters.spread);
        end
        title(titleStr, 'FontSize', 30);
        
        legendStr = [legendStr, '''Random'', ''Location'', ''Southeast'');'];
        eval(legendStr);
        set(legendHandle,'FontSize', 24);
        %         Make full screen
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        set(gcf, 'PaperPositionMode', 'auto')
        
        if ( top10 )
            filenameStr = sprintf([options.zslInstPlotFileFmt, '_rand_sets_top10'], datasetNum, trainPerc, numRandSplits, parameters.featsStr, parameters.detMethodsStr, parameters.mapMethodsStr, parameters.yToX, parameters.spread, parameters.trainGRNNMethodsStr);
        else
            filenameStr = sprintf([options.zslInstPlotFileFmt, '_rand_sets'], datasetNum, trainPerc, numRandSplits, parameters.featsStr, parameters.detMethodsStr, parameters.mapMethodsStr, parameters.yToX, parameters.spread, parameters.trainGRNNMethodsStr);
        end
        filenameEPS = [filenameStr, '.eps'];
        filenamePNG = [filenameStr, '.png'];
        
        dlmwrite([filenameStr, '_recalls.csv'], recallCurves(saveIdxs, :), ',');
        dlmwrite([filenameStr, '_recallAt1.csv'], recallAt1s, ',');
        dlmwrite([filenameStr, '_means.csv'], means, ',');
        dlmwrite([filenameStr, '_medians.csv'], medians, ',');
        
        print(gcf, '-depsc2', filenameEPS);
        saveas(gcf, filenamePNG, 'png');
        
        %         Convert eps to png
        eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
        system(eps2pngStr);
        hold off
    end
    fprintf('\n');
end

end