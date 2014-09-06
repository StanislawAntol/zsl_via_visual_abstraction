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

function CreateDatasetInfo(options, tasks)

    numTasks = size(tasks, 1);
    
    verbs = GetINTERACTVerbs(options);
    verbLabels = 1:length(verbs);
    fid = fopen(options.fileInitDatasetVerbs, 'w');
    for i = 1:length(verbLabels)
        fprintf(fid, '%02d;%s\n', verbLabels(i), verbs{i});
    end
    fclose(fid);

    fid = fopen(options.fileInitDatasetInfo, 'w');

    for i = 1:numTasks
        task = tasks(i);
        verbName  = task.verb;
        verbLabel = verbLabels(strcmp(verbs, verbName));
        imgName   = task.poseTasks(1).img;
        fprintf(fid, '%02d;%s;%s\n', verbLabel, imgName, verbName);
    end
    
    fclose(fid);
    
    workerGroupingIDs = GroupingImgsAmoungWorker(options);
    dlmwrite(options.fileWorkerGroupings, workerGroupingIDs, ';');
end