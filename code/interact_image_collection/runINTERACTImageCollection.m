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

% Add path for some common MTurk task data-related functions
addpath(fullfile('..', 'common'));

%% Gets the options that govern directories, what runs, etc.
options = CreateOptionsGlobal();
options = CreateOptionsLocal(options);

if (options.parseAMTFile ~= 0)
    allTasks = ParseMTurk(options);
    % Manually entered URL corrections
    badURLs = GetBadURLs(options.namesExp{options.idxINTERACTColl});
    
    % Fix the bad URLs with manually corrected ones.
    allTasks = FixTaskURLs(allTasks, badURLs);
    
    save(options.outDataFile, 'allTasks');
else
    load(options.outDataFile);
end

% Can remove HITs that were approved/rejected.
if (options.filterApproved ~= 0)
    tasks = FilterOutTasks(allTasks, options.filterLabel);
else
    tasks = allTasks;
end

if ( 0 )
    CalculateVerbCollectionTimes(options, tasks);
end

%% Downloads the image files from the AMT URLs
if ( options.downloadDataset ~= 0 )
    % Returns (taskIdx, URLIdx) pairs failed to download
    failedDLs = DownloadImageData(options, tasks);
end

%% Checks for bad filenames (from previous download attempt)
 % In case you want to find a new URL for them so they're "proper"
badFilenames = FindBadFilenames(options);

%% Creates the HTML files for easy viewing of the results
if ( options.createHTML ~= 0 )
    CreateHTMLPagesByVerb(options, tasks);
    CreateHTMLPagesByWorker(options, tasks);
end