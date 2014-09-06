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

function ConvertAllClipartToFeaturesTwoPerson(options, tasks)

    if ( options.clipartType == 1 ) % Category-level
        
        fileInfoData  = options.fileINTERACTClipCatInfoData;
        fileLabelData = options.fileINTERACTClipCatLabelData;
        filePoseData1 = options.fileINTERACTClipCatPoseData1;
        fileExprData1 = options.fileINTERACTClipCatExprData1;
        fileGazeData1 = options.fileINTERACTClipCatGazeData1;
        fileGendData1 = options.fileINTERACTClipCatGendData1;
        filePoseData2 = options.fileINTERACTClipCatPoseData2;
        fileExprData2 = options.fileINTERACTClipCatExprData2;
        fileGazeData2 = options.fileINTERACTClipCatGazeData2;
        fileGendData2 = options.fileINTERACTClipCatGendData2;
                
        [verbsNum, verbsName] = GetINTERACTVerbTuples(options);
        
        %% Create file with the numeric label to verb mapping
        labelData = cell(numel(verbsNum), 2);
        for i = 1:numel(verbsNum)
            labelData{i, 1} = verbsNum(i);
            labelData{i, 2} = verbsName{i};
        end
        
    elseif ( options.clipartType == 2 ) % Instance-level
        
        fileInfoData  = options.fileINTERACTClipInstInfoData;
        fileLabelData = options.fileINTERACTClipInstLabelData;
        filePoseData1 = options.fileINTERACTClipInstPoseData1;
        fileExprData1 = options.fileINTERACTClipInstExprData1;
        fileGazeData1 = options.fileINTERACTClipInstGazeData1;
        fileGendData1 = options.fileINTERACTClipInstGendData1;
        filePoseData2 = options.fileINTERACTClipInstPoseData2;
        fileExprData2 = options.fileINTERACTClipInstExprData2;
        fileGazeData2 = options.fileINTERACTClipInstGazeData2;
        fileGendData2 = options.fileINTERACTClipInstGendData2;
        
