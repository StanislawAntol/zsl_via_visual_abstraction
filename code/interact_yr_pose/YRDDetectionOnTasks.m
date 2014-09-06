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

function YRDDetectionOnTasks(options, model, avgPoseTasks, idxsBoxes)

    numIdxs = numel(idxsBoxes);
    for i = 1:numIdxs
        idx = idxsBoxes(i);
        avgPoseTask = avgPoseTasks(idx);

        filename = avgPoseTask.poseTasks(1).img;
        parts = strsplit(filename, '.');
        name = parts{1};

        img = LoadAnyImgAsRGB(options.imgDir, filename);

        dims = size(img);
        fprintf('idx: %d/%d, %s: dims=%dx%d, ', ...
                i, numIdxs, filename, dims(1), dims(2));

        % call detect function
        tic;
        boxes = detect_fast(img, model, min(model.thresh,-1));
        detTime = toc; % record cpu time
        fprintf('detTime= %f\n', detTime);

        saveFilename = fullfile(options.data1Folder, [name, '.mat']);
        save(saveFilename, 'filename', 'boxes', 'detTime');
    end

    fprintf('Done with YR Default Detection.\n');

end