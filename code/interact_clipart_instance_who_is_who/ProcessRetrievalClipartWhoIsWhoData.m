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

function ProcessRetrievalClipartWhoIsWhoData(options, taskAMT, taskData)

    retrClipImgNames = extractfield(taskData, 'imgClipart');
    numTaskData = length(taskData);
    whoCell = cell(numTaskData, 2);
    
    for i = 1:numTaskData
        data = taskData(i)';
        for j = 1:length(data)
           votes = data(j).votesWho;
           votesZero = votes == 0;
           if ( sum(votesZero) > 0 )
               fprintf('Warning: "no response" was a vote."\n');
               votes(votesZero) = randi(2, sum(votesZero), 1);
           end
           vote = mode(votes);
           
           whoCell{i, 1} = vote;
           whoCell{i, 2} = retrClipImgNames{i};
        end
    end

    

    cell2csv(options.whoIsWhoFile, whoCell, ';');

end