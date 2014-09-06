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

function CreateConfusionMatrices(options, parameters, datasetID, loadFile)

    if ( datasetID == 1 )
        datasetName = 'PARSE';
        folderName = 'parse';
        
        fid = fopen(options.filePARSEImgVerbLabelGT);
        colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', ';');
        fclose(fid);
        labels = double(colsAsCells{1});
        labels = labels(2:15);
        labelNames = { ...
            'dunk', ...
            'bat', ...
            'catch', ...
            'dive', ...
            'juggle', ...
            'kick', ...
            'bicycle', ...
            'pitch', ...
            'split', ...
            'stand', ...
            'celebrate', ...
            'walk (L)', ...
            'walk (R)', ...
            'walk (C)', ...
            };
        [labelNamesOrdered, labelNamesOrderedIdxs] = sort(labelNames);
        labelsOrdered = labels(labelNamesOrderedIdxs);

        labelsNewOrder = [];
        for i = 1:length(labelNamesOrderedIdxs)
            labelsNewOrder(i, 1) = find(labelsOrdered == i);
        end

        [imgIdxsCell, imgLabelsCell, testLabelsCell, imgCorrectnessCell] = ComputeQualitativeAllCategoriesResults(options, parameters, datasetID, loadFile);

        CM = confMatrix( labelsNewOrder(testLabelsCell{1}), labelsNewOrder(imgLabelsCell{1}), 14 );
        CMN = [];
        for i = 1:size(CM, 1)
            CMN(i, :) = CM(i, :)./sum(CM(i, :));
        end
        fprintf('Average of diagonal is %f.\n', mean(diag(CMN)));

        set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        set(gcf, 'PaperPositionMode', 'auto')
        
        confMatrixShow( CM, labelNamesOrdered, {'FontSize',18} )
        title(sprintf('%s Dataset', datasetName), 'FontSize', 70);
        filenameStr = sprintf(options.zslCatConfMatFileFmt, ...
            datasetID, parameters.featsStr, parameters.detMethodsStr, parameters.biasTrain, parameters.probTest, ...
            parameters.featsStr, parameters.trainOnKsStr, parameters.numRandKsStr);
        filenameEPS = [filenameStr, '.eps'];
        filenamePNG = [filenameStr, '.png'];

        print(gcf, '-depsc2', filenameEPS);

        % Convert eps to png
        eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
        system(eps2pngStr);

    elseif ( datasetID == 2 )
        datasetName = 'INTERACT';
        folderName  = 'interact';
        
        fid = fopen(options.fileINTERACTImgVerbLabelGT);
        colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', ';');
        fclose(fid);
        labels = double(colsAsCells{1});
        labelNames = colsAsCells{2};
        labelNames = strrep(labelNames, 'is ', '');

        [imgIdxsCell, imgLabelsCell, testLabelsCell, imgCorrectnessCell] = ComputeQualitativeAllCategoriesResults(options, parameters, datasetID, loadFile);

        [labelNamesOrdered, labelNamesOrderedIdxs] = sort(labelNames);
        labelsOrdered = labels(labelNamesOrderedIdxs);
        
        labelsNewOrder = [];
        for i = 1:length(labelNamesOrderedIdxs)
            labelsNewOrder(i, 1) = find(labelsOrdered == i);
        end

        % Confusion Matrix for all 60 categories
        if ( 1 )
            u = labels;
            CM = confMatrix( labelsNewOrder(testLabelsCell{1}), labelsNewOrder(imgLabelsCell{1}), 60 );
            %         set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            %         set(gcf, 'PaperPositionMode', 'auto')
            %         confMatrixShow( CM, labelNames, {'FontSize',1} )
            
            close all; clf;
            set(0,'defaulttextinterpreter','none')
            set(0,'defaulttextfontsize', 8);
            set(0,'defaultaxesfontsize', 6)
            
            hold on;
            CMN = [];
            for i = 1:size(CM, 1)
                CMN(i, :) = CM(i, :)./sum(CM(i, :));
            end
            fprintf('%s All verbs:\n', datasetName);
            fprintf('Average of diagonal is %f.\n', mean(diag(CMN)));
            
            h = imagesc(u+.5, u+.5, CMN);
            set(gca, 'LineWidth', 2);
            set(gca,'YDir','reverse');
            box on;
            
            % Make full screen
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            set(gcf, 'PaperPositionMode', 'auto')
            
            colormap(flipud(gray)) % # to change the default grayscale colormap
            colorbar;
            
            M = size(CMN,1)+1;
            N = size(CMN,2)+1;
            
            for k = 1:1:M
                x = [1 N];
                y = [k k];
                plot(x,y,'Color','k','LineStyle','-');
            end
            
            for k = 1:1:N
                x = [k k];
                y = [1 M];
                plot(x,y,'Color','k','LineStyle','-');
            end
            
            set(gca, 'XLim', [1 61]);
            set(gca, 'YLim', [1 61]);
            xticklabel_rotate(u+.5,90,labelNamesOrdered);
            set(gca,'YTickLabel', labelNamesOrdered);
            set(gca,'XTick',u+.5);
            set(gca,'YTick',u+.5);
            title(sprintf('%s Dataset', datasetName), 'FontSize', 30);
            axis square;
            hold off;
            
            filenameStr = sprintf([options.zslCatConfMatFileFmt, '_all_verbs'], ...
                datasetID, parameters.featsStr, parameters.detMethodsStr, parameters.biasTrain, parameters.probTest, ...
                parameters.featsStr, parameters.trainOnKsStr, parameters.numRandKsStr);
            filenameEPS = [filenameStr, '.eps'];
            filenamePNG = [filenameStr, '.png'];
            print(gcf, '-depsc2', filenameEPS);
            % Convert eps to png
            eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
            system(eps2pngStr);
        end
        
        % Confusion Matrix for categories when ignoring prepositions
        if ( 1 )
            labelNamesConsolidate = ...
                { 'arguing with', 'carrying', 'catching', ...
                'crawling', 'crouching', 'dancing with', 'elbowing', ...
                'hitting', 'holding hands with', 'hugging' 'jumping', ...
                'kicking', 'laughing', 'looking', 'lying', 'pointing', ...
                'pulling', 'pushing', 'reaching for', 'running', ...
                'shaking hands with', 'sitting', 'standing', 'talking with', ...
                'tripping', 'walking', 'waving at', 'wrestling with', ...
                };
            
            labelsVerbConsolidateMap = [ 1, 2, 3, 4*ones(1,5), 5*ones(1,4), 6, 7, 8, 9, 10, ...
                11*ones(1,6), 12, 13*ones(1,2), 14*ones(1,2), ...
                15*ones(1,4), 16*ones(1,2), 17, 18, 19, ...
                20*ones(1,5), 21, 22*ones(1,4), 23*ones(1,4), ...
                24, 25, 26*ones(1,5), 27, 28 ];
            
            u = unique(labelsVerbConsolidateMap);
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            set(gcf, 'PaperPositionMode', 'auto')
            CM = confMatrix( labelsVerbConsolidateMap(labelsNewOrder(testLabelsCell{1})), labelsVerbConsolidateMap(labelsNewOrder(imgLabelsCell{1})), length(u) );
            CMN = [];
            for i = 1:size(CM, 1)
                CMN(i, :) = CM(i, :)./sum(CM(i, :));
            end
            fprintf('%s Ignore prepositions:\n', datasetName);
            fprintf('Average of diagonal is %f.\n', mean(diag(CMN)));
            confMatrixShow( CM, labelNamesConsolidate, {'FontSize',10} )
            title(sprintf('%s Dataset', datasetName), 'FontSize', 30);
            filenameStr = sprintf([options.zslCatConfMatFileFmt, '_no_preps'], ...
                datasetID, parameters.featsStr, parameters.detMethodsStr, parameters.biasTrain, parameters.probTest, ...
                parameters.featsStr, parameters.trainOnKsStr, parameters.numRandKsStr);
            filenameEPS = [filenameStr, '.eps'];
            filenamePNG = [filenameStr, '.png'];
            print(gcf, '-depsc2', filenameEPS);
            % Convert eps to png
            eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
            system(eps2pngStr);
        end

        % Confusion Matrix for categories when ignoring verbs/focusing on
        % prepositions
        if ( 1 )

            labelNamesConsolidatePrep = ...
                { 'X after', 'X away from', 'X behind',  'X in front of', ...
                'X next to', 'X past', 'X to', 'X with', ...
                'arguing with',...
                };

            movementIdx = [1, 2, 6, 7, 8];
            locationIdx = [3, 4, 5, 8];
            %             labelsVerbConsolidatePrepMap = ....
            %                 [ 9, 10, 11, movementIdx, locationIdx, ...
            %                   12, 13, 14, 15, 16, [ 1, 2, 17 6, 7, 8], ...
            %                   18, 19, 20, 21, 22, ...
            %                   locationIdx, 23, 24, 25, 26, 27, movementIdx, ...
            %                   28, locationIdx, locationIdx, 29, 30, movementIdx, 31, 32, ...
            %                 ];
            labelsVerbConsolidatePrepMap = ....
                [ 9, 9, 9, movementIdx, locationIdx, ...
                9, 9, 9, 9, 9, [ 1, 2, 9, 6, 7, 8], ...
                9, 9, 9, 9, 9, ...
                locationIdx, 9, 9, 9, 9, 9, movementIdx, ...
                9, locationIdx, locationIdx, 9, 9, movementIdx, 9, 9, ...
                ];
            % Look at GT labels for verbs of interest
            labelsPrep = labelsNewOrder(testLabelsCell{1});
            labelsPrepGTIdxs = [[4:8], [9:12], [18:19], [21:23], ...
                [29:32], [38:42], [44:47], [48:51], [54:58] ];
            labelsPrepLogIdxs = ismember(labelsPrep, labelsPrepGTIdxs);
            labelsNonPrepLogIdxs = ~labelsPrepLogIdxs;

            labelsPrepTest = labelsPrep(labelsPrepLogIdxs);
            labelNamesOrdered(unique(labelsPrepTest)); % Sanity check

            %             labelsPrepTest = labelsVerbConsolidatePrepMap(labelsPrepTest);
            labelsPrepPred = labelsNewOrder(imgLabelsCell{1});
            labelsPrepPred = labelsPrepPred(labelsPrepLogIdxs);

            CM = confMatrix( labelsPrepTest, labelsPrepPred, length(unique(labelsNewOrder(testLabelsCell{1}))) );
            CM = CM(labelsPrepGTIdxs, labelsPrepGTIdxs);
            CMN = [];
            for i = 1:size(CM, 1)
                CMN(i, :) = CM(i, :)./sum(CM(i, :));
            end
            %
            %             diagSum = 0;
            %             for i = 1:length(labelsPrepGTIdxs)
            %                 diagSum = diagSum + CMN(labelsPrepGTIdxs(i), labelsPrepGTIdxs(i));
            %             end
            %             diagSum/length(labelsPrepGTIdxs)
            %             A = CMN;
            %             B = CMN(labelsPrepGTIdxs,labelsPrepGTIdxs);
            fprintf('%s Just ignored verbs subset:\n', datasetName);
            fprintf('Average of diagonal is %f.\n', mean(diag(CMN)));
            labelNamesConsolidatePrep = ...
                { 'X after', 'X away from', 'X behind',  'X in front of', ...
                'X next to', 'X past', 'X to', 'X with', ...
                'arguing with', 'carrying', 'catching', ...
                'dancing with', 'elbowing', 'hitting', ...
                'holding hands with', 'hugging', 'jumping over', ...
                'kicking', 'laughing at', 'laughing with', 'looking at', ...
                'looking away from', 'pointing at', 'pointing away from', ...
                'pulling', 'pushing', 'reaching for', 'shaking hands with', ...
                'talking with', 'tripping', 'waving at', 'wrestling with', ...
                }';
            u = unique(labelsVerbConsolidatePrepMap);
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            set(gcf, 'PaperPositionMode', 'auto')
            CM = confMatrix( labelsVerbConsolidatePrepMap(labelsNewOrder(testLabelsCell{1})), labelsVerbConsolidatePrepMap(labelsNewOrder(imgLabelsCell{1})), length(u) );
            CM = CM(1:8, 1:8);
            CMN = [];
            for i = 1:size(CM, 1)
                CMN(i, :) = CM(i, :)./sum(CM(i, :));
            end
            fprintf('%s Ignoring verbs, focus on preps:\n', datasetName);
            fprintf('Average of diagonal is %f.\n', mean(diag(CMN)));
            confMatrixShow( CM, labelNamesConsolidatePrep(1:8), {'FontSize',14} )
            title(sprintf('%s Dataset', datasetName), 'FontSize', 30);
            filenameStr = sprintf([options.zslCatConfMatFileFmt, '_no_verbs'], ...
                datasetID, parameters.featsStr, parameters.detMethodsStr, parameters.biasTrain, parameters.probTest, ...
                parameters.featsStr, parameters.trainOnKsStr, parameters.numRandKsStr);
            filenameEPS = [filenameStr, '.eps'];
            filenamePNG = [filenameStr, '.png'];
            print(gcf, '-depsc2', filenameEPS);
            % Convert eps to png
            eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
            system(eps2pngStr);
        end

    end

end