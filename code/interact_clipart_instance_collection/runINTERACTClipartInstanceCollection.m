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
addpath(fullfile('..', 'features'));

%% Gets the options that govern directories, what runs, etc.
options = CreateOptionsGlobal();
options = CreateOptionsLocal(options);

%% Parses the AMT results file to get HIT data

if (options.parseAMTFile ~= 0)
    [allTasks] = ParseMTurk(options);
    save(options.outDataFile, 'allTasks');
else
    load(options.outDataFile);
end

% Can remove HITs that were approved/rejected.
if (options.filterApproved ~= 0)
    tasks = FilterOutTasks(allTasks, options.filterLabel);
else
    tasks = allTasks;
end

comments = extractfield(tasks, 'comments')';
actualComments = comments(~cellfun('isempty', comments));

badWorkerIDs = extractfield(tasks, 'workerid')';
badWorkerIdxs = strcmp(badWorkerIDs, '1263');

tasks = tasks(~badWorkerIdxs);

%% Creates the result images and saves them as image files
if ( options.processData1 ~= 0 )
    RenderTaskScenes(options, tasks);
end

%% Creates the HTML files for easy viewing of the results
if ( options.createHTML ~= 0 )
    CreateHTMLPagesByVerb(options, tasks);
    workerGroups = CreateHTMLPagesByWorker(options, tasks);
end

%% Computes the features files for clipart
if ( options.processData2 ~= 0 )
    ConvertAllClipartToFeaturesTwoPerson(options, tasks);
    ComputeFeatures(options.fileINTERACTClipInstInfoData, options.fileINTERACTClipInstPoseData1, options.numPeople, options.isReal, ...
        options.numOrients, options.visualizeFeature);
    ComputeFeatures(options.fileINTERACTClipInstInfoData, options.fileINTERACTClipInstPoseData2, options.numPeople, options.isReal, ...
        options.numOrients, options.visualizeFeature);
    dlmwrite(options.fileINTERACTClipInstOrdering, ones(size(tasks)));
end

% Assumes the who's who has ran
%  createIllustrationInstanceDataset;