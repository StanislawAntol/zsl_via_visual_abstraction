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

function taskData = ParseMTurk(options)

    %% Open the AMT .results file
    MTurkFile = options.AMTFile;
    
    origData = readtext(options.AMTFile,'\t','','"','textual-empty2zero');
    origData = strrep(origData, '"', '');
    
    headers = lower(strrep(origData(1, :), '.', '_'));
    assignmentidLogIdx = strcmp(headers, 'assignmentid');
    allData = origData(2:end, :);
    data = strrep(allData( ~strcmp(allData(:, assignmentidLogIdx), '0'), : ), '''', ''); % Only select ones with actual data
    
    taskData = ProcessTaskData(options, headers, data);
%         
%     headers = lower(strrep(origData(1, :), '.', '_'));
% %     headers = strrep(headers, 'Answer_', '');
%     assignmentidLogIdx = strcmp(headers, 'assignmentid');
%     allData = origData(2:end, :);
%     
%     taskData = [];
%     for taskID = 1:size(allData, 1)
%         lineData = allData(taskID, :);
%         newTaskData = ProcessTaskData(options, lineData, headers);
%         if (isstruct(newTaskData))
%             taskData = [taskData; newTaskData];
%         end
%     end

end