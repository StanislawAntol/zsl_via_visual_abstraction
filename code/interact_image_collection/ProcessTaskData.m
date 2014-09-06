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

function taskData = ProcessTaskData(options, headers, data)

    headersWithRes = strfind( headers, 'answer_url');
    resIdxs = find(not(cellfun('isempty', headersWithRes)));
    nonResIdxs = setdiff(1:length(headers), resIdxs);

    taskStruct = cell2struct(data(:, nonResIdxs), headers(nonResIdxs), 2);

    resHeaders = headers(:, resIdxs);
    resData    = data(:, resIdxs);

    taskData = ProcessUserURLs(options, taskStruct, resHeaders, resData);

end