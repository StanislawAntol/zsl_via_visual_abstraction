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

function ExtractPosesFromYRBBBoxes(options, model, avgPoseTasks, idxsBoxes)

parentList = ComputeParentList(model);

displayStickmen = 0;

NMSScale = 1.05; % rate to increase threshold if don't have 2 boxes
initNMSThreshold = 0.01;
upperNMSThresholdBound = 0.99;

options.numParts = 14;

infoFID  = fopen(options.infoDataBBFile , 'w');
poseFID1 = fopen(options.poseDataBBFile1, 'w');
poseFID2 = fopen(options.poseDataBBFile2, 'w');

badIdxs = [];

for j = 1:numel(idxsBoxes)
    i = idxsBoxes(j);
    avgPoseTask = avgPoseTasks(i);
    poseTasks = avgPoseTask.poseTasks;
    
    imgFilename = poseTasks(1).img;
    parts = strsplit(imgFilename, '.');
    imgFilenameWOExt = parts{1};
    
    try
        imgInfo = imfinfo(fullfile(options.imgDir, imgFilename));    
        imgDims = [imgInfo.Height, imgInfo.Width, imgInfo.NumberOfSamples];
    catch
        img = LoadAnyImgAsRGB(options.imgDir, imgFilename);
        imgDims = size(img);
    end
    cropOffsets = repmat([0, 0], 14, 1); 
        
    for offset = [1 2]
        boxDataFile = sprintf('%s_%02d.mat', imgFilenameWOExt, offset);
        load(fullfile(options.data2Folder, boxDataFile));
        % loads boxes (and detTime...)
    
        cropOffsets = repmat(minIdxs, 14, 1);

        enoughBoxes = 1;
        
        if ( size(boxes, 1) > 1 )
            
            NMSThreshold = initNMSThreshold;
            NMSBoxes = nms(boxes, NMSThreshold); % nonmaximal suppression

            while ( (size(NMSBoxes, 1) < 1) )
                
                NMSThreshold = NMSScale*NMSThreshold;

                % Keep increasing threshold until two boxes over over threshold
                % overlap
                if ( (NMSThreshold > upperNMSThresholdBound) ) 
%                     size(NMSBoxes, 1)
%                     NMSThreshold
                    enoughBoxes = 0;
                    break;
                end

                NMSBoxes = nms(boxes, NMSThreshold); % nonmaximal suppression
            end

            if ( (enoughBoxes == 1) )
                poses{offset} = GetSkeletonPose(NMSBoxes(1, :), parentList) + cropOffsets;
                
                if ( displayStickmen ~= 0 )
                    clf
                    img = LoadAnyImgAsRGB(options.imgDir, filename);
                    ShowSkeletonsBB(img, NMSBoxes(1, :), options.colorset, parentList, minIdxs, maxIdxs);
%                     pause( );
                end
            else
                if ( size(NMSBoxes, 1) >= 1 )
                    fprintf('>=1\n');
                    poses{offset} = GetSkeletonPose(NMSBoxes(1, :), parentList) + cropOffsets;
                else
                    fprintf('=0\n');
                    if ( size(boxes, 1) >= 1 )
                        poses{offset} = GetSkeletonPose(boxes(1, :), parentList) + cropOffsets;
                        disp('boxes >= 1\n, %d', j);
                    else
                        poses{offset} = -1*ones(options.numParts, 2);
                    end
                end
            end
        else
            if ( size(boxes, 1) >= 1 )
                poses{offset} = GetSkeletonPose(boxes(1, :), parentList) + cropOffsets;
            else
                poses{offset} = -1*ones(options.numParts, 2);
            end
        end
    end
    
    allowOffset = 15;
    validPose1 = (poses{1} >= -1) & ( [ ( poses{1}(:, 1) <= (imgDims(2) + allowOffset) ), ( poses{1}(:, 2) <= (imgDims(1) + allowOffset) )] );
    validPose2 = (poses{2} >= -1) & ( [ ( poses{2}(:, 1) <= (imgDims(2) + allowOffset) ), ( poses{2}(:, 2) <= (imgDims(1) + allowOffset) )] );
    
    missingPose1 = sum(sum( poses{1} == -1 )) > 0;
    missingPose2 = sum(sum( poses{2} == -1 )) > 0;
    
    if ( sum(sum(~validPose1)) || sum(sum(~validPose2)) )
        %         fprintf('%d, %s\n', i, imgFilename);
        badIdxs = [badIdxs; i];
    end
    
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

fclose(infoFID);
fclose(poseFID1);
fclose(poseFID2);