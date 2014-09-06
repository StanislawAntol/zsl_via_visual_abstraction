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

function [taskAMT, taskData] = ProcessRetrievalClipartWhoIsWhoResultsData(options)


    origData = readtext(options.AMTInput, ',', '', '""', 'textual-empty2zero');
    origData = strrep(origData, '"', '');

    headers = strrep(origData(1, :), '.', '_');
    headers = strrep(headers, 'Answer_', '');
    headers = strrep(headers, 'Input_', '');
    headers = lower(headers);
    assignmentidLogIdx = strcmp(headers, 'assignmentid');
    allData = origData(2:end, :);
    data = strrep(allData( ~strcmp(allData(:, assignmentidLogIdx), '0'), : ), '''', ''); % Only select ones with actual data

    %% Extract different parts of data
    % Make sure we sort input and output in numeric order
    
    idxsSourceTemp = find(not(cellfun('isempty', strfind( headers, 'source_'))))';
    [~, idxsSourceSorted] = sort(str2double( strrep(headers(idxsSourceTemp), 'source_', '') ));
    idxsSource = idxsSourceTemp(idxsSourceSorted);
    
    idxsTargetTemp = find(not(cellfun('isempty', strfind( headers, 'target_'))))';
    [~, idxsTargetSorted] = sort(str2double( strrep(headers(idxsTargetTemp), 'target_', '') ));
    idxsTarget = idxsTargetTemp(idxsTargetSorted);
    
    idxsWhoTemp = find(not(cellfun('isempty', strfind( headers, 'who_'))))';
    [~, idxsWhoSorted] = sort(str2double( strrep(headers(idxsWhoTemp), 'who_', '') ));
    idxsWho = idxsWhoTemp(idxsWhoSorted);
    
    idxsAMT = setdiff([1:length(headers)]', [idxsSource; idxsTarget; idxsWho]);

    taskAMT = cell2struct(data(:, idxsAMT), headers(idxsAMT), 2);
    taskSourceImg = [data(:, idxsSource)];
    [unqSourceImgs, unqSourceImgA, unqSourceImgC] = unique(taskSourceImg);

    taskWho = str2double(data(:, idxsWho));
    taskWho(isnan(taskWho)) = 0;
    assignmentIDs = repmat(extractfield(taskAMT, 'assignmentid')', 1, size(taskWho, 2));

    taskData = [];
    
    for i = 1:length(unqSourceImgs)
        taskDatum = [];
        taskDatum.imgClipart = unqSourceImgs{i};
        imgIdxs = unqSourceImgC == unqSourceImgC(unqSourceImgA(i));
        taskDatum.votesWho = taskWho(imgIdxs);
        taskDatum.votesAssignIDs = assignmentIDs(imgIdxs);
        taskData = [taskData; taskDatum];
    end
end