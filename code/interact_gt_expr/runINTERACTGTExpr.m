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

% Add path for some common MTurk task data-related functions
addpath(fullfile('..', 'common'));

%% Gets the options that govern directories, what runs, etc.
options = CreateOptionsGlobal();
options = CreateOptionsLocal(options);

if ( options.parseAMTFile ~= 0 )
    [taskAMT, taskData] = ProcessRealExprResultsData(options);
    
    % Add forgotten images %
    numVotes = 10;
    filenames = {
        '2IKV7WGKCCVL8CPGMYDHGPQ9VWL3TD_08_avgPoses_01.png'; ...
        '2IKV7WGKCCVL8CPGMYDHGPQ9VWL3TD_08_avgPoses_02.png'; ...
        };
    exprs = [2; 2];
    NE2s = [0; 0];
    IDs = {'manual'; 'manual'};
    % -------------------- %
    
    for i = 1:length(filenames)
        taskDatum.imgPose = filenames{i};
        parts = strsplit(filenames{i}, '_');
        taskDatum.img = strjoin(parts(1:2), '_');
        taskDatum.votesExpr = repmat( exprs(i), 1, numVotes );
        taskDatum.votesNE2 = repmat( NE2s(i), 1, numVotes );
        taskDatum.votesAssignIDs = repmat( IDs(i), 1, numVotes );
        taskData = [taskData; taskDatum];
    end
    
    save(options.AMTFile, 'taskAMT', 'taskData');
else
    load(options.AMTFile); % Loads already processed taskAMT, taskData
end


if ( options.processExprData ~= 0 )
    avgPoseTasksExpr = ProcessRealExprData(options, taskAMT, taskData);
    save(options.avgPoseExprFile, 'avgPoseTasksExpr');
else
    load(options.avgPoseExprFile)
end