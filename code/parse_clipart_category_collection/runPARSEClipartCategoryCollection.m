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

%% Creates the result images and saves them as image files
if ( options.renderAndSaveIllustractions ~= 0 )
    RenderTaskScenes(options, tasks);
end

%% Computes the features files for clipart
if ( options.computeFeatures ~= 0 )
    ConvertAllClipartToFeaturesOnePerson(options, tasks);
    ComputeFeatures(options.infoDataFile, options.poseDataFile1, options.numPeople, options.isReal, ...
        options.numOrient, options.visualizeFeature);
end

%% Creates the HTML files for easy viewing of the results
if ( options.createHTML ~= 0 )
    CreateHTMLPagesByVerb(options, tasks);
    workerGroups = CreateHTMLPagesByWorker(options, tasks);
end

