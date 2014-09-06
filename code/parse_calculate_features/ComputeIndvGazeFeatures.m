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

function ComputeIndvGazeFeatures(options, poses, avgPoseTasksGaze)

    numImgs = numel(avgPoseTasksGaze);
    numGazeFeats = 2;
    
    gazeFeatures = zeros(numImgs, numGazeFeats);
    
    for i = 1:numImgs
        avgPoseTask = avgPoseTasksGaze(i);
        gaze = avgPoseTask.gaze - 1;
        pose = poses{i};
        gazeFeatures(i, :) = ComputeGazeFeat(pose, gaze);
    end
    
    dlmwrite(options.filePARSEImgGazeDataGT1, gazeFeatures, ';'); 
end

function gazeFeat = ComputeGazeFeat(pose, gaze)
    person1Pose = pose;
    
    person1Head = [person1Pose(1, 1); -1*person1Pose(1, 2)];
    person1Neck = [person1Pose(2, 1); -1*person1Pose(2, 2)];
    person1Gaze = gaze;
    
    flip = ConvertGazeToFlip(person1Neck, person1Head, gaze);
    gazeFeat = [flip == 0, flip == 1];
end

function flip = ConvertGazeToFlip(X1, X2, gaze)
    
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