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

function avgPoseTasksGaze = ProcessRealGazeData(options, taskAMT, taskData)

    load(options.avgPoseFile); % produces avgPoseTasks
    
    %% Figures out which images don't strictly have 2 people
    imgNames = extractfield(taskData, 'img')';
    [imgNamesUnq, imgNamesIdxsA, imgNamesIdxsC] = unique(imgNames);

    numPoses = ceil(length(imgNames)/length(imgNamesUnq));
    gaze = zeros(length(imgNamesUnq), numPoses);
    badAnnCounts = zeros(length(imgNamesUnq), numPoses);
    badAnnTotals = zeros(length(imgNamesUnq), numPoses);
    for i = 1:length(imgNamesUnq)
        imgIdxs = imgNamesIdxsC == imgNamesIdxsC(imgNamesIdxsA(i));
        data = taskData(imgIdxs)';
        
        for j = 1:length(data)
           parts = strsplit( data(j).imgPose, 'avgPoses_');
           parts = strsplit( parts{end}, '.' );
           poseIdx = str2num(parts{1});
           votesGaze = data(j).votesGaze;
           votesBA = data(j).votesBadAnn;
           gaze(i, poseIdx) = mode(votesGaze);
           badAnnCounts(i, poseIdx) = sum(votesBA);
        end
        badAnnTotals(i) = sum(badAnnCounts(i, :));
    end

    if ( numel( find( gaze == 0 ) ) )
        fprintf('Warning: "no response" was majority vote."');
    end

     %% create new avgPoseTask with expression data
    avgPoseTasksGaze = [];

    for i = 1:numel(avgPoseTasks)
        avgPoseTask = avgPoseTasks(i);
        avgPoseTaskImgName = avgPoseTask.assignmentid;
        unqIdx = find(strcmp(imgNamesUnq, avgPoseTaskImgName) == 1);

        avgPoseTask.gaze = gaze(unqIdx, :)';
        avgPoseTask.badAnnCount = badAnnCounts(unqIdx, :)';
        avgPoseTask.badAnnTotal = badAnnTotals(unqIdx);
        avgPoseTasksGaze = [avgPoseTasksGaze; avgPoseTask];
    end

end