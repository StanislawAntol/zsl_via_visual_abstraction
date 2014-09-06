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

function workerGroups = CreateHTMLPagesByWorker(options, tasks)

        %% Deal with organizing data by verb
    [workerIDs, workerGroups] = GroupingTasksByWorker(tasks);

    %% Create the main verb HTML page
    mainFilename = [options.HTMLFolder, options.workerHTMLPagesFilename];

    basePageFN = options.workerHTMLPagesFilename(1:end-5); % get rid of '.html'
    count = 0;
    mainFID = fopen(mainFilename, 'w');

    fprintf(mainFID, '<!DOCTYPE html>\n<html>\n<body>\n');
    fprintf(mainFID, '\t<h1>Attribute Collection By Worker</h1>\n');
    pageTagFormat = '\t<a href="%s">%s</a><br>\n';

    for w = 1:numel(workerIDs)
        workerID = workerIDs{w};
        pageFilename = [options.HTMLPagesPath, ...
            basePageFN, '_', workerID, '.html'];

        pageTag = sprintf(pageTagFormat, pageFilename, ...
            workerID);
        fprintf(mainFID, pageTag);
        count = count + 1;
    end

    fprintf(mainFID, '</body>\n</html>\n');

    fclose(mainFID);

    %% Create the HTML page for each verb

    % Setting properties of HTML table
    tblWidth = 1200;
    tblBorder = 5;
    tblCellpad = 1;

    % How many separate tables to make
    numTbl = numel(workerIDs);

    % Dimensions of the HTML table
    numRow = -1; % Is set automatically in the loops
    numCol = options.numSents;
%     numCol = 3;

    % Tags to start and end a table's row
    tblRowTagSt = '<tr>\n';
    tblRowTagE = '</tr>\n';

    % Tags to start and end a table's column data entry
    tblColTagS = '\t<td align="left" valign="center">\n';
    tblColTagE = '\t</td>\n';

    % Basic HTML begging info

    count = 0;
    for t = 1:numTbl
        workerID = workerIDs{t};

        pageFilename = [options.HTMLFolder, ...
            basePageFN, '_', workerID, '.html'];

        fid = fopen(pageFilename, 'w');

        fprintf(fid, '<!DOCTYPE html>\n<html>\n<body>\n');

        workerID  = workerIDs{t};
        taskNums = workerGroups{t};
        numTasks = numel(taskNums);
        numRow = ceil(options.numSents/numCol);

        fprintf(fid, ['\t<h1>WorkerID: ' workerID '</h1>\n']);

        numHITs = numTasks;

        for h = 1:numHITs
            taskIdx = taskNums(h);        
            task = tasks(taskIdx);
            id = task.assignmentid;

            comment = task.comments;

            fprintf(fid, ['\t<h2>Assignment ID: ', id, ...
                          '<br>Comment: ', comment]);
            fprintf(fid, '<table width="%d" border="%d" cellpadding="%d">\n', ...
                tblWidth, tblBorder, tblCellpad);
            r = 0;
            for c = 0:numCol-1
                idx = numCol*r+c+1;
                if (idx <= options.numSents)
%                     theader += "<th style='text-align: center; vertical-align: middle;'>" + "</th>";
                    sentStr = task.sentences(idx).sent;
                    imgTag = sprintf('<th style=''text-align: left; vertical-align: middle;''>%s</th>', sentStr);
                    fprintf(fid, imgTag);
                end
            end

            for r = 0:numRow-1
                fprintf(fid, tblRowTagSt);
                for c = 0:numCol-1
                    idx = numCol*r+c+1;
                    if (idx <= options.numSents)
                          
                        sentStr = task.sentences(idx).sent;
                        imgTag = '';

                        if ( strcmp(sentStr(1), '1') )
                            p1 = 1;
                            contact = task.sentences(idx).A_cont;
                            expr = task.sentences(idx).A_expr;
                            gaze = task.sentences(idx).A_gaze;
                            gend = task.sentences(idx).A_gend;
                        else
                            p1 = 1;
                            contact = task.sentences(idx).B_cont;
                            expr = task.sentences(idx).B_expr;
                            gaze = task.sentences(idx).B_gaze;
                            gend = task.sentences(idx).B_gend;
                        end
                        
                        contSents = CreateContactSentences(options, p1, contact);
                        for idxCS = 1:length(contSents)
                            imgTag = [imgTag, sprintf('%s<br>', contSents{idxCS})];
                        end
                        
                        apprSents = CreateAppearenceSentences(options, p1, expr, gaze, gend);
                        for idxAS = 1:length(apprSents)
                            imgTag = [imgTag, sprintf('%s<br>', apprSents{idxAS})];
                        end
                        
                        fprintf(fid, tblColTagS);
                        fprintf(fid, imgTag);
                        fprintf(fid, tblColTagE);
                        count = count + 1;
                    end
                end
                fprintf(fid, tblRowTagE);
            end

            fprintf(fid, '</table>\n\n');

        end

        mainPage = [options.HTMLPagesPath, ...
            options.workerHTMLPagesFilename];
        fprintf(fid, '<br><a href="%s">Back to main page.</a>', mainPage);

        fprintf(fid, '</body>\n</html>\n');

        fclose(fid);

    end

    disp(sprintf('Added %d images to the worker HTML.', count));

end