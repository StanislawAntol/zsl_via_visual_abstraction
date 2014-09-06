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

function tasks = ProcessUserScenes(options, taskStruct, resHeaders, resData)

    headersWithSents = strfind( resHeaders, 'sent');
    sentsIdxs = find(not(cellfun('isempty', headersWithSents)));
    headersWithPoses = strfind( resHeaders, 'poses');
    posesIdxs = find(not(cellfun('isempty', headersWithPoses)));
    headersWithPerson1 = strfind( resHeaders, 'person1');
    person1Idxs = find(not(cellfun('isempty', headersWithPerson1)));
    headersWithPerson2 = strfind( resHeaders, 'person2');
    person2Idxs = find(not(cellfun('isempty', headersWithPerson2)));
    
    inputs = extractfield(taskStruct, 'annotation');

    counter = 1;
    tasks = taskStruct;
    names = fieldnames(tasks);
    namesInput = strfind(names, 'in_');
    numInputs = sum(~cellfun(@isempty, namesInput));
    
    for idxStruct = 1:size(resData, 1)
        tasks(idxStruct).sentences = [];
        newSentence = struct();
        for idxSent = 1:numInputs
            eval(sprintf('sent = tasks(idxStruct).in_%02d_vp;', idxSent));
            
            eval(sprintf('contH = tasks(idxStruct).out_%02d_AH;', idxSent));
            eval(sprintf('contE = tasks(idxStruct).out_%02d_AE;', idxSent));
            eval(sprintf('contK = tasks(idxStruct).out_%02d_AK;', idxSent));
            eval(sprintf('contF = tasks(idxStruct).out_%02d_AF;', idxSent));
            
            eval(sprintf('expr = tasks(idxStruct).out_%02d_expr1;', idxSent));
            eval(sprintf('gaze = tasks(idxStruct).out_%02d_gaze1;', idxSent));
            eval(sprintf('gend = tasks(idxStruct).out_%02d_gend1;', idxSent));

            newSentence.sent = sent;
            
            % All questions were about A relative to B, and position in
            % sentence changed.
            if ( strcmp(sent(1), '1') ) % One means: A <verb phrase> B.
                newSentence.A_cont = ComputeSimpleContactFeat(options, contH, contE, contK, contF);
                newSentence.A_expr = sscanf(expr, '%d');
                newSentence.A_gaze = sscanf(gaze, '%d');
                newSentence.A_gend = sscanf(gend, '%d');
                
                newSentence.B_cont = [];
                newSentence.B_expr = [];
                newSentence.B_gaze = [];
                newSentence.B_gend = [];
            elseif ( strcmp(sent(1), '2') ) % Two means: B <verb phrase> A.
                newSentence.A_cont = [];
                newSentence.A_expr = [];
                newSentence.A_gaze = [];
                newSentence.A_gend = [];
                
                newSentence.B_cont = ComputeSimpleContactFeat(options, contH, contE, contK, contF);
                newSentence.B_expr = sscanf(expr, '%d');
                newSentence.B_gaze = sscanf(gaze, '%d');
                newSentence.B_gend = sscanf(gend, '%d');
            else
                fprintf('Error with sentence for task(%d).', idxStruct);
            end
            
            tasks(idxStruct).sentences = [tasks(idxStruct).sentences; newSentence];
            counter = counter+1;
        end
    end
end