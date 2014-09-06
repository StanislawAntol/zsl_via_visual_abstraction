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

if ( options.initYR ~= 0 )
     model = InitYRCode(options);
end

if ( options.runYRD ~= 0 )
    load(options.poseTasksFile); % Loads avgPoseTasks
    idxsBoxes = 1:length(avgPoseTasks); % Run YR on all images
    YRDDetectionOnTasks(options, model, avgPoseTasks, idxsBoxes);
end

if ( options.runExtractPosesYRD ~= 0 )
    load(options.poseTasksFile); % Loads avgPoseTasks
    idxsBoxes = 1:length(avgPoseTasks); % Extract poses on all images
    ExtractPosesFromYRDBoxes(options, model, avgPoseTasks, idxsBoxes);
end

if ( options.runYRBB ~= 0 )
    load(options.poseTasksFile); % Loads avgPoseTasks
    idxsBoxes = 1:length(avgPoseTasks); % Run YR on all images
    YRBBDetectionOnTasks(options, model, avgPoseTasks, idxsBoxes)
end

if ( options.runExtractPosesYRBB ~= 0 )
    load(options.poseTasksFile); % Loads avgPoseTasks
    idxsBoxes = 1:length(avgPoseTasks); % Extract poses on all images
    ExtractPosesFromYRBBBoxes(options, model, avgPoseTasks, idxsBoxes);
end