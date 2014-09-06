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

function [taskAMT, taskData] = ProcessRealExprResultsData(options)

    imgBase = options.imgBase;

    origData = readtext(options.exprResults,',','','""','textual-empty2zero');
    origData = strrep(origData, '"', '');

    headers = strrep(origData(1, :), '.', '_');
    headers = strrep(headers, 'Answer_', '');
    headers = strrep(headers, 'Input_', '');
    headers = lower(headers);
    assignmentidLogIdx = strcmp(headers, 'assignmentid');
    allData = origData(2:end, :);
    data = strrep(allData( ~strcmp(allData(:, assignmentidLogIdx), '0'), : ), '''', ''); % Only select ones with actual data
    data = strrep(data, imgBase, '');

    %% Extract different parts of data
    % Make sure we sort input and output in numeric order
    
    idxsImgTemp = find(not(cellfun('isempty', strfind( headers, 'im_'))))';
    [~, idxsImgSorted] = sort(str2double( strrep(headers(idxsImgTemp), 'im_', '') ));
    idxsImg = idxsImgTemp(idxsImgSorted);
    
    idxsExprTemp = find(not(cellfun('isempty', strfind( headers, 'exp_'))))';
    [~, idxsExprSorted] = sort(str2double( strrep(headers(idxsExprTemp), 'exp_', '') ));
    idxsExpr = idxsExprTemp(idxsExprSorted);
    
    idxsNE2Temp = find(not(cellfun('isempty', strfind( headers, 'off_'))))';
    [~, idxsNE2Sorted] = sort(str2double( strrep(headers(idxsNE2Temp), 'off_', '') ));
    idxsNE2 = idxsNE2Temp(idxsNE2Sorted);
    idxsAMT = setdiff([1:length(headers)]', [idxsImg; idxsExpr; idxsNE2]);

    taskAMT = cell2struct(data(:, idxsAMT), headers(idxsAMT), 2);
    taskImg = [data(:, idxsImg)];
    [unqImgs, unqImgA, unqImgC] = unique(taskImg);

    taskExpr = str2double(data(:, idxsExpr));
    taskExpr(isnan(taskExpr)) = 0;
    taskNE2 = str2double(data(:, idxsNE2));
    taskNE2(isnan(taskNE2)) = 0;
    % Clean up the few people that marked everything
    taskNE2BadIdxs = find( (sum(taskNE2, 2) > 10) );
    taskNE2(taskNE2BadIdxs, :) = 0;
    assignmentIDs = repmat(extractfield(taskAMT, 'assignmentid')', 1, size(taskExpr, 2));

    taskData = [];
    % i = 1 is empty/no image
    for i = 2:length(unqImgs)
        taskDatum = [];
        taskDatum.imgPose = unqImgs{i};
        parts = strsplit(unqImgs{i}, '_');
        taskDatum.img = strjoin(parts(1:end-2), '_');
        imgIdxs = unqImgC == unqImgC(unqImgA(i));
        taskDatum.votesExpr = taskExpr(imgIdxs);
        taskDatum.votesNE2 = taskNE2(imgIdxs);
        taskDatum.votesAssignIDs = assignmentIDs(imgIdxs);
        taskData = [taskData; taskDatum];
    end
end