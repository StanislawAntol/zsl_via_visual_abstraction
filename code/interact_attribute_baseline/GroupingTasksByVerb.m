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

function verbGroups = GroupingTasksByVerb(options, tasks, verbs)
    numVerbs = numel(verbs);
    verbGroups = cell(numVerbs, 1);
    numTasks = numel(tasks);

    for v = 1:numVerbs
        verb = verbs{v};
        for t = 1:numTasks
            task = tasks(t);
            sentences = extractfield(task.scenes, 'sent');
            matchStartPos = strfind(sentences, verb);
            matchIdx = ~cellfun('isempty', matchStartPos);
            sceneIdxs = find( matchIdx );
            for s = 1:length(sceneIdxs)
               array = [verbGroups{v}; [t, sceneIdxs(s)]]; 
               verbGroups{v} = array;
            end
        end
    end
end