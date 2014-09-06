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

function RenderTaskScenes(options, tasks)

    count = 0;
    numTasks = size(tasks, 1);
    filesStruct = dir(options.data1Folder);
    files = extractfield(filesStruct, 'name')';
    % Get rid of the current folder and previous folder links
    files = setdiff(files, '.');
    files = setdiff(files, '..');

    for i = 1:numTasks
        %     for i = 1072:1072
        task = tasks(i);
        for j = 1:length(task.scenes)
            % Progress update
            if (mod(count, 50) == 0)
                disp(['Currently on image: ', num2str(count)]);
            end
            zeroPadNum = sprintf(['%0', num2str(options.renderImgNameZeroPad),...
                'd'], j);
            imgName = [task.assignmentid, '_', zeroPadNum, '.', options.renderImgExt];

            % Don't render scene if image already exists.
            if ( sum(strcmp(imgName, files)) == 0 )
                scene = task.scenes(j);
                sceneImg = RenderScene(options, scene);
                imgFilename = fullfile(options.data1Folder, imgName);
                imwrite(sceneImg, imgFilename, options.renderImgExt);
                count = count + 1;
            else
                files = setdiff(files, imgName);
            end

        end
    end
    fprintf('Rendered %d scenes.\n', count);
end