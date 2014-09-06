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

function CreateQualitativeResults(options, parameters, datasetID, loadFile, allRealImgsGTImgFilename, allSentClipLabels, allSentClipImgFilename)

    if ( datasetID == 1 )
        datasetName = 'PARSE';
        folderName = 'parse';
        mainPage = '../PARSE_Category-level_ZSL_Qualitative_Results.html';  
        origImgBaseDir = options.folderYRPARSE;
        clipImgBaseDir = fullfile(options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataOutput}, 'rendered_illustrations');
        
        fid = fopen(options.filePARSEImgVerbLabelGT);
        colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', ';');
        fclose(fid);
        labels = double(colsAsCells{1});
        labels = labels(2:15);
        labelNames = colsAsCells{2};
        labelNames = labelNames(2:15);
        
    elseif ( datasetID == 2 )
        datasetName = 'INTERACT';
        folderName  = 'interact';
        mainPage = '../INTERACT_Semantic_ZSL_Qualitative_Results.html';
   
        origImgBaseDir = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput}, 'found_imgs');
        clipImgBaseDir = fullfile(options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataOutput}, 'rendered_illustrations');
        
        fid = fopen(options.fileINTERACTImgVerbLabelGT);
        colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', ';');
        fclose(fid);
        labels = double(colsAsCells{1});
        labelNames = colsAsCells{2};
    end
    
    [imgIdxsCell, imgLabelsCell, testLabelsCell, imgCorrectnessCell] = ComputeQualitativeAllCategoriesResults(options, parameters, datasetID, loadFile);
    
    [labelNamesOrdered, labelNamesOrderedIdxs] = sort(labelNames);
    labelsOrdered = labels(labelNamesOrderedIdxs);
      
    URL_dir = fullfile(options.foldersLocal{options.idxExperiments}{options.idxDataOutput}, 'qualitative_results', folderName);
    if ~exist(URL_dir, 'dir')
        mkdir(URL_dir);
    end
    htmlImgBaseDir = fullfile(URL_dir, 'imgs');
    if ~exist(htmlImgBaseDir, 'dir')
        mkdir(htmlImgBaseDir);
    end
    
    mainPage = sprintf('%s_Category-level_ZSL_Qualitative_Results.html', datasetName);
    mainFilename = fullfile(URL_dir, mainPage);
       
    numClipart = 5;
    topK = 25;
    imgWidth = 140;
    imgHeight = 140;

    % Run script that actually generates the HTML files
    createQualitativeAllCategoriesHTML;

end