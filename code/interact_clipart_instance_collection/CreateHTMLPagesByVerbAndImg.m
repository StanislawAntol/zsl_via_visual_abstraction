%CREATEHTMLPAGESBYVERB Creates the HTML files to display images by verb.
%   CreateHTMLPagesByVerb(filenames, labels, verbPhrasesID, verbPhrasesVP, baseFolder, htmlFolder, imageFolder) 
%   creates a simple HTML file
%   that displays all of the verbs with links. Each link goes to another HTML
%   file that contains the images for that verb. Each verb has
%   its own table. Every image also shows the associated Turker's ID. It
%   utilizes data from options (for filenames, paths, etc.) and the
%   sentence specific data in tasks and scenes. This assumes you're in the 
%   output directory already.
%
%   INPUT
%     -options:      Struct containing all configuration data.
%                    Should be created by createOptions function.
%     -tasks:        Struct array containing all HIT tasks. 
%
%   OUTPUT
%     NONE, but side effect of saving the HTML files.
%
%   Author: Stanislaw Antol (santol@vt.edu)         Date: 2013-10-18

function CreateHTMLPagesByVerbAndImg(structuredData, baseFolder, htmlFolder, imgFolder)

% %% Deal with organizing data by verb
% verbs = getVerbs(options);
% verbGroups = groupingTasksByVerb(tasks, verbs);

%% Create the main verb HTML page
mainBaseFN = 'interact_dataset_gallery.html';
baseFolderRel = strrep(baseFolder, baseFolder, '');
mainFilename = fullfile(baseFolder, mainBaseFN);%[options.HTMLFolder, options.verbHTMLPagesFilename];
mainFID = fopen(mainFilename, 'w');

basePageFN = fullfile('.', htmlFolder, mainBaseFN(1:end-5)); % get rid of '.html'
count = 0;

fprintf(mainFID, '<!DOCTYPE html>\n<html>\n');
fprintf(mainFID, '<head><title>INTERACT Instance-level Illustration Collection</title><link rel="stylesheet" type="text/css" href="../style.css" /></head>\n');
fprintf(mainFID, '<body>\n    <h1>INTERACT Instance-level Illustration Collection</h1>\n');
pageTagFormat = '    <a href="%s">%s</a><br>\n';

verbPhrases = structuredData(:, 1);

for idxVerb = 1:numel(verbPhrases)
    verb = verbPhrases{idxVerb};
    verbUnderscore = strrep(verb, ' ', '_');
    pageFilename = sprintf('%s_%s.html', basePageFN, verbUnderscore);
    
    pageTag = sprintf(pageTagFormat, pageFilename, verb);
    fprintf(mainFID, pageTag);
    count = count + 1;
end

fprintf(mainFID, '<h3><a href="../index.html">Back to the dataset page.</a></h3>\n');
fprintf(mainFID, '</body>\n</html>\n');

fclose(mainFID);

%% Create the HTML page for each verb

% Setting properties of HTML table
tblWidth = 50;
tblBorder = 1;
tblCellpad = 1;

% How many separate tables to make
numTbl = numel(verbPhrases);

% Dimensions of the HTML table
numRow = -1; % Is set automatically in the loops
% numCol = options.numURLs/2;
numCol = 3;

colWidthPerc = floor(100/numCol);

% Tags to start and end a table's row
tblRowTagSt = '<tr>\n';
tblRowTagE = '</tr>\n';

% Tags to start and end a table's column data entry
tblColTagS = '    <td align="center" valign="center">\n';
tblColTagE = '    </td>\n';

% Basic HTML beginning info

count = 0;
for t = 1:numTbl
    verb = verbPhrases{t};
    verbUnderscore = strrep(verb, ' ', '_');
    
    pageFilename = fullfile(baseFolder, htmlFolder, ...
        sprintf('%s_%s.html', mainBaseFN(1:end-5), verbUnderscore));
    
    fid = fopen(pageFilename, 'w');
    
    fprintf(fid, '<!DOCTYPE html>\n<html>\n');
    fprintf(fid, '<head><title>INTERACT: %s</title><link rel="stylesheet" type="text/css" href="../../style.css" /></head>\n', verb);
    fprintf(fid, '<body>\n    <h1>INTERACT Instance-level Illustration Collection</h1>\n');
    fprintf(fid, '    <h2>Person 1 %s Person 2.</h2>\n', verb);
    
    curVerbRealImgs = structuredData{t, 2};
    
    if ( ~isempty(curVerbRealImgs) )
        
        numRow = size(curVerbRealImgs, 1);
        
        fprintf(fid, '<table width="100%%" border="%d" cellpadding="%d" style="table-layout:fixed;">\n', ...
            tblBorder, tblCellpad);
        for r = 0:numRow-1
            fprintf(fid, tblRowTagSt);
            
            imgName = curVerbRealImgs{r+1, 1};
            clipart = curVerbRealImgs{r+1, 2};
            numClipart = size(clipart, 1);
            
            imgFilename = sprintf('../%s/%s', imgFolder, imgName);
            
            fprintf(fid, tblColTagS);
            %width="100%%" height="80%%"
            sentStr = sprintf('%s%s%s.', ...
                            'Person 1 ', verb, ' Person 2');
            fprintf(fid, '        <img src="%s" alt="Broken path. :(" width="100%%" height="240"/>\n\t\t<br><font size="2">%s<br>%s</font>\n', imgFilename, sentStr);
            fprintf(fid, tblColTagE);
            count = count + 1;

            for c = 1:numCol
                
                if ( c <= numClipart )
                    imgName = clipart{c, 1};
                    person1 = clipart{c, 2};
                    
                    imgFilename = sprintf('../%s/%s', imgFolder, imgName);
                   
                    if ( person1 == 1 )
                        sentStr = sprintf('<font color="E4DA10">%s</font>%s<font color="663300">%s</font>.', ...
                            'Person 1 ', verb, ' Person 2');
                    else
                        sentStr = sprintf('<font color="663300">%s</font>%s<font color="E4DA10">%s</font>.', ...
                            'Person 1 ', verb, ' Person 2');
                    end
                    
                    fprintf(fid, tblColTagS);
                    fprintf(fid, '        <img src="%s" alt="Broken path. :(" width="100%%" height="240"/>\n\t\t<br><font size="2">%s<br>%s</font>\n', imgFilename, sentStr);
                    fprintf(fid, tblColTagE);
                    count = count + 1;
                else
                    fprintf(fid, tblColTagS);
                    fprintf(fid, '\n');
                    fprintf(fid, tblColTagE);
                    count = count + 1;
                end
            end
            fprintf(fid, tblRowTagE);
        end
        
        fprintf(fid, '</table>\n\n');
        
    end
    
    mainPage = sprintf('../%s', mainBaseFN);
   
    fprintf(fid, '<br><a href="%s">Back to main page.</a>', mainPage);
    
    fprintf(fid, '</body>\n</html>\n');
    
    fclose(fid);
    
    
end

fprintf('Added %d images to the verb HTML.\n', count);

end