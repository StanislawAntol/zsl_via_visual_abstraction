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
    options.parseAMTFile    = 1;
    options.filterApproved  = 1;
    options.downloadDataset = 1;
    options.createHTML      = 0;
    
    options.filterLabel    = 'Approved';
    
    %% Specifying the directory structure for the data
    options.inputFolder  = options.foldersLocal{options.idxINTERACTColl}{options.idxDataInput};
    options.outputFolder = options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput};

    options.HTMLFolderName   = 'html';
    options.dataFolder       = options.folderINTERACTImgs;
    options.HTMLFolder       = fullfile(options.outputFolder, options.HTMLFolderName);
    
    %% Make sure all the necessary folders are in place
    folders = { ...
        options.dataFolder;
        options.HTMLFolder};
    
    for f = 1:numel(folders)
        curFolder = folders{f};
        
        if ~exist(curFolder, 'dir')
            mkdir(curFolder);
        end
    end
    
    %% Specifying the input file (experiment specific-might need to change!)
    options.AMTFile = options.fileINTERACTAMTImgColl;
    
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.outDataFile         = fullfile(options.outputFolder, 'parsed_amt_data.mat');

    %% Specifying what the resulting filenames should be like
    % Force numbers to have certain zero padding
    options.foundImgNameZeroPad = 2;

    %% Specifying the names of the HTML files to create
    options.verbHTMLFilename   = 'images_by_verb.html';
    % Base filename for verb HTML (_<verb phrase> appendied after 'main'
    % for the non-main page)
    options.verbHTMLPagesFilename   = 'images_by_verb_main.html';
    options.HTMLPagesFilename   = 'images_by_verb_main.html';
    options.workerHTMLFilename = 'images_by_worker.html';
    % Base filename for worker HTML (_<workerid> appendied after 'main'
    % for the non-main page)
    options.workerHTMLPagesFilename = 'images_by_worker_main.html';
    
%     %% Specifying directory structure (on the server) for the HTML files
%      % Assumes that image filenames are given by options.renderImgName     
% %     options.HTMLBaseURL   = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/output/';
% %     options.HTMLBaseURL   =                'file:///home/santol/cvmlp/pose_clipart/data/output/';
%     options.HTMLExpPath   = [options.HTMLBaseURL, options.expType, '/', options.expName, '/'];
%     options.HTMLImgPath   = [options.HTMLExpPath, options.dataFolderName, '/'];
%     options.HTMLPagesPath = [options.HTMLExpPath, options.HTMLFolderName, '/'];
    
end