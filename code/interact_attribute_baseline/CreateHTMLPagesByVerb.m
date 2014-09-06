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

function CreateHTMLPagesByVerb(options, tasks)

%% Deal with organizing data by verb
    [verbsNum, verbsName] = GetINTERACTVerbTuples(options);
    verbGroups = GroupingTasksByVerb(options, tasks, verbsName);

    %% Create the main verb HTML page
    mainFilename = [options.HTMLFolder, options.verbHTMLPagesFilename];

    basePageFN = options.verbHTMLPagesFilename(1:end-5); % get rid of '.html'
    count = 0;
    mainFID = fopen(mainFilename, 'w');

    fprintf(mainFID, '<!DOCTYPE html>\n<html>\n<body>\n');
    fprintf(mainFID, '\t<h1>Clipart Image Collection</h1>\n');
    pageTagFormat = '\t<a href="%s">%s</a><br>\n';
    
    for v = 1:numel(verbsName)
        verb = verbsName{v};
        groups = verbGroups{v};
        if ( ~isempty(groups) )
            verbUnderscore = strrep(verb, ' ', '_');
            pageFilename = [options.HTMLPagesPath, ...
                basePageFN, '_', verbUnderscore, '.html'];
            
            pageTag = sprintf(pageTagFormat, pageFilename, ...
                verbsName{v});
            fprintf(mainFID, pageTag);
        end
        count = count + 1;
    end

    fprintf(mainFID, '</body>\n</html>\n');

    fclose(mainFID);

    %% Create the HTML page for each verb

    % Setting properties of HTML table
    tblWidth = 50;
    tblBorder = 5;
    tblCellpad = 1;

    % How many separate tables to make
    numTbl = numel(verbGroups);

    % Dimensions of the HTML table
    numRow = -1; % Is set automatically in the loops
    numCol = 4;

    % Tags to start and end a table's row
    tblRowTagSt = '<tr>\n';
    tblRowTagE = '</tr>\n';

    % Tags to start and end a table's column data entry
    tblColTagS = '\t<td align="center" valign="center">\n';
    tblColTagE = '\t</td>\n';

    % Basic HTML beginning info

    count = 0;
    for t = 1:numTbl
        verb = verbsName{t};
        verbUnderscore = strrep(verb, ' ', '_');

        pageFilename = [options.HTMLFolder, ...
            basePageFN, '_', verbUnderscore, '.html'];

        fid = fopen(pageFilename, 'w');

        fprintf(fid, '<!DOCTYPE html>\n<html>\n<body>\n');
        fprintf(fid, '\t<h1>Person 1 %s Person 2.</h1>\n', verb);

        idxPairs = verbGroups{t};

        if ( isempty(idxPairs) == 0 )

            numImgs = size(idxPairs, 1);
            numRow = ceil(numImgs/numCol);

            fprintf(fid, '<table width="%d" border="%d" cellpadding="%d">\n', ...
                tblWidth, tblBorder, tblCellpad);
            for r = 0:numRow-1
                fprintf(fid, tblRowTagSt);
                for c = 0:numCol-1
                    idx = numCol*r+c+1;
                    if (idx <= numImgs)
                        idxPair = idxPairs(idx, :);
                        task = tasks(idxPair(1));
                        scene = task.scenes(idxPair(2));
                        worker = task.workerid;

                        zeroPadNum = sprintf(['%0', num2str(options.renderImgNameZeroPad),...
                            'd'], idxPair(2));

                        imgName = [task.assignmentid, '_', zeroPadNum, '.', options.renderImgExt];

                        imgFilename = [options.HTMLImgPath, imgName];
                        imgTagFormat = '\t\t<img src="%s" alt="Broken path. :(" width="300" height="240" />\n\t\t<br><font size="2">%s<br>%s</font>\n';
                        
                        sentStr = scene.sent;
                        
                        if ( scene.p1 == 1 )
                            sentStr = sprintf('<font color="E4DA10">%s</font>%s<font color="663300">%s</font>.', ...
                                sentStr(1:8), sentStr(9:(end-10)), sentStr((end-9):(end-1)) );
                        else
                            sentStr = sprintf('<font color="663300">%s</font>%s<font color="E4DA10">%s</font>.', ...
                                sentStr(1:8), sentStr(9:(end-10)), sentStr((end-9):(end-1)) );
                        end
                        
                        imgTag = sprintf(imgTagFormat, imgFilename, ...
                            worker, sentStr);

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
            options.verbHTMLPagesFilename];
        fprintf(fid, '<br><a href="%s">Back to main page.</a>', mainPage);

        fprintf(fid, '</body>\n</html>\n');

        fclose(fid);


    end

    disp(sprintf('Added %d images to the verb HTML.', count));
    
end