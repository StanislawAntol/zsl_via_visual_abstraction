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

function ComputeGazeFeatures(options, avgPoseTasksGaze)

    numImgs = numel(avgPoseTasksGaze);
    numGazeFeats = numel(options.gazeSwitchIdxMap);
    
    gazeFeatures_z = zeros(numImgs, numGazeFeats);
    noVal = 0; % missing substituted with 0
    
    for i = 1:numImgs
        avgPoseTask = avgPoseTasksGaze(i);
        avgPoses = avgPoseTask.poseTasks;
        gazes = avgPoseTask.gaze;
        
        gazeFeatures_z(i, :) = ComputeGazeFeat(avgPoses, gazes, noVal);
    end
    
    missingIdxs = sum(gazeFeatures_z, 2) == 0;
    goodIdxs = ~missingIdxs;
    
    gazeFeatures_m = gazeFeatures_z;
    missingMat = -1*ones(numImgs, numGazeFeats);
    gazeFeatures_m(missingIdxs, :) = missingMat(missingIdxs, :);
    
    gazeFeatures_p = gazeFeatures_z;
    gazePrior = sum(gazeFeatures_z(goodIdxs, :), 1)./numel(goodIdxs);
    gazePriorMat = repmat(gazePrior, numImgs, 1);
    gazeFeatures_p(missingIdxs, :) = gazePriorMat(missingIdxs, :);
    
    dlmwrite(options.fileINTERACTImgGazeDataGT1_m, gazeFeatures_m, ';');
    dlmwrite(options.fileINTERACTImgGazeDataGT1_z, gazeFeatures_z, ';');
    dlmwrite(options.fileINTERACTImgGazeDataGT1_p, gazeFeatures_p, ';');
    
    dlmwrite(options.fileINTERACTImgGazeDataGT2_m, gazeFeatures_m(:, options.gazeSwitchIdxMap), ';');
    dlmwrite(options.fileINTERACTImgGazeDataGT2_z, gazeFeatures_z(:, options.gazeSwitchIdxMap), ';');
    dlmwrite(options.fileINTERACTImgGazeDataGT2_p, gazeFeatures_p(:, options.gazeSwitchIdxMap), ';');
    
end

function gazeFeat = ComputeGazeFeat(poseTasks, gazes, noVal)

    person1Pose = poseTasks(1).pose;
    person2Pose = poseTasks(2).pose;
    
    person1Head = [person1Pose(1, 1); -1*person1Pose(1, 2)];
    person1Neck = [person1Pose(2, 1); -1*person1Pose(2, 2)];
    person1Gaze = gazes(1);
    
    person2Head = [person2Pose(1, 1); -1*person2Pose(1, 2)];
    person2Neck = [person2Pose(2, 1); -1*person2Pose(2, 2)];
    person2Gaze = gazes(2);
    
    % @TODO Consider making this able to accept some reasonable situations
    % where both people's heads/necks aren't provided (e.g., one person's
    % head/neck and other person's any part).
    % check that all points are actually annotated (by checking for -ve)
    allPoints = [person1Pose(1,:), person1Pose(2,:), person2Pose(1,:), person2Pose(2,:)];
    if ( sum( allPoints < 0 ) )
        gazeFeat = noVal*ones(5, 1);
    else  
        gazeFeat = GazeCalculation(person1Neck, person1Head, person1Gaze, ...
                                   person2Neck, person2Head, person2Gaze);
    end
    
end

function gazeFeat = GazeCalculation(N1, H1, gaze1, N2, H2, gaze2)

    flip1 = convertGazeToFlip(N1, H1, gaze1);
    flip2 = convertGazeToFlip(N2, H2, gaze2);

    oneLookTwo = OneLookingAtOther(N1, H1, flip1, H2);
    twoLookOne = OneLookingAtOther(N2, H2, flip2, H1);

    lookingAtOtherFeat = [oneLookTwo; twoLookOne];

    lAASFeat = LookAtAwaySameCalculation(oneLookTwo, twoLookOne);

    gazeFeat = [lookingAtOtherFeat; lAASFeat];
    
end

function flip = convertGazeToFlip(X1, X2, gaze)
    
    diff = X2 - X1;
    normal = [ -diff(2); diff(1) ];
    
    if (gaze == 1)
        direction = [-1; 0];
    else
        direction = [1; 0];
    end
    
    % Calculate 'flip,' i.e., looking direction wrt self
    if ( sign( dot( normal, direction ) ) == 1)
        flip = 0;
    else
        flip = 1;
    end

end