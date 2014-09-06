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

function ExtractPosesFromYRDBoxes(options, model, avgPoseTasks, idxsBoxes)

    addpath(fullfile(options.folders3rdParty{options.idxYRPose}, 'visualization'));
    
    parentList = ComputeParentList(model);

    displayStickmen = 0;

    NMSScale = 1.05; % rate to increase threshold if don't have 2 boxes
    initNMSThreshold = 0.01;
    upperNMSThresholdBound = 0.99;

    infoFID  = fopen(options.infoDataDFile , 'w');
    poseFID1 = fopen(options.poseDataDFile1, 'w');
    poseFID2 = fopen(options.poseDataDFile2, 'w');

    for j = 1:numel(idxsBoxes)
        i = idxsBoxes(j);
        avgPoseTask = avgPoseTasks(i);
        poseTasks = avgPoseTask.poseTasks;

        imgFilename = poseTasks(1).img;
        parts = strsplit(imgFilename, '.');
        imgFilenameWOExt = parts{1};

        boxDataFile = sprintf('%s.mat',imgFilenameWOExt);
        load(fullfile(options.data1Folder, boxDataFile));
        % loads boxes (and detTime...)

        try
            imgInfo = imfinfo(fullfile(options.imgDir, imgFilename));
            imgDims = [imgInfo.Height, imgInfo.Width, imgInfo.NumberOfSamples];
        catch
            img = LoadAnyImgAsRGB(options.imgDir, imgFilename);
            imgDims = size(img);
        end

        if ( displayStickmen ~= 0 )
            %         disp(imgFilename);
        end
        
        enoughBoxes = 1;

        % If there are more than 2 detections,
        % we first have a very strict NMS threshold.
        % If that results in less than 2 boxes,
        % then we want to permit more overlap (by increasing threshold)
        % until there are 2 or more boxes

        if ( size(boxes, 1) > 2 )

            NMSThreshold = initNMSThreshold;
            NMSBoxes = nms(boxes, NMSThreshold); % nonmaximal suppression

            while ( (size(NMSBoxes, 1) < 2) )

                NMSThreshold = NMSScale*NMSThreshold;

                % Keep increasing threshold until two boxes don't overlap
                %
                if ( (NMSThreshold > upperNMSThresholdBound) )
                    %                 size(NMSBoxes, 1)
                    %                 NMSThreshold
                    enoughBoxes = 0;
                    break;
                end

                NMSBoxes = nms(boxes, NMSThreshold); % nonmaximal suppression
            end

            if ( (enoughBoxes == 1) )
                poses{1} = GetSkeletonPose(NMSBoxes(1, :), parentList);
                poses{2} = GetSkeletonPose(NMSBoxes(2, :), parentList);

                if ( displayStickmen ~= 0 )
                    clf
                    showskeletons(img, NMSBoxes(1:2, :), options.colorset, parentList);
                    pause(.5);
                end
            else
                if ( size(NMSBoxes, 1) >= 2 )
                    fprintf('>=2\n');
                    poses{1} = GetSkeletonPose(NMSBoxes(1, :), parentList);
                    poses{2} = GetSkeletonPose(NMSBoxes(2, :), parentList);
                elseif ( size(NMSBoxes, 1) == 1 )
                    fprintf('=1\n');
                    poses{1} = GetSkeletonPose(NMSBoxes(1, :), parentList);
                    poses{2} = -1*ones(options.numParts, 2);
                else
                    fprintf('=0\n');
                    if ( size(boxes, 1) >= 2 )
                        poses{1} = GetSkeletonPose(boxes(1, :), parentList);
                        poses{2} = GetSkeletonPose(boxes(2, :), parentList);
                    elseif ( size(boxes, 1) == 1 )
                        poses{1} = GetSkeletonPose(boxes(1, :), parentList);
                        poses{2} = -1*ones(options.numParts, 2);
                    else
                        poses{1} = -1*ones(options.numParts, 2);
                        poses{2} = -1*ones(options.numParts, 2);
                    end
                end
            end
        else
            fprintf('Only 2 or less\n');
            if ( size(boxes, 1) >= 2 )
                poses{1} = GetSkeletonPose(boxes(1, :), parentList);
                poses{2} = GetSkeletonPose(boxes(2, :), parentList);
            elseif ( size(boxes, 1) == 1 )
                poses{1} = GetSkeletonPose(boxes(1, :), parentList);
                poses{2} = -1*ones(options.numParts, 2);
            else
                poses{1} = -1*ones(options.numParts, 2);
                poses{2} = -1*ones(options.numParts, 2);
            end
        end

        validPose1 = (poses{1} >= -1) & ( [ ( poses{1}(:, 1) <= (imgDims(2) + 10) ), ( poses{1}(:, 2) <= (imgDims(1) + 10) )] );
        validPose2 = (poses{2} >= -1) & ( [ ( poses{2}(:, 1) <= (imgDims(2) + 10) ), ( poses{2}(:, 2) <= (imgDims(1) + 10) )] );

        missingPose1 = sum(sum( poses{1} == -1 )) > 0;
        missingPose2 = sum(sum( poses{2} == -1 )) > 0;

        %     if ( sum(sum(~validPose1)) || sum(sum(~validPose2)) )
        % %         fprintf('%d, %s\n', i, imgFilename);
        %         badIdxs = [badIdxs; i];
        %     end

        poseData1 = [reshape(poses{1}', 2*options.numParts, 1);
            reshape(poses{2}', 2*options.numParts, 1)];
        poseData2 = [reshape(poses{2}', 2*options.numParts, 1);
            reshape(poses{1}', 2*options.numParts, 1)];

        numData = numel(poseData1);
        for k = 1:(numData-1)
            fprintf(poseFID1, '%f;', poseData1(k));
            fprintf(poseFID2, '%f;', poseData2(k));
        end

        fprintf(poseFID1, '%f\n', poseData1(end));
        fprintf(poseFID2, '%f\n', poseData2(end));
        fprintf(infoFID, '%s;%d;%d\n', imgFilename, missingPose1, missingPose2);

    end
    % badIdxs

    fclose(infoFID);
    fclose(poseFID1);
    fclose(poseFID2);

end