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

function options = CreateOptionsLocal(options)

    %% Which parts of the process to run
    options.parseAMTFile      = 1;
    options.filterApproved    = 1;
    options.processData1      = 1; % Rendering clipart images
    options.processData2      = 1; % Computing features
    options.createHTML        = 0;
    
    options.filterLabel     = 'Approved';
    
    options.clipartType = 1; % Category-level
    options.numParts = 14;
    options.isReal = 1;
%     options.numOrients = 12;
    options.numScenesPerTask = 3;
    
    %% Where the clipart images come from
    options.clipartInterfaceGlobals = GetClipartGlobals(options);
    % Number of scenes per HIT
%     options.numScenes = 3;

    %% Specifying the directory structure for the data
    options.data1FolderName   = 'rendered_illustrations';    
    options.HTMLFolderName    = 'html';
    options.outputFolder      = options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataOutput};
    options.data1Folder       = fullfile(options.outputFolder, options.data1FolderName);
    options.HTMLFolder        = fullfile(options.outputFolder, options.HTMLFolderName);
    
    %% Make sure all the necessary folders are in place
    folders = {
        options.data1Folder; ...
        options.HTMLFolder};
    
    for f = 1:numel(folders)
        curFolder = folders{f};
        
        if ~exist(curFolder, 'dir')
            mkdir(curFolder);
        end
    end
    
    %% Specifying the input file
    options.AMTFile = options.fileINTERACTAMTClipCat;
    
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.outDataFile         = fullfile(options.outputFolder, 'parsed_amt_data.mat');
    
    %% Speficying what the resulting filenames should be
    options.renderImgNameZeroPad = 2; % Force numbers to have certain zero padding
    options.renderImgExt  = 'png';

    %% Specifying the names of the HTML files to create
    % Base filename for verb HTML (_<verb phrase> appendied after 'main'
    % for the non-main page)
    options.verbHTMLPagesFilename   = 'images_by_verb_main.html';
    % Base filename for worker HTML (_<workerid> appendied after 'main'
    % for the non-main page)
    options.workerHTMLPagesFilename = 'images_by_worker_main.html';
    
%     %% Specifying directory structure (on the server) for the HTML files
%      % Assumes that image filenames are given by options.renderImgName     
% %     options.HTMLBaseURL   = 'https://filebox.ece.vt.edu/~santol/cvmlp/zsl_via_visual_abstraction/data/output/';
% %     options.HTMLBaseURL   =                'file:///home/santol/cvmlp/zsl_via_visual_abstraction/data/output/';
%     options.HTMLExpPath   = [options.HTMLBaseURL, expType, '/', expName, '/'];
%     options.HTMLImgPath   = [options.HTMLExpPath, options.data1FolderName, '/'];
%     options.HTMLPagesPath = [options.HTMLExpPath, options.HTMLFolderName, '/'];

end