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

% Setting properties of HTML table
tblWidth = 1200;
tblBorder = 2;
tblCellpad = 1;

% How many separate tables to make
numTbl = 1;

% Dimensions of the HTML table
numRow = -1; % Is set automatically in the loops
numCol = numClipart+2;

% Tags to start and end a table's row
tblRowTagSt = '<tr>\n';
tblRowTagE = '</tr>\n';

% Tags to start and end a table's column data entry
tblColTagS = '\t<td align="center" valign="top">\n';
tblColTagE = '\t</td>\n';

mainFID = fopen(mainFilename, 'w');

fprintf(mainFID, '<!DOCTYPE html>\n<html>\n<body>\n');
fprintf(mainFID, '\t<h1>%s Category-level ZSL Qualitative Results</h1>\n', datasetName);

% imgRealIdxs = testRealImgsIdxs(imgIdxsCell{1});
imgRealIdxs = imgIdxsCell{1};
correctIdxs   = find( imgCorrectnessCell{1} );
correctIdxsLabels = imgLabelsCell{1}(correctIdxs);
incorrectIdxs = find( ~imgCorrectnessCell{1} );
incorrectIdxsLabels = imgLabelsCell{1}(incorrectIdxs);

if ( 0 )    
    topKCorrectIdxs = correctIdxs(1:topK);
    topKIncorrectIdxs = incorrectIdxs(1:topK);
else
    randClipart = [];
    topKCorrectIdxs = [];
    topKIncorrectIdxs = [];
    for labelIdx = 1:length(labelsOrdered)
        
        allClipartIdxs = find( allSentClipLabels == labelsOrdered(labelIdx) );
        if ( isempty(allClipartIdxs) )
            
        else
            clipart.labels = allSentClipLabels(allClipartIdxs(1:numClipart));
            clipart.imgFilenames = allSentClipImgFilename(allClipartIdxs(1:numClipart));
        end
        randClipart = [randClipart; clipart];

        allCorrectIdxs = find( correctIdxsLabels == labelsOrdered(labelIdx) );
        if ( isempty(allCorrectIdxs) )
            topKCorrectIdxs(labelIdx) = -1;
        else
            topKCorrectIdxs(labelIdx) = correctIdxs(allCorrectIdxs(1));
        end
        
        allIncorrectIdxs = find( incorrectIdxsLabels == labelsOrdered(labelIdx) );
        if ( isempty(allIncorrectIdxs) )
            topKIncorrectIdxs(labelIdx) = -1;
        else
            topKIncorrectIdxs(labelIdx) = incorrectIdxs(allIncorrectIdxs(1));
        end
        
    end
end

fprintf(fid, '<table width="%d" border="%d" cellpadding="%d">\n', ...
                tblWidth, tblBorder, tblCellpad);

clipartHeaders = '<th>Training Illustrations</th>';
for i = 2:numClipart
    clipartHeaders = [clipartHeaders, '<th></th>'];
end
fprintf(fid, '<tr>%s<th>Most Confident True Positive for Each Category</th><th>Most Confident False Positive for Each Category</th></tr>', clipartHeaders);

for i = 1:length(topKCorrectIdxs)

    fprintf(fid, tblRowTagSt);

    for clipIdx = 1:numClipart
        imgName = randClipart(i).imgFilenames{clipIdx};
        origImgFile = fullfile(clipImgBaseDir, imgName);
        copyImgFile = fullfile(htmlImgBaseDir, imgName);
        copyImgName = sprintf('./imgs/%s', imgName);
        copyfile(origImgFile, copyImgFile);
        
        fprintf(fid, tblColTagS);
        fprintf(fid, '<img src="%s" alt="" width="%d" height="%d" style="border:5px solid black">\n\t\t<br><br><br><br>\n', ...
            copyImgName, imgWidth, imgHeight);
        fprintf(fid, tblColTagE);
    end
    
    colorName = 'green';
    curCorrectIdx = topKCorrectIdxs(i);

    if ( curCorrectIdx == -1 )
        predClass = -1;
        copyImgName = './imgs/NoImage.png';
        predLabel = 'No prediction.';
    else
        predClass = imgLabelsCell{1}(curCorrectIdx);
        imgName = allRealImgsGTImgFilename{imgRealIdxs(curCorrectIdx)};
        origImgFile = fullfile(origImgBaseDir, imgName);
        copyImgFile = fullfile(htmlImgBaseDir, imgName);
        copyImgName = sprintf('./imgs/%s', imgName);
        copyfile(origImgFile, copyImgFile);
        if ( datasetID == 1 )
            predLabel = labelNames{find(labels == predClass)};
        elseif ( datasetID == 2 )
            predLabel = sprintf('Person A %s Person B.', labelNames{find(labels == predClass)});
        end
    end

    fprintf(fid, tblColTagS);
    fprintf(fid, '<img src="%s" alt="No Prediction" width="%d" height="%d" style="border:5px solid %s">\n\t\t<br><font size="3"><b>Predicted:</b> %s</font><br><br>\n', ...
            copyImgName, imgWidth, imgHeight, colorName, predLabel);
    fprintf(fid, tblColTagE);
    
    colorName = 'red';
    
    curIncorrectIdx = topKIncorrectIdxs(i);
    if ( curIncorrectIdx == -1 )
        predClass = -1;
        trueClass = labelsOrdered(i);
        copyImgName = './imgs/NoImage.png';
        predLabel = 'No prediction.';

        if ( datasetID == 1 )
            trueLabel = labelNames{find(labels == trueClass)};
        else
            trueLabel = sprintf('Person A %s Person B.', labelNames{find(labels == trueClass)});
        end
    else
        predClass = imgLabelsCell{1}(curIncorrectIdx);
        trueClass = testLabelsCell{1}(curIncorrectIdx);
        imgName = allRealImgsGTImgFilename{imgRealIdxs(curIncorrectIdx)};
        origImgFile = fullfile(origImgBaseDir, imgName);
        copyImgFile = fullfile(htmlImgBaseDir, imgName);
        copyImgName = sprintf('./imgs/%s', imgName);
        copyfile(origImgFile, copyImgFile);
        
        if ( datasetID == 1 )
            predLabel = labelNames{find(labels == predClass)};
            trueLabel = labelNames{find(labels == trueClass)};
        elseif ( datasetID == 2 )
            predLabel = sprintf('Person A %s Person B.', labelNames{find(labels == predClass)});
            trueLabel = sprintf('Person A %s Person B.', labelNames{find(labels == trueClass)});
        end
    end
    
    fprintf(fid, tblColTagS);
    fprintf(fid, '<img src="%s" alt="No Prediction." width="%d" height="%d" style="border:5px solid %s"><br>\n\t\t<font size="3"><b>Predicted:</b> %s</font><br><font size="3"><b>True:</b> %s</font><br>', ...
            copyImgName, imgWidth, imgHeight, colorName, predLabel, trueLabel);
    fprintf(fid, tblColTagE);

    fprintf(fid, tblRowTagE);

end

fprintf(mainFID, '</body>\n</html>\n');

fclose(mainFID);

