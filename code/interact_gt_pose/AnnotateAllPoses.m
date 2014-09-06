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

function AnnotateAllPoses(options, tasks, whichData)

if ( whichData == 1 )
    dataFolder  = options.data1Folder;
    withoutHead = 0;
    bothPoses = 0;
elseif ( whichData == 4 )
    dataFolder  = options.data4Folder;
    withoutHead = 0;
    bothPoses = 0;
elseif ( whichData == 5 )
    dataFolder = options.data5Folder;
    withoutHead = 1;
    bothPoses = 0;
elseif ( whichData == 6 )
    dataFolder = options.data6Folder;
    withoutHead = 1;
    bothPoses = 1;
end

count = 0;
numTasks = size(tasks, 1);
filesStruct = dir(dataFolder);
files = extractfield(filesStruct, 'name')';
% Get rid of the current folder and previous folder links
files = setdiff(files, '.');
files = setdiff(files, '..');

for i = 1:numTasks
    task = tasks(i);
    
    if ( bothPoses == 0 )
        for j = 1:numel(task.poseTasks)
            % Progress update
            if (mod(count, 50) == 0)
                disp(['Currently on image: ', num2str(count)]);
            end
            zeroPadNum = sprintf(['%0', num2str(options.imgNameZeroPad),...
                'd'], j);
            
            imgName = [task.assignmentid, '_avgPoses_', zeroPadNum,...
                '.', options.annotateImgExt];
            
            % Don't render scene if image already exists.
            if ( sum(strcmp(imgName, files)) == 0 )
                poseTask = task.poseTasks(j);
                annotatedImg = RenderPose(options, poseTask, withoutHead, bothPoses);
%                 pause();
                imgFilename = fullfile(dataFolder, imgName);
                imwrite(annotatedImg, imgFilename, options.annotateImgExt);
                
                count = count + 1;
            else
                files = setdiff(files, imgName);
            end
        end
    else
        % Progress update
        if (mod(count, 50) == 0)
            disp(['Currently on image: ', num2str(count)]);
        end
        
        imgName = [task.assignmentid, '_avgPoses',...
            '.', options.annotateImgExt];
        
        % Don't render scene if image already exists.
%         if ( sum(strcmp(imgName, files)) == 0 )
    if ( 1 )
            poseTask = task.poseTasks;
            annotatedImg = RenderPose(options, poseTask, withoutHead, bothPoses);
            pause();
            imgFilename = fullfile(dataFolder, imgName);
            imwrite(annotatedImg, imgFilename, options.annotateImgExt);
            
            count = count + 1;
        else
            files = setdiff(files, imgName);
        end
        
    end
    
end
fprintf('Annotated %d images with poses.\n', count);

end