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
    % Creates all worker annotated poses
    options.processData1    = 0;
    % Calculates average poses
    options.processData2    = 1;
    % Overlays average poses on images
    options.processData4    = 0;
    options.processData5    = 0;
    options.processData6    = 0;
    options.createData1HTML = 0;
    options.createData4HTML = 0;
    options.createData5HTML = 0;
    options.createData6HTML = 0;
    
    options.filterLabel = {'Approved', 'Submitted', 'Rejected'};

    %% Pose Collection Specifics
    options.numPoses   = 4;
    
    options.numImgsPerVerb = 5;
    options.annotateImgExt = 'png';
    options.visualizeAnnotationsDuringAvg = 0;
    options.numSelectedWorkers = 5;
    options.seed = RandStream('mt19937ar','Seed', 730);
    options.numWorkerAgree = 2;

    % Where the to-be-annotated images come from
    options.imgDir        = options.folderINTERACTImgs;
    
    options.imgsMatFile   = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput}, ...
        'parsed_amt_data.mat'); % Use if running on "clean" dataset
    options.imgsMatFile   = options.fileINTERACTandAlexImgs;
    options.fileVerbList = options.fileINTERACTVerbList;

    %% Specifying the directory structure for the data
    options.inputFolder  = options.foldersLocal{options.idxINTERACTPose}{options.idxDataInput};
    options.outputFolder = options.foldersLocal{options.idxINTERACTPose}{options.idxDataOutput};

    options.data1FolderName     = 'poseImgs';
    options.data2FolderName     = 'avgPoseData';
    options.data3FolderName     = 'features';
    options.data4FolderName     = 'avgPoseImgs';
    options.data5FolderName     = 'avgPoseNoHeadImgs';
    options.data6FolderName     = 'avgPoseBothImgs';
    options.data1HTMLFolderName = 'poseImgsHTML';
    options.data4HTMLFolderName = 'avgPoseImgsHTML';
    options.data5HTMLFolderName = 'avgPoseNoHeadImgsHTML';
    options.data6HTMLFolderName = 'avgPoseBothImgsHTML';
   
    options.data1Folder         = fullfile(options.outputFolder, options.data1FolderName);
    options.data2Folder         = fullfile(options.outputFolder, options.data2FolderName);
    options.data3Folder         = fullfile(options.outputFolder, options.data3FolderName);
    options.data4Folder         = fullfile(options.outputFolder, options.data4FolderName);
    options.data5Folder         = fullfile(options.outputFolder, options.data5FolderName);
    options.data6Folder         = fullfile(options.outputFolder, options.data6FolderName);
    options.data1HTMLFolder     = fullfile(options.outputFolder, options.data1HTMLFolderName);
    options.data4HTMLFolder     = fullfile(options.outputFolder, options.data4HTMLFolderName);
    options.data5HTMLFolder     = fullfile(options.outputFolder, options.data5HTMLFolderName);
    options.data6HTMLFolder     = fullfile(options.outputFolder, options.data6HTMLFolderName);
    
    %% Make sure all the necessary folders are in place
    folders = { ...
        options.data1Folder; ...
        options.data2Folder; ...
        options.data3Folder; ...
        options.data4Folder; ...
        options.data5Folder; ...
        options.data6Folder; ...
        options.data1HTMLFolder; ...
        options.data4HTMLFolder; ...
        options.data5HTMLFolder; ...
        options.data6HTMLFolder; ...
        };
    
    for f = 1:numel(folders)
        curFolder = folders{f};
        
        if ~exist(curFolder, 'dir')
            mkdir(curFolder);
        end
    end
    
    %% Specifying the input file (experiment specific-might need to change!)
    options.AMTFile = options.fileINTERACTAMTPose;
    
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.outDataFile         = fullfile(options.outputFolder, 'parsed_amt_data.mat');
    options.outData2File        = options.fileINTERACTavgPose;

    %% Specifying what the resulting filenames should be like
    % Force numbers to have certain zero padding
    options.imgNameZeroPad = 2;

    %% Specifying the names of the HTML files to create
    options.verbHTMLFilename   = 'images_by_verb.html';
    % Base filename for verb HTML (_<verb phrase> appended after 'main'
    % for the non-main page)
    options.verbHTMLPagesFilename   = 'images_by_verb_main.html';
    options.workerHTMLFilename = 'images_by_worker.html';
    % Base filename for worker HTML (_<workerid> appended after 'main'
    % for the non-main page)
    options.workerHTMLPagesFilename = 'images_by_worker_main.html';
    
%     %% Specifying directory structure (on the server) for the HTML files
%     % Assumes that image filenames are given by options.renderImgName     
% %     options.HTMLBaseURL   = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/output/';
% %     options.HTMLBaseURL   =                'file:///home/santol/cvmlp/pose_clipart/data/output/';
%     options.HTMLExpPath   = [options.HTMLBaseURL, options.expType, '/', options.expName, '/'];
% %     options.HTMLImgPath   = [options.HTMLExpPath, options.dataFolderName);
% %     options.HTMLPagesPath = [options.HTMLExpPath, options.HTMLFolderName);
%     options.data1HTMLPath      = [options.HTMLExpPath, options.data1FolderName, '/'];
%     options.data1HTMLPagesPath = [options.HTMLExpPath, options.data1HTMLFolderName, '/'];
%     options.data4HTMLPath      = [options.HTMLExpPath, options.data4FolderName, '/'];
%     options.data4HTMLPagesPath = [options.HTMLExpPath, options.data4HTMLFolderName, '/'];
%     options.data5HTMLPath      = [options.HTMLExpPath, options.data5FolderName, '/'];
%     options.data5HTMLPagesPath = [options.HTMLExpPath, options.data5HTMLFolderName, '/'];
%     options.data6HTMLPath      = [options.HTMLExpPath, options.data6FolderName, '/'];
%     options.data6HTMLPagesPath = [options.HTMLExpPath, options.data6HTMLFolderName, '/'];
    
end