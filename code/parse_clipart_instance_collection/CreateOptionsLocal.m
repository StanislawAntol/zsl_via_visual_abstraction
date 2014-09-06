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
    options.clipartType      = 2;
    options.numPeople        = 1;
    options.isReal           = 0;
    options.visualizeFeature = 0;
    options.numScenesPerTask = 1;
    
    %% Specifying the directory structure for the data
    options.inputFolder  = options.foldersLocal{options.idxPARSEClipInstColl}{options.idxDataInput};
    options.outputFolder = options.foldersLocal{options.idxPARSEClipInstColl}{options.idxDataOutput};

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
    options.AMTFile = options.filePARSEAMTClipInst;
    options.realImgFile = options.filePARSEImgDataInfoGT;
       
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.outDataFile         = fullfile(options.outputFolder, 'parsed_amt_data.mat');
    
    %% Variables for the features
    options.infoDataFile    = options.filePARSEClipInstInfoData;
    options.labelDataFile   = options.filePARSEClipInstLabelData;
    options.poseDataFile1   = options.filePARSEClipInstPoseData1;
    options.exprDataFile1   = options.filePARSEClipInstExprData1;
    options.gazeDataFile1   = options.filePARSEClipInstGazeData1; 
    options.genderDataFile1 = options.filePARSEClipInstGendData1;
    
    % File for the verb list to extract
    %options.realFeaturesDir = '../../data/output/calculate_parse_features/full_exp_1/features/';
    %options.realImgFile = [options.realFeaturesDir, 'parseGTInfoData.txt'];
    %options.realImgFile = options.filePARSEImgDataInfoGT;
    %options.verbFile = options.filePARSEVerbList;
    
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
    
    %% Specifying directory structure (on the server) for the HTML files
     % Assumes that image filenames are given by options.renderImgName     
    options.HTMLBaseURL   = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/output/';
    options.realImgBase   = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/';
%     options.HTMLBaseURL   =                'file:///home/santol/cvmlp/pose_clipart/data/output/';
%     options.realImgBase   =                'file:///home/santol/cvmlp/pose_clipart/data/';
%     options.realImgDir    = 'PARSE/';
%     options.HTMLExpPath   = [options.HTMLBaseURL, options.expType, '/', options.expName, '/'];
%     options.HTMLRealImgPath = fullfile(options.realImgBase, options.realImgDir);
%     options.HTMLImgPath   = [options.HTMLExpPath, options.data1FolderName];
%     options.HTMLPagesPath = [options.HTMLExpPath, options.HTMLFolderName];
    
%     options.orderingFile = fullfile(options.data2Folder, 'clipartOrderingGT.txt');    
    
%     options.categoryNames = { ...
%     ''; ...
%     'is dunking a basketball'; ...
%     'is batting during a sports game (e.g., cricket, baseball)'; ...
%     'is catching a ball'; ...
%     'is diving to catch an object'; ...
%     'is juggling'; ...
%     'is kicking a ball'; ...
%     'is on a bicycle'; ...
%     'is pitching a ball'; ...
%     'is splitting their legs'; ...
%     'is standing'; ...
%     'is celebrating a goal/point'; ...
%     'is walking to the left'; ...
%     'is walking to the right'; ...
%     'is walking towards the camera'; ...
%     'is receiving a tennis serve'; ...
%     'is finishing their tennis serve'; ...
%     };

end