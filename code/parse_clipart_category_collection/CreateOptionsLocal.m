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
    options.parseAMTFile                = 1;
    options.filterApproved              = 1;
    options.renderAndSaveIllustractions = 0;
    options.computeFeatures             = 1;
    options.createHTML                  = 0;
    
    options.filterLabel      = 'Approved';
    options.clipartType      = 1;
    options.numPeople        = 1;
    options.isReal           = 0;
    options.visualizeFeature = 0;
    options.numScenesPerTask = 2;
    
    %% Specifying the directory structure for the data
    options.inputFolder  = options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataInput};
    options.outputFolder = options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataOutput};

    options.verbFile = options.filePARSEVerbList;
    
    options.data1FolderName   = 'rendered_illustrations';
    options.data2FolderName   = 'features';
    options.HTMLFolderName    = 'html';
    options.data1Folder       = fullfile(options.outputFolder, options.data1FolderName);
    options.data2Folder       = fullfile(options.outputFolder, options.data2FolderName);
    options.HTMLFolder        = fullfile(options.outputFolder, options.HTMLFolderName);
    
    %% Make sure all the necessary folders are in place
    folders = {
        options.data1Folder; ...
        options.data2Folder; ...
        options.HTMLFolder };
    
    for f = 1:numel(folders)
        curFolder = folders{f};
        if ~exist(curFolder, 'dir')
            mkdir(curFolder);
        end
    end
    
    options.clipartInterfaceGlobals = GetClipartGlobals(options);
    
    %% Specifying the input file
    options.AMTFile = options.filePARSEAMTClipCat;
       
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.outDataFile         = fullfile(options.outputFolder, 'parsed_amt_data.mat');
    
    %% Variables for the features
    options.infoDataFile    = options.filePARSEClipCatInfoData;
    options.labelDataFile   = options.filePARSEClipCatLabelData;
    options.poseDataFile1   = options.filePARSEClipCatPoseData1;
    options.exprDataFile1   = options.filePARSEClipCatExprData1;
    options.gazeDataFile1   = options.filePARSEClipCatGazeData1; 
    options.genderDataFile1 = options.filePARSEClipCatGendData1;
    
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
%     options.HTMLBaseURL   = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/output/';
%     options.HTMLBaseURL   =                'file:///home/santol/cvmlp/pose_clipart/data/output/';
%     options.realImgDir = 'image_collection/full_exp_1/foundImgs/';
%     options.HTMLExpPath   = [options.HTMLBaseURL, options.expType, '/', options.expName, '/'];
%     options.HTMLRealImgPath = fullfile(options.HTMLBaseURL, options.realImgDir, filesep);
%     options.HTMLImgPath   = [options.HTMLExpPath, options.data1FolderName, '/'];
%     options.HTMLPagesPath = [options.HTMLExpPath, options.HTMLFolderName, '/'];
    
end