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
    options.createPoseFiles        = 1;
    options.calculatePoseFeats     = 1;
    options.calculateYRDPoseFeats  = 1;
    options.calculateYRBBPoseFeats = 1;
    options.calculateExprFeats     = 1;
    options.calculateNE2Feats      = 1;
    options.calculateGazeFeats     = 1;
    options.calculateBadAnns       = 1;
    options.calculateGenderFeats   = 1;
    options.visualize              = 0;
    options.createHTMLGF           = 0;
    options.computeNoiseOfYR       = 0;
    
    %% Pose Collection Specifics
    % Which column in CSV file to start getting HIT answer data from
    % (starting at the verb_phrase)
    options.seed = RandStream('mt19937ar','Seed', 730);

    % Where the to-be-annotated images come from
    options.numPeople = 2;
   
    options.numParts = 14;
    options.isReal = 1;
    options.numOrients = 12;
    options.numPoses = 2;
    options.imgNameZeroPad = 2;
    options.annotateImgExt = 'jpg';
    
    options.verbFile = options.fileINTERACTVerbList;
    
    options.avgPosesExprFile   = options.fileINTERACTavgPoseExpr;
    options.avgPosesGazeFile   = options.fileINTERACTavgPoseGaze;
    options.avgPosesGenderFile = options.fileINTERACTavgPoseGend;
    
    %% Specifying the directory structure for the data
    options.data1FolderName      = 'features';
    options.data1_1FolderName    = 'features/globalFeatImgs';
    options.data1HTMLFolderName  = 'featuresHTML';

    options.outputFolder        = options.foldersLocal{options.idxINTERACTCalcFeat}{options.idxDataOutput};
   
    options.data1Folder         = fullfile(options.outputFolder, options.data1FolderName);
    options.data1HTMLFolder     = fullfile(options.outputFolder, options.data1HTMLFolderName);
    options.data1_1Folder       = fullfile(options.outputFolder, options.data1_1FolderName);
    options.data1_1HTMLFolder   = fullfile(options.outputFolder, options.data1HTMLFolderName);
    
    
    %% Make sure all the necessary folders are in place
    folders = { }
%         options.data1Folder; ...
%       };
    
    for f = 1:numel(folders)
        curFolder = folders{f};
        
        if ~exist(curFolder, 'dir')
            mkdir(curFolder);
        end
    end
    
%     options.expTypeYR = 'yr_pose_detection';
%    options.dataYRFolder = fullfile(options.outputBaseFolder, options.expTypeYR, options.expName);
    
    
    %% Specifying the names of the HTML files to create
    % Base filename for verb HTML (_<verb phrase> appendied after 'main'
    % for the non-main page)
    options.verbHTMLPagesFilename   = 'images_by_verb_GF_main.html';
    % Base filename for worker HTML (_<workerid> appendied after 'main'
    % for the non-main page)
    options.workerHTMLPagesFilename = 'images_by_worker_GF_main.html';
    
%     %% Specifying directory structure (on the server) for the HTML files
%      % Assumes that image filenames are given by options.renderImgName     
%     options.HTMLBaseURL   = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/output/';
%     options.HTMLBaseURL   =                'file:///home/santol/cvmlp/pose_clipart/data/output/';
%     options.HTMLExpPath   = fullfile(options.HTMLBaseURL, options.expType, options.expName, filesep);
%     options.HTMLdata1_1Path = fullfile(options.HTMLExpPath, options.data1_1FolderName, filesep);
%     options.HTMLdata1_1PagesPath = fullfile(options.HTMLExpPath, options.data1HTMLFolderName, filesep);

end