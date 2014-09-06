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

function YRBBDetectionOnTasks(options, model, avgPoseTasks, idxsDet)

    visualize = 0;
    
    numIdxs = numel(idxsDet);
    for i = 1:numIdxs
        idx = idxsDet(i);
        avgPoseTask = avgPoseTasks(idx);
        poseTasks = avgPoseTask.poseTasks;

        filename = avgPoseTask.poseTasks(1).img;
        parts = strsplit(filename, '.');
        name = parts{1};

        img = LoadAnyImgAsRGB(options.imgDir, filename);
        
        if ( visualize ~= 0 )
            clf
            subplot(2, 2, 1)
            imshow(img)
        end
        
        for j = 1:numel(poseTasks)
            pose = poseTasks(j).pose;
            occl = poseTasks(j).occluded;
            validIdxs = occl == 0;
            validPose = pose(validIdxs, :);
            
            [croppedImg, minIdxs, maxIdxs] = cropImgForPose(img, validPose);
            dims = size(croppedImg);
            
            if ( visualize ~= 0 )
                subplot(2, 2, 2+j)
                imshow(croppedImg);
            end
            
            fprintf('idx: %d/%d,%s: dims=%dx%d, ', ...
                i, numIdxs, filename, dims(1), dims(2));
            
            % call detect function
            tic;
            boxes = detect_fast(croppedImg, model, min(model.thresh,-1));
            detTime = toc; % record cpu time
            fprintf('detTime= %f\n', detTime);
            
            saveFilename = fullfile(options.data2Folder, sprintf('%s_%02d.mat', name, j));
            save(saveFilename, 'filename', 'boxes', 'minIdxs', 'maxIdxs', 'detTime');
        end
        if ( visualize ~= 0 )
            pause
        end
    end

    fprintf('Done with YR BB Detection.\n');

end

function [croppedImg, minIdxs, maxIdxs] = cropImgForPose(img, pose)

    filteredPose = round(pose);

    dims = size(img);
    dims = [dims(2) dims(1)]; % swap for 'easier' comparison later


    minVals = min(filteredPose, [], 1);
    maxVals = max(filteredPose, [], 1);

    lengths = maxVals - minVals;
    
    if ( sum(lengths) == 0 ) % Only 1 point?
        lengths = dims./4;
    elseif ( lengths(1) == 0 )
        lengths(1) = lengths(2);
    elseif ( length(2) == 0 )
        lengths(2) = lengths(1);
    end

    offsets = round(lengths.*scaleFactors(lengths, dims) );
    minIdxs = minVals-offsets;
    maxIdxs = maxVals+offsets;

    % lower bound indices
    minIdxs( minIdxs < 1 ) = 1;
    % upper bound indices
    maxIdxs( maxIdxs > dims ) = dims( maxIdxs > dims );

    xIdxs = minIdxs(1):maxIdxs(1);
    yIdxs = minIdxs(2):maxIdxs(2);

    croppedImg = img(yIdxs, xIdxs, :);

end

function scales = scaleFactors(L, dims)

    scales = 3*exp(-5*L./(dims) );

end