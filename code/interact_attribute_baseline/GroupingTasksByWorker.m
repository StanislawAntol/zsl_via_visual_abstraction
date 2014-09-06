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

function [uniqueWorkerIDs, workerGroups] = GroupingTasksByWorker(tasks)

    allWorkerIDs = extractfield(tasks, 'workerid');
    % idxB maps allWorkerIDs to an index in uniqueWorkerIDs
    [uniqueWorkerIDs, ~, idxB] = unique(allWorkerIDs);

    numWorkers = numel(uniqueWorkerIDs);
    disp(sprintf('There are %d unique workers.', numWorkers));
    workerGroups = cell(numWorkers, 1);

    for w = 1:length(idxB)
        workerGroups{idxB(w), 1} = [workerGroups{idxB(w), 1} w];
    end
    
end