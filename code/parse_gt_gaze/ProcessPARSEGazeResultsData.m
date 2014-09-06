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

function [taskAMT, taskData] = ProcessPARSEGazeResultsData(options)

    imgBase = options.imgBase;

    origData = readtext(options.gazeResults,',','','""','textual-empty2zero');
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
    
    idxsGazeTemp = find(not(cellfun('isempty', strfind( headers, 'exp_'))))';
    [~, idxsGazeSorted] = sort(str2double( strrep(headers(idxsGazeTemp), 'exp_', '') ));
    idxsGaze = idxsGazeTemp(idxsGazeSorted);
    
    idxsBadAnnTemp = find(not(cellfun('isempty', strfind( headers, 'off_'))))';
    [~, idxsBadAnnSorted] = sort(str2double( strrep(headers(idxsBadAnnTemp), 'off_', '') ));
    idxsBadAnn = idxsBadAnnTemp(idxsBadAnnSorted);
    idxsAMT = setdiff([1:length(headers)]', [idxsImg; idxsGaze; idxsBadAnn]);

    taskAMT = cell2struct(data(:, idxsAMT), headers(idxsAMT), 2);
    taskImg = [data(:, idxsImg)];
    [unqImgs, unqImgA, unqImgC] = unique(taskImg);

    taskGaze = str2double(data(:, idxsGaze));
    taskGaze(isnan(taskGaze)) = 0;
    taskBadAnn = str2double(data(:, idxsBadAnn));
    taskBadAnn(isnan(taskBadAnn)) = 0;
    % Clean up the few people that marked everything
    taskBadAnnBadIdxs = find( (sum(taskBadAnn, 2) > 10) );
    taskBadAnn(taskBadAnnBadIdxs, :) = 0;
    assignmentIDs = repmat(extractfield(taskAMT, 'assignmentid')', 1, size(taskGaze, 2));

    taskData = [];
    noBadAnns = zeros(10, 1);
    % i = 1 is empty/no image
    for i = 2:length(unqImgs)
        taskDatum = [];
        taskDatum.imgPose = unqImgs{i};
        parts = strsplit(unqImgs{i}, '_');
        taskDatum.img = parts{1};
        imgIdxs = unqImgC == unqImgC(unqImgA(i));
        taskDatum.votesGaze = taskGaze(imgIdxs);
        taskDatum.votesBadAnn = noBadAnns;
        taskDatum.votesAssignIDs = assignmentIDs(imgIdxs);
        taskData = [taskData; taskDatum];
    end
end