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

%% Creates the result images and saves them as image files
if ( options.processData1 ~= 0 )
    RenderTaskScenes(options, tasks);
end

%% Creates the HTML files for easy viewing of the results
if ( options.createHTML ~= 0 )
    createHTMLPagesByVerb(options, tasks);
    workerGroups = createHTMLPagesByWorker(options, tasks);
end

%% Computes the features files for clipart
if ( options.processData2 ~= 0 )
    ConvertAllClipartToFeaturesTwoPerson(options, tasks);
    numPeople = 2;
    isReal = 0;
    numOrients = 12;
    visualizeFeature = 0;
    noise = [];
    ComputeFeatures(options.fileINTERACTClipCatInfoData, options.fileINTERACTClipCatPoseData1, numPeople, ...
        isReal, numOrients, visualizeFeature, noise);
    ComputeFeatures(options.fileINTERACTClipCatInfoData, options.fileINTERACTClipCatPoseData2, numPeople, ...
        isReal, numOrients, visualizeFeature, noise);
end

%  createIllustrationCategoryDataset;