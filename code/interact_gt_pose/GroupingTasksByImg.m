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

function verbGroups = GroupingTasksByImg(options, inputTasks, verbs)

    load(options.imgsMatFile); % loads 'tasks' which is the database images
    
    try
        tasks = allTasks;
    catch
        tasks = allTasksAlex; % full_exp_1 hack
    end

    %     for i = 1:(numel(tasks)-1)
%         pairFormat = '{ "assignmentid":"%s", "sentence":"%s" },\n';
%         fprintf(fid, pairFormat, tasks(i).assignmentid, tasks(i).sentence);
%     end
%     
%     pairFormat = '{ "assignmentid":"%s", "sentence":"%s" }\n';
%     fprintf(fid, pairFormat, tasks(i).assignmentid, tasks(i).sentence);
%     fprintf(fid, ']\n}\n');

    numVerbs = numel(verbs);
    verbGroups = cell(numVerbs, 2);
    numTasks = numel(inputTasks);

    for t = 1:numTasks
        inputTask = inputTasks(t);
        imgs = extractfield(inputTask.poseTasks, 'img');
        for i = 1:numel(imgs)
            verbPhrase = GetVerbFromImgName(tasks, imgs{i});
            matchIdx = strcmp(verbs, verbPhrase);
            verbIdx = find( matchIdx );
            verbGroups{verbIdx, 1} = union(verbGroups{verbIdx, 1}', imgs(i))';
        end

    end
    
    for i = 1:numVerbs
        numImgsPerVerb = numel(verbGroups{i, 1});
        verbGroups{i, 2} = cell( numImgsPerVerb, 1); 
    end

    for t = 1:numTasks
        inputTask = inputTasks(t);
        imgs = extractfield(inputTask.poseTasks, 'img');
        for i = 1:numel(imgs)
            verbPhrase = GetVerbFromImgName(tasks, imgs{i});
            matchIdx = strcmp(verbs, verbPhrase);
            verbIdx = find( matchIdx );
            imgsForCurVerb = verbGroups{verbIdx};
            
            matchIdx = strcmp(imgsForCurVerb, imgs{i});
            imgIdx = find( matchIdx );
            
            sentencePairs = verbGroups{verbIdx, 2};
            sentencePairs{imgIdx, 1} = [sentencePairs{imgIdx, 1}; [t, i] ];
            verbGroups{verbIdx, 2} = sentencePairs;
        end
    end

end