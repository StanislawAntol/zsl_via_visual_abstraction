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

function ClassificationInstanceAccuracyPlot(options, parameters, datasetNum)

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
plotIdxs = [1,2, 3 5:5:recallAtKNumDivs];
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
    
    randomPerf = @(x) 100.*linspace(1./length(x), 1, length(x));
    
    for nFt = 1:numFeatSets
        featsToUse = parameters.featSets{nFt};
        featsStr = strrep(num2str(featsToUse), '  ', '_');
        featNameStr = strjoin(parameters.featTypeNames(featsToUse)', '+');
        
        legendStr = 'legendHandle = legend(';

        plotDetMethods = parameters.plotOrder(ismember(parameters.plotOrder, detMethods));
        
        for nDet = 1:length(plotDetMethods)
            detMethod = detMethods(plotDetMethods(nDet));
            
            detMethodName = detMethodNames{detMethod};
            
            for idxMap = 1:numMapMethods
                mapMethod = parameters.mapMethods(idxMap);
                mapMethodName = parameters.mapMethodsNames{mapMethod};
                
                for idxGRNNMeth = 1:numGRNNMethods
                    trainGRNNMethod     = parameters.trainGRNNMethods(idxGRNNMeth);
                    trainGRNNMethodName = parameters.trainGRNNMethodsNames{idxGRNNMeth};
                    
                    if ( ~(strcmp(mapMethodName, 'None') && strcmp(trainGRNNMethodName, 'PP')) && ...
                         ~(strcmp(detMethodName, 'PP') && strcmp(mapMethodName, 'GRNN') && strcmp(trainGRNNMethodName, 'PP')) )
                        
                        if ( strcmp(mapMethodName, 'None') )
                            methodStr = sprintf('%s', detMethodName);
                            legendStr = [legendStr, sprintf('''%s''', methodStr), ','];
                        else
                            methodStr = sprintf('%s-%s-%s', detMethodName, mapMethodName, trainGRNNMethodName);
                            legendStr = [legendStr, sprintf('''%s''', methodStr), ','];
                        end
                        
                        
                        marker = [parameters.markerType{detMethod}, parameters.markerLineInst{mapMethod, trainGRNNMethod}];
                        color  = parameters.markerColor{detMethod};
                        dataFilename = sprintf(options.saveAccuraciesZSLInstFormatStr, ...
                            options.classificationAccuraciesFile, datasetNum, parameters.featsStr, detMethod, mapMethod, trainGRNNMethod);
                        
                        load([dataFilename '.mat']);
                        
                        if ( isempty(recallCurves) )
                            recallCurves = [100/avgZSLData.recallAt1Ranks; recallXAxisVector'];
                        end
                        
                        recallCurves = [recallCurves, 100*[avgZSLData.recallAt1; avgZSLData.recallAtK]];
                        recallAt1s   = [recallAt1s, 100*avgZSLData.recallAt1];
                        means = [means, 100*avgZSLData.rankMean];
                        medians = [medians, 100*avgZSLData.rankMedian];
                        
                        X = [100/avgZSLData.recallAt1Ranks, recallXAxisVector(plotIdxs)]';
                        Y = [100*avgZSLData.recallAt1; 100*avgZSLData.recallAtK(plotIdxs)];
                        plot(X, Y, marker, 'Color', color, 'LineWidth', 3, 'MarkerSize', 10);

                        fprintf('%s Mean    : %3.3f\n', methodStr, 100*avgZSLData.rankMean);
                        fprintf('%s Median  : %3.3f\n', methodStr, 100*avgZSLData.rankMedian);
                        fprintf('%s Recall@1: %3.3f\n', methodStr, 100*avgZSLData.recallAt1);
    
                    end
                end
            end
        end
        
        marker = [parameters.markerType{parameters.idxRandom}, parameters.markerLine{1}];
        color  = parameters.markerColor{parameters.idxRandom};
        plot(recallXAxisVector, randomPerf(avgSBIRData.recallAtK)', marker, 'Color', color, 'LineWidth', 3, 'MarkerSize', 10);
        %         plot(recallXAxisVector, randomPerf(avgZSLData.recallAtK), '-k', 'MarkerSize', 4, 'LineWidth', 2);
        
        set(gca, 'LineWidth', 3);
        xlim([-1 100]);
        ylim([0 102]);
        %         if (expType == 1 )
        %             ylim([0 0.35])
        %         else
        %             ylim([0 0.225]);
        %         end
        
        %         title( sprintf('CBIR Ranking Results\nPCA threshold:%.2f', PCAKeepCutoff/100), 'FontSize', 32); % mean, median?
%         xlabel('True Label $<=$ (Kth Farthest Neighbor)/N ');
        xlabel('Top K (Normalized) NN Searched');
        ylabel('$\%$ Correctly Classified');
        if ( datasetNum == 1 )
            titleStr = 'PARSE Dataset';
        else
            titleStr = 'INTERACT Dataset';
        end
        title(titleStr, 'FontSize', 30);
       
        legendStr = [legendStr, '''Random'', ''Location'', ''Southeast'');'];
        eval(legendStr);
        set(legendHandle,'FontSize', 34);
        % Make full screen
        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        set(gcf, 'PaperPositionMode', 'auto')

        filenameStr = sprintf(options.zslInstPlotFileFmt, datasetNum, trainPerc, numRandSplits, parameters.featsStr, parameters.detMethodsStr, parameters.mapMethodsStr, parameters.yToX, parameters.spread, parameters.trainGRNNMethodsStr);
        filenameEPS = [filenameStr, '.eps'];
        filenamePNG = [filenameStr, '.png'];
        
        dlmwrite([filenameStr, '_recalls.csv'], recallCurves(saveIdxs, :), ',');
        dlmwrite([filenameStr, '_recallAt1.csv'], recallAt1s, ',');
        dlmwrite([filenameStr, '_means.csv'], means, ',');
        dlmwrite([filenameStr, '_medians.csv'], medians, ',');
        
        print(gcf, '-depsc2', filenameEPS);
        saveas(gcf, filenamePNG, 'png');
        
        % Convert eps to png
        eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
        system(eps2pngStr);
        hold off
    end
    fprintf('\n');
end

end