%         [verbsNum, verbsName] = GetINTERACTVerbTuples(options);
        
        fid = fopen(options.fileInitDatasetVerbs);
        colsAsCells = textscan(fid, '%d%s', 'Delimiter', ';');
        fclose(fid);
        
        verbsNum = double(colsAsCells{1});
        verbsName = colsAsCells{2};
    
        verbGroups = GroupingTasksByImgFile(options, tasks, verbsNum);
        temp = [];
        curSum = 0;
        for i = 1:length(verbGroups)
            temp = [temp; verbGroups{i}];
            curSum = curSum + length(verbGroups{i});
        end
        verbGroups = temp;
        imgFilenames = extractfield(verbGroups, 'img');
        
        %% Create file with the numeric label to verb mapping
        labelData = cell(numel(verbsNum), 2);
        for i = 1:numel(verbsNum)
            labelData{i, 1} = verbsNum(i);
            labelData{i, 2} = verbsName{i};
        end
        
    elseif ( options.clipartType == 3 ) % Category-level Random Negatives
        
        fileInfoData  = options.fileINTERACTClipRandNegInfoData{idxRand};
        fileLabelData = options.fileINTERACTClipRandNegLabelData{idxRand};
        filePoseData1 = options.fileINTERACTClipRandNegPoseData1{idxRand};
        fileExprData1 = options.fileINTERACTClipRandNegExprData1{idxRand};
        fileGazeData1 = options.fileINTERACTClipRandNegGazeData1{idxRand};
        fileGendData1 = options.fileINTERACTClipRandNegGendData1{idxRand};
        filePoseData2 = options.fileINTERACTClipRandNegPoseData2{idxRand};
        fileExprData2 = options.fileINTERACTClipRandNegExprData2{idxRand};
        fileGazeData2 = options.fileINTERACTClipRandNegGazeData2{idxRand};
        fileGendData2 = options.fileINTERACTClipRandNegGendData2{idxRand};
        
        labelData{1, 1} = 0;
        labelData{1, 2} = 'random';
    end
    
    numTasks     = numel(tasks);
    infoData     =  cell(options.numScenesPerTask*numTasks, options.numINTERACTInfoData);
    allPoseData1 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsPose);
    allExprData1 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsExpr);
    allGazeData1 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsGaze);
    allGendData1 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsGend);
    allPoseData2 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsPose);
    allExprData2 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsExpr);
    allGazeData2 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsGaze);
    allGendData2 = zeros(options.numScenesPerTask*numTasks, options.numINTERACTFeatsGend);

    %% Loop through all tasks and every scene for each task
    for i = 1:numTasks
        task = tasks(i);
        assignmentID = task.assignmentid;
        
        for j = 1:numel(task.scenes)
            
            scene = task.scenes(j);

            if ( options.clipartType == 1 )
                
                zeroPadNum = sprintf(['%0', num2str(options.renderImgNameZeroPad),...
                    'd'], j);
                imgName = [assignmentID, '_', zeroPadNum, '.', options.renderImgExt];
            
                sentence = scene.sent;
                verb = sentence(10:end-10);
                verbLabel = find( strcmp(verbsName, verb) );
                
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 1} = verbLabel;
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 2} = imgName;
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 3} = sentence;
     
            elseif ( options.clipartType == 2 )
                
                zeroPadNum = sprintf(['%0', num2str(options.renderImgNameZeroPad),...
                    'd'], j);
                imgName = [assignmentID, '_', zeroPadNum, '.', options.renderImgExt];
                
                imgFilename = scene.img;
                imgLabel = find( strcmp( imgFilenames, imgFilename ) );
                
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 1} = imgLabel;
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 2} = imgName;
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 3} = imgFilename;
                
            elseif ( options.clipartType == 3 )
                
                imgName = sprintf('rand_seed_%06d_idx_%06d.%s', parameters.randSeed, i, options.renderImgExt);
                
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 1} = 0;
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 2} = imgName;
                infoData{options.numScenesPerTask*(i-1)+(j-1)+1, 3} = 'random';
                
            end
            
            [pose1, pose2, expr1, expr2, gaze1, gaze2, gend1, gend2] = ConvertOneScene(options, scene);
            
            allPoseData1(options.numScenesPerTask*(i-1)+(j-1)+1, :) = pose1;
            allPoseData2(options.numScenesPerTask*(i-1)+(j-1)+1, :) = pose2;
            allExprData1(options.numScenesPerTask*(i-1)+(j-1)+1, :) = expr1;
            allExprData2(options.numScenesPerTask*(i-1)+(j-1)+1, :) = expr2;
            allGazeData1(options.numScenesPerTask*(i-1)+(j-1)+1, :) = gaze1;
            allGazeData2(options.numScenesPerTask*(i-1)+(j-1)+1, :) = gaze2;
            allGendData1(options.numScenesPerTask*(i-1)+(j-1)+1, :) = gend1;
            allGendData2(options.numScenesPerTask*(i-1)+(j-1)+1, :) = gend2;
        end
    end
    
    cell2csv(fileInfoData , infoData,  ';', '%03d');
    cell2csv(fileLabelData, labelData, ';', '%03d');
    dlmwrite(filePoseData1, allPoseData1, 'delimiter', ';', 'precision',  '%.6f');
    dlmwrite(fileExprData1, allExprData1, ';');
    dlmwrite(fileGazeData1, allGazeData1, ';');
    dlmwrite(fileGendData1, allGendData1, ';');
    dlmwrite(filePoseData2, allPoseData2, 'delimiter', ';', 'precision',  '%.6f');
    dlmwrite(fileExprData2, allExprData2, ';');
    dlmwrite(fileGazeData2, allGazeData2, ';');
    dlmwrite(fileGendData2, allGendData2, ';');

end

function [pose1, pose2, expr1, expr2, gaze1, gaze2, gend1, gend2] = ConvertOneScene(options, scene)

    pose1 = ConvertClipartToRealJointDataTwoPerson(options, scene);
    pose2 = [pose1(end/2+1:end); pose1(1:end/2)];

    exprList = options.exprList;

    pAExpBinary = scene.pAExp == exprList;
    pBExpBinary = scene.pBExp == exprList;

    pAGendBinary = scene.pAGend == options.genderList;
    pBGendBinary = scene.pBGend == options.genderList;
    
    if ( options.clipartType == 1 )
        curP1 = scene.p1;
    else
        curP1 = 1; % Just have arbitrary order
    end

    if ( curP1 == 1 ) % Person 1 (first part of sentence) is Person A
        % Correct order
        expr1 = [pAExpBinary,  pBExpBinary];
        gend1 = [pAGendBinary, pBGendBinary];
        
        % Swapped order
        expr2 = [pBExpBinary,  pAExpBinary];
        gend2 = [pBGendBinary, pAGendBinary];
    elseif ( curP1 == 2 ) % Person 1 (first part of sentence) is Person B
        % Correct order
        expr1 = [pBExpBinary,  pAExpBinary];
        gend1 = [pBGendBinary, pAGendBinary];
        
        % Swapped order
        expr2 = [pAExpBinary,  pBExpBinary];        
        gend2 = [pAGendBinary, pBGendBinary];
    end

    gaze1 = ComputeGazeFeat(options, scene, curP1);
    gaze2 = gaze1(options.gazeSwitchIdxMap);

end