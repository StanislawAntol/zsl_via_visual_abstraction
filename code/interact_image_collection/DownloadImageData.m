%DOWNLOADIMAGEDATA Downloads the images from the image collection results.
%  failedDLs = downloadImageData(options, tasks) downloads the images that
%  are stored in the tasks struct array.
%
%  INPUT
%    -options:      Struct containing all configuration data.
%                   Should be created by createOptions function.
%    -tasks:        Struct array containing all HIT tasks.
%                   Each struct contains all the data from
%                   the AMT results file.
%
%  OUTPUT
%    -failedDLs:    A nx2 array of (taskIdx, URLIdx) pairs for any
%                   downloads that have failed. Sometimes running it again
%                   will have some of the bad ones work. Other times, 
%                   the URL itself is bad.
%
%  Author: Stanislaw Antol (santol@vt.edu)                 Date: 2014-08-18

function failedDLs = DownloadImageData(options, tasks)

    filesStruct = dir(options.dataFolder);
    files = extractfield(filesStruct, 'name')';
    % Get rid of the current folder and previous folder links
    files = setdiff(files, '.');
    files = setdiff(files, '..');
    files = lower(files);

    failedDLs = [];
    failCount = 0;
    numTasks = size(tasks, 1);
    newCount = 0;
    count = 1;

    for i = 1:numTasks
        task = tasks(i);
        for j = 1:length(task.urls)

            % Progress update
            if (mod(count, 50) == 0)
                disp(['Currently on image: ', num2str(count)]);
            end

            url = task.urls{j};
            extension = GetExtensionFromURL(url);

            zeroPadNum = sprintf(['%0', num2str(options.foundImgNameZeroPad),...
                'd'], j);

            imgName = [task.assignmentid, '_', zeroPadNum, '.', extension];
%
            if ( sum(strcmpi(imgName, files)) == 0 )

                imgFilename = fullfile(options.dataFolder, imgName);

                try
                    urlwrite(url, imgFilename, 'Timeout', 5); % 5s timeout
                    pause(.1);
                    newCount = newCount + 1;
                catch exception
                    failCount = failCount + 1;
                    failedDLs(failCount, 1) = i;
                    failedDLs(failCount, 2) = j;
                    [i,j]
                end
            else
                files = setdiff(files, imgName);
            end
            count = count + 1;

        end
    end
    disp(sprintf('Downloaded %d new images.', newCount));
    disp(sprintf('Failed to download %d images.', size(failedDLs,1)));

end