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

function tasks = ProcessUserURLs(options, taskStruct, resHeaders, resData)

    tasks = taskStruct;
    
    [tasks.sentence] = tasks.input_verb_phrase;
    tasks = rmfield(tasks, 'input_verb_phrase');
    
    [tasks.comments] = tasks.answer_comments;
    tasks = rmfield(tasks, 'answer_comments');
    
    numURLs = size(resData, 2);
    idxURLs = [];
    for idxResData = 1:numURLs
        idxURLs = [idxURLs; str2num(resHeaders{idxResData}(11:end))];
    end

    for idxStruct = 1:size(resData, 1)
        tasks(idxStruct).urls = cell(numURLs, 1);
        for idxResData = 1:numURLs
            tasks(idxStruct).urls{idxURLs(idxResData)} = ...
                resData{idxStruct, idxResData};
        end
    end

end