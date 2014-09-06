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

function workerGroupingIDs = GroupingImgsAmoungWorker(options)

    taskFile = options.fileINTERACTandAlexImgs;
    
    load(taskFile); % Load allTasksAlex
    tasks = allTasksAlex;
    
    refVals = [1; 2; 3];
    
    load(options.fileINTERACTavgPose); % loads avgPoseTasks

    allAssignmentStatuses = extractfield(tasks, 'assignmentstatus')';
    rejectedIdxs = strcmp(allAssignmentStatuses, 'Rejected');
    
    allAssignmentIDs = extractfield(tasks, 'assignmentid')';
    alexIdxs = ~cellfun(@isempty, strfind(allAssignmentIDs, 'alex'));
    
    rejectedTasks = tasks(rejectedIdxs);
    goodTasks = tasks( ~(alexIdxs | rejectedIdxs) );
    goodIDs = extractfield(goodTasks, 'assignmentid');
    badIDs  = extractfield(rejectedTasks, 'assignmentid');
    
     % all except rejected...
    allAssignmentIDs = extractfield(goodTasks, 'assignmentid')';
    allHITIDs = extractfield(goodTasks, 'hitid')'; % i.e., indirectly which verb it is

    [uniqueHITIDs, ~, idxInUnique] = unique(allHITIDs);

    refValsAssignmentIDList = [];
    refValsList = [];

    for i = 1:numel(uniqueHITIDs)
        refValsAssignmentIDList = [refValsAssignmentIDList; allAssignmentIDs(idxInUnique == i);];
        refValsList = [refValsList; refVals];
    end
    
    workerGroupingIDs = -1*ones(length(avgPoseTasks), 1);
    
    filenamesSplit = cellfun(@(x) strsplit(x, '_'), extractfield(avgPoseTasks, 'assignmentid'), 'UniformOutput', 0);
    filenamesFirst = cellfun(@(x) x{1}, filenamesSplit, 'UniformOutput', 0);
    
    for idxTask = 1:length(avgPoseTasks)
        mainPart = filenamesFirst{idxTask};
        if ( sum(strcmp(badIDs, mainPart)) > 0 )
            workerGroupingIDs(idxTask) = 4;
        elseif( sum(strcmp(goodIDs, mainPart)) > 0 )
            idxOfInt = strcmp(refValsAssignmentIDList , mainPart);
            workerGroupingIDs(idxTask) = refValsList(idxOfInt);
        end
    end
    
end