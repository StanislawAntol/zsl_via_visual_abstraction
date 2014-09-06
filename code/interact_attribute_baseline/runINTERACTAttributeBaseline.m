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
parameters = CreateParameters();

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

workerIDs = unique(extractfield(tasks, 'workerid'))';
numWorkers = length(workerIDs);

HITIDs = unique(extractfield(tasks, 'hitid'))';
numUniqueHITs = length(HITIDs);

comments = extractfield(tasks, 'comments')';
actualComments = comments(~cellfun('isempty', comments));

if ( options.processData1 ~= 0 )
    verbPhraseAttrData = AverageSentenceAttributes(options, parameters, tasks);
    save(options.fileINTERACTAttributeData, 'verbPhraseAttrData');
else
    load(options.fileINTERACTAttributeData);
end