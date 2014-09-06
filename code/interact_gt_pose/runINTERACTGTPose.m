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

if (options.parseAMTFile ~= 0)
    allTasks = ParseMTurk(options);
    
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

% tasks = tasks(1:2);

%% Creates images with pose annotations for all tasks
if ( options.processData1 ~= 0 )
    AnnotateAllPoses(options, tasks, 1);
end

%% Computes the average poses for all annotations
if ( options.processData2 ~= 0)
    avgPoseTasks = ComputingAllAveragePoses(options, tasks);
    missingPoseTask = MissingAnnotation(options);
    avgPoseTasks = [avgPoseTasks; missingPoseTask];
    save(options.outData2File, 'avgPoseTasks');
else
     load(options.outData2File);
end

CreateDatasetInfo(options, avgPoseTasks);

%% Creates images with pose annotations for averaged poses with head
if ( options.processData4 ~= 0 )
    AnnotateAllPoses(options, avgPoseTasks, 4);
end

%% Creates images with pose annotations for averaged poses without head
if ( options.processData5 ~= 0 )
    AnnotateAllPoses(options, avgPoseTasks, 5);
end

%% Creates 1 image with both pose annotations for averaged poses
if ( options.processData6 ~= 0 )
    AnnotateAllPoses(options, avgPoseTasks, 6);
end

%% Creates the HTML files for easy viewing of the pose annotations for all tasks
if ( options.createData1HTML ~= 0 )
    CreateHTMLPagesByVerb(options, tasks, 1);
    [workerIDs, workerGroups] = CreateHTMLPagesByWorker(options, tasks, 1);
end

%% Creates the HTML files for easy viewing of the averaged results (with head)
if ( options.createData4HTML ~= 0 )
    CreateHTMLPagesByVerb(options, avgPoseTasks, 4);
    [workerIDs, workerGroups] = CreateHTMLPagesByWorker(options, avgPoseTasks, 4);
end

%% Creates the HTML files for easy viewing of the averaged results (without head)
if ( options.createData5HTML ~= 0 )
    CreateHTMLPagesByVerb(options, avgPoseTasks, 5);
    [workerIDs, workerGroups] = CreateHTMLPagesByWorker(options, avgPoseTasks, 5);
end

%% Creates the HTML files for easy viewing of the averaged results (without head)
if ( options.createData6HTML ~= 0 )
    CreateHTMLPagesByVerb(options, avgPoseTasks, 6);
%     [workerIDs, workerGroups] = CreateHTMLPagesByWorker(options, avgPoseTasks, 6);
end