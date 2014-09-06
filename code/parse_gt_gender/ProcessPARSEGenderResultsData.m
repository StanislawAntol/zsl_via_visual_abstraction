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

function [taskAMT, taskData] = ProcessPARSEGenderResultsData(options)

    imgBase = options.imgBase;

    origData = readtext(options.gendResults,',','','""','textual-empty2zero');
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
    
    idxsGenderTemp = find(not(cellfun('isempty', strfind( headers, 'exp_'))))';
    [~, idxsGenderSorted] = sort(str2double( strrep(headers(idxsGenderTemp), 'exp_', '') ));
    idxsGender = idxsGenderTemp(idxsGenderSorted);
    
    idxsAMT = setdiff([1:length(headers)]', [idxsImg; idxsGender]);

    taskAMT = cell2struct(data(:, idxsAMT), headers(idxsAMT), 2);
    taskImg = [data(:, idxsImg)];
    [unqImgs, unqImgA, unqImgC] = unique(taskImg);

    taskGender = str2double(data(:, idxsGender));
    taskGender(isnan(taskGender)) = 0;
    assignmentIDs = repmat(extractfield(taskAMT, 'assignmentid')', 1, size(taskGender, 2));

    taskData = [];
    % i = 1 is empty/no image
    for i = 2:length(unqImgs)
        taskDatum = [];
        taskDatum.imgPose = unqImgs{i};
        parts = strsplit(unqImgs{i}, '_');
        taskDatum.img = parts{1};
        imgIdxs = unqImgC == unqImgC(unqImgA(i));
        taskDatum.votesGender = taskGender(imgIdxs);
        taskDatum.votesAssignIDs = assignmentIDs(imgIdxs);
        taskData = [taskData; taskDatum];
    end
end