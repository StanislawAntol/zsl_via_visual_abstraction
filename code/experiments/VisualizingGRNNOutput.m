function idxCorrectClipartCell = VisualizingGRNNOutput(options, parameters, datasetID)

    numFeatSets = length(parameters.featSets);
    numDetMethods = length(parameters.detMethods);
    numMapMethods = length(parameters.mapMethods);
    numGRNNMethods = length(parameters.trainGRNNMethods);

    idxCorrectClipartCell   = cell(numDetMethods, numMapMethods, numGRNNMethods);
    
    for nFt = 1:numFeatSets
        featsToUse = parameters.featSets{nFt};
        featsStr = strrep(num2str(featsToUse), '  ', '_');

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
                        if ( strcmp(trainGRNNMethodName, 'PP') )
                            loadString = sprintf(['load ', options.saveModelZSLInstFormatStr, '.mat'], ...
                                options.classificationModelFileInst, datasetID, parameters.featsStr, detMethod, mapMethod, trainGRNNMethod);
                            eval(loadString);
                            
                            [isCorrect, clipartIdx] = ComputeFirstLabels(predIdxsR2C, testImgIdxs, testClipLabels);
                            idxCorrectClipartCell{idxDet, idxMap, idxGRNNMeth} = [isCorrect, clipartIdx];
                            
%                             idxsToDup = zeros(size(testClipLabels, 1), 1);
%                             for idxClip = 1:size(testClipLabels, 1)
%                                 idxsToDup(idxClip) = find( testClipLabels(idxClip) == testImgIdxs );
%                             end
%                             
%                             testClip       = testClipFeatsForExp;
% %                             testClipAsReal = testClipFeatsAsReal;
%                             testReal       = testImgFeatsForExp(idxsToDup, :);
%                             
%                             
%                             idxsCorrectAt1 = idxCorrectClipart == 1;
%                             
%                             idxCorrectClipartCell{idxDet, idxMap, idxGRNNMeth} = idxsCorrectAt1;
%                             idxsToLookAt = ismember(testClipLabels, testImgIdxs(idxsCorrectAt1));
%                             
%                             testClip       = testClip(idxsToLookAt, :);
% %                             testClipAsReal = testClipAsReal(idxsToLookAt, :);
%                             testReal       = testReal(idxsToLookAt, :);
%                             
%                             figure(1);
%                             image(255*testClip);
%                             title('Clipart Features');
%                             
%                             figure(2);
%                             image(255*testReal);
%                             title('Real Features');
%                             
%                             if ( ~strcmp(mapMethodName, 'None') )
%                                 figure(3);
%                                 image(255*testClipAsReal);
%                                 title('Clipart Features As Real');
%                             end
%                             
%                             pause();
                        elseif ( strcmp(trainGRNNMethodName, 'self') )
                            
                        end
                    elseif ( strcmp(mapMethodName, 'GRNN') )
                        loadString = sprintf(['save ', options.saveModelZSLInstFormatStr, '.mat'], ...
                            options.classificationModelFileInst, datasetID, parameters.featsStr, detMethod, mapMethod, trainGRNNMethod);
                        eval(loadString);
                        
                        [isCorrect, clipartIdx] = ComputeFirstLabels(predIdxsR2C, testImgIdxs, testClipLabels);
                        idxCorrectClipartCell{idxDet, idxMap, idxGRNNMeth} = [isCorrect, clipartIdx];
%                         
%                         idxsToDup = zeros(size(testClipLabels, 1), 1);
%                         for idxClip = 1:size(testClipLabels, 1)
%                             idxsToDup(idxClip) = find( testClipLabels(idxClip) == testImgIdxs );
%                         end
%                         
%                         testClip       = testClipFeatsForExp;
%                         testClipAsReal = testClipFeatsAsReal;
%                         testReal       = testImgFeatsForExp(idxsToDup, :);
%                                         
%                         idxsToLookAt   = ismember(testClipLabels, testImgIdxs(idxsCorrectAt1));
% %                         
%                         testClip       = testClip(idxsToLookAt, :);
%                         testClipAsReal = testClipAsReal(idxsToLookAt, :);
%                         testReal       = testReal(idxsToLookAt, :);
%                         
%                         figure(1);
%                         image(255*testClip);
%                         title('Clipart Features');
%                         
%                         figure(2);
%                         image(255*testReal);
%                         title('Real Features');
%                         
%                         if ( ~strcmp(mapMethodName, 'None') )
%                             figure(3);
%                             image(255*testClipAsReal);
%                             title('Clipart Features As Real');
%                         end
%                         
%                         pause();
                    end
                end
            end
        end

    end
% Basic-12,Contact-104,Global-24,Orientation-96,Exp-7,Gaze-2,Gender-2
%       12,        126,      140,           235,  242,   244,     246
end