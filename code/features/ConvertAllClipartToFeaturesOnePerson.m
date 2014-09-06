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

function ConvertAllClipartToFeaturesOnePerson(options, tasks)

    if ( options.clipartType == 1 ) % Category-level
        
        fileInfoData  = options.filePARSEClipCatInfoData;
        fileLabelData = options.filePARSEClipCatLabelData;
        filePoseData1 = options.filePARSEClipCatPoseData1;
        fileExprData1 = options.filePARSEClipCatExprData1;
        fileGazeData1 = options.filePARSEClipCatGazeData1;
        fileGendData1 = options.filePARSEClipCatGendData1;
                
        [verbsNum, verbsName] = GetPARSEVerbs(options);
        
        %% Create file with the numeric label to verb mapping
        labelData = cell(numel(verbsNum), 2);
        for i = 1:numel(verbsNum)
            labelData{i, 1} = verbsNum(i);
            labelData{i, 2} = verbsName{i};
        end
        
    elseif ( options.clipartType == 2 ) % Instance-level
        
        fileInfoData  = options.filePARSEClipInstInfoData;
        fileLabelData = options.filePARSEClipInstLabelData;
        filePoseData1 = options.filePARSEClipInstPoseData1;
        fileExprData1 = options.filePARSEClipInstExprData1;
        fileGazeData1 = options.filePARSEClipInstGazeData1;
        fileGendData1 = options.filePARSEClipInstGendData1;
        
        [verbsNum, verbsName] = GetPARSEVerbs(options);
        verbGroups = GroupingTasksByImgFile(options, tasks, verbsNum);
        temp = [];
        curSum = 0;
        for i = 1:length(verbGroups)
            temp = [temp; verbGroups{i}];
            curSum = curSum + length(verbGroups{i});
        end
        verbGroups = temp;
        imgFilenames = unique(extractfield(verbGroups, 'img'));
        
        %% Create file with the numeric label to verb mapping
        labelData = cell(numel(verbsNum), 2);
        for i = 1:numel(verbsNum)
            labelData{i, 1} = verbsNum(i);
            labelData{i, 2} = verbsName{i};
        end
        
    elseif ( options.clipartType == 3 ) % Category-level Random Negatives
        
        fileInfoData  = options.filePARSEClipRandNegInfoData{idxRand};
        fileLabelData = options.filePARSEClipRandNegLabelData{idxRand};
        filePoseData1 = options.filePARSEClipRandNegPoseData1{idxRand};
        fileExprData1 = options.filePARSEClipRandNegExprData1{idxRand};
        fileGazeData1 = options.filePARSEClipRandNegGazeData1{idxRand};
        fileGendData1 = options.filePARSEClipRandNegGendData1{idxRand};
        
        labelData{1, 1} = 0;
        labelData{1, 2} = 'random';
    end
    
    numTasks     = numel(tasks);
    infoData     =  cell(options.numScenesPerTask*numTasks, options.numPARSEInfoData);
    allPoseData1 = zeros(options.numScenesPerTask*numTasks, options.numPARSEFeatsPose);
    allExprData1 = zeros(options.numScenesPerTask*numTasks, options.numPARSEFeatsExpr);
    allGazeData1 = zeros(options.numScenesPerTask*numTasks, options.numPARSEFeatsGaze);
    allGendData1 = zeros(options.numScenesPerTask*numTasks, options.numPARSEFeatsGend);

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
%                 verb = sentence(10:end-10); % For INTERACT
                verb = sentence; % For PARSE
                verbLabel = verbsNum(find( strcmp(verbsName, verb) ));
                
                if ( isempty(verbLabel) || verbLabel > 14 ) % Final categories are 1-14
                    verbLabel = [];
                end
                
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
            
            [pose1, expr1, gaze1, gend1] = ConvertOneScene(options, scene);
            
            allPoseData1(options.numScenesPerTask*(i-1)+(j-1)+1,:) = pose1;
            allExprData1(options.numScenesPerTask*(i-1)+(j-1)+1,:) = expr1;
            allGazeData1(options.numScenesPerTask*(i-1)+(j-1)+1,:) = gaze1;
            allGendData1(options.numScenesPerTask*(i-1)+(j-1)+1,:) = gend1;
            
        end
    end
    
    idxBadClipart = cellfun(@isempty, infoData(:, 1));
    
        infoData(idxBadClipart, :) = [];
    allPoseData1(idxBadClipart, :) = [];
    allExprData1(idxBadClipart, :) = [];
    allGazeData1(idxBadClipart, :) = [];
    allGendData1(idxBadClipart, :) = [];

    cell2csv(fileInfoData , infoData,  ';', '%03d');
    cell2csv(fileLabelData, labelData, ';', '%03d');
    dlmwrite(filePoseData1, allPoseData1, 'delimiter', ';', 'precision',  '%.6f');
    dlmwrite(fileExprData1, allExprData1, ';');
    dlmwrite(fileGazeData1, allGazeData1, ';');
    dlmwrite(fileGendData1, allGendData1, ';');

end

function [pose1, expr1, gaze1, gend1] = ConvertOneScene(options, scene)

    pose1 = ConvertClipartToRealJointDataOnePerson(options, scene);

    expr1 = scene.pAExp == options.exprList;

    gaze1 = ComputeIndividualGazeFeat(options, scene);
    
    gend1 = scene.pAGend == options.genderList;

end