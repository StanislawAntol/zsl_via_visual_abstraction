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

    origData = readtext(options.AMTFile,',','','"','textual-empty2zero');
    origData = strrep(origData, '"', '');
    
    headers = lower(strrep(origData(1, :), '.', '_'));
    
    assignmentidLogIdx = strcmp(headers, 'assignmentid');
    allData = origData(2:end, :);
    data = strrep(allData( ~strcmp(allData(:, assignmentidLogIdx), '0'), : ), '''', ''); % Only select ones with actual data
    
    taskData = ProcessTaskData(options, headers, data);
    
end