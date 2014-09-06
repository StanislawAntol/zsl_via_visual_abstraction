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

function poseTasksExpr = ProcessPARSEExprData(options, taskAMT, taskData)
    
    %% Figures out which images don't strictly have 2 people
    imgNames = extractfield(taskData, 'img')';
    [imgNamesUnq, imgNamesIdxsA, imgNamesIdxsC] = unique(imgNames);

    allNE1VotesSum = zeros(length(imgNamesUnq), 1);
    numPoses = ceil(length(imgNames)/length(imgNamesUnq));
    expr = zeros(length(imgNamesUnq), numPoses);
    
    for i = 1:length(imgNamesUnq)
        imgIdxs = imgNamesIdxsC == imgNamesIdxsC(imgNamesIdxsA(i));
        data = taskData(imgIdxs)';
        
        for j = 1:length(data)
           parts = strsplit( data(j).imgPose, 'avgPoses_');
           parts = strsplit( parts{end}, '.' );
           poseIdx = 1;
           votes = data(j).votesExpr;
           expr(i, poseIdx) = mode(votes);
        end
        votesNE1 = [data(:).votesNE1;];
        allNE1VotesSum(i) = sum(votesNE1(:));
    end

    if ( numel( find( expr == 0 ) ) )
        fprintf('Warning: "no response" was majority vote."');
    end

    %% create new avgPoseTask with expression data
    poseTasksExpr = [];

    % Assumes pose calculation order is in alphabetical order (by image
    % name)
    for i = 1:numel(imgNamesUnq)
        poseTask.img = [imgNamesUnq{i} '.jpg'];
        poseTask.expr = expr(i, :)';
        poseTask.NE1Count = allNE1VotesSum(i);
        poseTasksExpr = [poseTasksExpr; poseTask];
    end

end