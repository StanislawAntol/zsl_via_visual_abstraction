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

function ReadAndSaveFeatDataIndv(options, whichData, noiseSigmas, randSeedVals)

    if ( nargin == 4 && NonClipartData(whichData) ) 
        origFeatBaseName = options.featBaseName;
        
        for noiseIdx = 1:length(noiseSigmas)
            sigma = noiseSigmas(noiseIdx);
            for randIdx = 1:length(randSeedVals)
                curSeed = randSeedVals(randIdx);
                for featIdx = [1:3, 8]
                    curName = origFeatBaseName{featIdx};
                    if ( featIdx == 8 )
                        options.featBaseName{featIdx} = sprintf('%s_sigma_%5.3f_seed_%05d%s', curName(1:4), sigma, curSeed, curName(5:end));
                    else
                        options.featBaseName{featIdx} = sprintf('%s_sigma_%5.3f_seed_%05d_%s', curName(1:4), sigma, curSeed, curName(6:end));
                    end
                end
                
                loadFeatDataFormatStr = ['%s = LoadFeatData(options.dataFeatDir{%d}, options.dataFeatBaseName{%d}, options.featBaseName, %d);'];
                loadFilenameAndLabelDataFormatStr = '[%s, %s] = LoadFilenameAndLabelData(options.dataFeatDir{%d}, options.dataInfoFile{%d}, '';'');';
                saveFormatStr = 'save(''%s'', ''%s'', ''%s'', ''%s'');';
                
                classificationDataFile = options.classificationDataFile{whichData};
                classificationDataFile = [classificationDataFile(1:end-4), sprintf('_sigma_%05.3f_seed_%05d', sigma, curSeed), '.mat'];
                
                [featuresStr, imgFilenamesStr, labelsStr] = CreateFeatureVarNames(options, whichData);
                
                loadFeatDataStr = sprintf(loadFeatDataFormatStr, ...
                    featuresStr, ...
                    whichData, ...
                    whichData, ...
                    options.allNumOrders(whichData));
                loadFilenameAndLabelDataStr = sprintf(loadFilenameAndLabelDataFormatStr, ...
                    imgFilenamesStr, ...
                    labelsStr, ...
                    whichData, ...
                    whichData);
                saveStr = sprintf(saveFormatStr, ...
                    [classificationDataFile], ...
                    featuresStr, ...
                    imgFilenamesStr, ...
                    labelsStr);
                
                eval(loadFeatDataStr)
                eval(loadFilenameAndLabelDataStr)
                eval(saveStr)
            end
        end
    else
        
        loadFeatDataFormatStr = ['%s = LoadFeatData(options.dataFeatDir{%d}, options.dataFeatBaseName{%d}, options.featBaseName, %d);'];
        loadFilenameAndLabelDataFormatStr = '[%s, %s] = LoadFilenameAndLabelData(options.dataFeatDir{%d}, options.dataInfoFile{%d}, '';'');';
        saveFormatStr = 'save(''%s'', ''%s'', ''%s'', ''%s'');';
        
        [featuresStr, imgFilenamesStr, labelsStr] = CreateFeatureVarNames(options, whichData);
        
        loadFeatDataStr = sprintf(loadFeatDataFormatStr, ...
            featuresStr, ...
            whichData, ...
            whichData, ...
            options.allNumOrders(whichData));
        loadFilenameAndLabelDataStr = sprintf(loadFilenameAndLabelDataFormatStr, ...
            imgFilenamesStr, ...
            labelsStr, ...
            whichData, ...
            whichData);
        saveStr = sprintf(saveFormatStr, ...
            options.classificationDataFile{whichData}, ...
            featuresStr, ...
            imgFilenamesStr, ...
            labelsStr);
        
        eval(loadFeatDataStr)
        eval(loadFilenameAndLabelDataStr)
        eval(saveStr)
    end
end