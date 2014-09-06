function poseTasksGaze = ProcessPARSEGazeData(options, taskAMT, taskData)
    
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
           poseIdx = 1;
           votesGaze = data(j).votesGaze;
           votesBA = data(j).votesBadAnn;
           gaze(i, poseIdx) = mode(votesGaze);
           badAnnCounts(i, poseIdx) = sum(votesBA);
        end
        badAnnTotals(i) = sum(badAnnCounts(i, :));
    end

    if ( numel( find( gaze == 0 ) ) )
        fprintf('Warning: "no response" was majority vote.\n');
    end

     %% create new avgPoseTask with expression data
    poseTasksGaze = [];

   % Assumes pose calculation order is in alphabetical order (by image
    % name)
    for i = 1:numel(imgNamesUnq)
        poseTask.img = [imgNamesUnq{i} '.jpg'];
        poseTask.gaze = gaze(i, :)';
        poseTask.badAnnCount = badAnnCounts(i, :)';
        poseTask.badAnnTotal = badAnnTotals(i);
        poseTasksGaze = [poseTasksGaze; poseTask];
    end

end