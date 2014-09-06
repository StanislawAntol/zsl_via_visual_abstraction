%CREATEOPTIONSGLOBAL Create options for project pipeline.
%  options = CreateOptionsGlobal() returns an struct that contains the
%  important data for the entire pipeline, such folder paths, files used
%  in multiple places, etc.
%
%  [options] = CreateOptionsGlobal() is to make passes project-level
%  information between different parts of the code.
%
%  INPUT
%    N/A
%
%  OUTPUT
%    -options:      Struct that contains all the information that is shared
%                   or otherwise important to know as fields.
%
%  NOTES
%    Please ensure that options.folders3rdParty{1} points to the folder
%    where all 3rd party programs (e.g., liblinear) reside.
%    Please ensure that options.foldersBase{3} is where the "data" folder 
%    resides. The data/input folder should contain the information
%    extracted from the input zip file that was downloaded from the
%    website. All the programs will output to the data/output directory.
%
%  Author: Stanislaw Antol (santol@vt.edu)                 Date: 2014-08-18

function options = CreateOptionsGlobal()

    %% Specifying the directory structure for the project
    options.folders3rdParty{1} = '../../../3rd_party/'; % Where all the 3rd party software lives
    options.foldersBase{3}     = '../../data/'; % Where all the input/output data lives
    % @TODO Add this stuff to help desciption.
    options.HTMLBaseURL        = 'https://computing.ece.vt.edu/~santol/cvmlp/zsl_via_visual_abstraction/data/output/';
    options.HTMLBaseURL        =                  'file:///home/santol/cvmlp/zsl_via_visual_abstraction/data/output/';
  
    %% 3rd party software that this will be using
    options.idxMTurk     = 2;
    options.idxLibLinear = 3;
    options.idxLibSVM    = 4;
    options.idxGIST      = 5;
    options.idxYRPose    = 6;
    options.idxPiotr     = 7;
    
    options.folders3rdParty{options.idxMTurk}     = fullfile(options.folders3rdParty{1}, 'aws-mturk-clt-1.3.1');
    options.folders3rdParty{options.idxLibLinear} = fullfile(options.folders3rdParty{1}, 'liblinear-1.94/matlab');
    options.folders3rdParty{options.idxLibSVM}    = fullfile(options.folders3rdParty{1}, 'libsvm-3.17/matlab');
    options.folders3rdParty{options.idxGIST}      = fullfile(options.folders3rdParty{1}, 'gistdescriptor');
    options.folders3rdParty{options.idxYRPose}    = fullfile(options.folders3rdParty{1}, '20121128-pose-release-ver1.3/code-full');
%     options.folders3rdParty{options.idxYRPose}    = fullfile(options.folders3rdParty{1}, 'pose-release1.3-full/code-full');
    options.folders3rdParty{options.idxPiotr}     = fullfile(options.folders3rdParty{1}, 'piotr_toolbox');
    
    %% Local data directories
    options.idxDataInput   = 1;
    options.idxDataOutput  = 2;
    
    options.foldersBase{options.idxDataInput}   = fullfile(options.foldersBase{3}, 'input');
    options.foldersBase{options.idxDataOutput}  = fullfile(options.foldersBase{3}, 'output');
    
    options.idxINTERACTImgHumanAgr  =  1;
    % INTERACT Clipart
    options.idxINTERACTClipCatColl     =  4;
    options.idxINTERACTClipInstColl    =  5;
    options.idxINTERACTClipInstWho     = 27;
    % INTERACT Images

    options.idxINTERACTColl            =  8;
    options.idxINTERACTPose            =  9;
    options.idxINTERACTYRPose          = 10;
    options.idxINTERACTExpr            = 11;
    options.idxINTERACTGaze            = 12;
    options.idxINTERACTGend            = 13;
    options.idxINTERACTCleanup         = 14;    
    options.idxINTERACTAttr            = 15;
    options.idxINTERACTCalcFeat        = 16;
    % PARSE Clipart
    options.idxPARSEClipCatColl        = 19;
    options.idxPARSEClipInstColl       = 20;
    % PARSE Image
    options.idxPARSEYRPose             = 21;
    options.idxPARSEExpr               = 22;
    options.idxPARSEGaze               = 23;
    options.idxPARSEGend               = 24;
    options.idxPARSECalcFeat           = 25;
    % Experiments
    options.idxExperiments             = 26;
    
    % Folder names
    options.namesLocal{options.idxINTERACTClipCatColl}     = 'interact_clipart_category_collection';
    options.namesLocal{options.idxINTERACTClipInstColl}    = 'interact_clipart_instance_collection';
    options.namesLocal{options.idxINTERACTColl}            = 'interact_image_collection';
    options.namesLocal{options.idxINTERACTImgHumanAgr}  = 'interact_human_agreement';
    options.namesLocal{options.idxINTERACTPose}            = 'interact_gt_pose';
    options.namesLocal{options.idxINTERACTYRPose}          = 'interact_yr_pose';
    options.namesLocal{options.idxINTERACTExpr}            = 'interact_gt_expr';
    options.namesLocal{options.idxINTERACTGaze}            = 'interact_gt_gaze';
    options.namesLocal{options.idxINTERACTGend}            = 'interact_gt_gender';
    options.namesLocal{options.idxINTERACTCleanup}         = 'interact_dataset_cleanup';    
    options.namesLocal{options.idxINTERACTAttr}            = 'interact_attribute_baseline';
    options.namesLocal{options.idxINTERACTCalcFeat}        = 'interact_calculate_features';
    options.namesLocal{options.idxPARSEClipCatColl}        = 'parse_clipart_category_collection';
    options.namesLocal{options.idxPARSEClipInstColl}       = 'parse_clipart_instance_collection';
    options.namesLocal{options.idxPARSEYRPose}             = 'parse_yr_pose';
    options.namesLocal{options.idxPARSEExpr}               = 'parse_gt_expr';
    options.namesLocal{options.idxPARSEGaze}               = 'parse_gt_gaze';
    options.namesLocal{options.idxPARSEGend}               = 'parse_gt_gender';
    options.namesLocal{options.idxPARSECalcFeat}           = 'parse_calculate_features';
    options.namesLocal{options.idxExperiments}             = 'experiments';
    options.namesLocal{options.idxINTERACTClipInstWho}     = 'interact_clipart_instance_who_is_who';

    % Linux only
    options.convertEPS2PNGCommand = 'export LD_LIBRARY_PATH=""; convert -flatten -colorspace RGB';
    
    % Acceptable image types
    options.imgTypes = {'.jpg', '.jpeg', '.png', '.bmp', '.gif','.tif', '.tiff'};
    
    options.exprList = [1, 2, 3, 4, 5, 6, 7];
    % New index order when flipping gaze expressions
    options.gazeSwitchIdxMap = [2; 1; 3; 4; 5;]; % The last 3 are person independant
    options.gendList = [1, 2]; % Male, Female
    options.genderList = [0, 1]; % Male, Female % Have to double check with real image data
    
    options.backgroundImgName = 'background_plain.png';
    options.numParts = 14;
    options.numOrient = 12; % Number of bins for orientation/angle histograms
    
    options.clipartNumParts = options.numParts + 1; % Interface keeps track of person's torso center
    % Converting the clipart indices to the Stickman indices
    % (Stickman order is the order in the features files)
    % It has 2 dimensions for accounting for flip
    options.clipartToStickmanIdxs = [...,
        15, 15;...
        14, 14;...
         3,  2;...
         5,  4;...
         7,  6;...
         2,  3;...
         4,  5;...
         6,  7;...
         8,  9;...
        10, 11;...
        12, 13;...
         9,  8;...
        11, 10;...
        13, 12;...
        ];
    
    
    options.partParent = { []; ...
                            [0]+1; ...
                            [1]+1; ...
                            [2]+1; ...
                            [3]+1; ...
                            [1]+1; ...
                            [5]+1; ...
                            [6]+1; ...
                            [5]+1; ...
                            [8]+1; ...
                            [9]+1; ...
                            [2, 8]+1; ...
                            [11]+1; ...
                            [12]+1;...
                            };
    
    
    %% Where the clipart images come from
    options.clipartImgDir        = '../../sites/interact_clipart_category_collection/pngs/'; 

    %% Current experiments' name

    options.namesExp{options.idxINTERACTClipCatColl}     = 'full_exp_2';
    options.namesExp{options.idxINTERACTClipInstColl}    = 'full_exp_1';
    options.namesExp{options.idxINTERACTColl}            = 'full_exp_1';
    options.namesExp{options.idxINTERACTPose}            = 'full_exp_1';
    options.namesExp{options.idxINTERACTYRPose}          = 'full_exp_1';
    options.namesExp{options.idxINTERACTExpr}            = 'full_exp_1';
    options.namesExp{options.idxINTERACTGaze}            = 'full_exp_1';
    options.namesExp{options.idxINTERACTGend}            = 'full_exp_1';
    options.namesExp{options.idxINTERACTCleanup}         = 'full_exp_1';    
    options.namesExp{options.idxINTERACTAttr}            = 'full_exp_1';
    options.namesExp{options.idxINTERACTImgHumanAgr}     = 'full_exp_1';
    options.namesExp{options.idxINTERACTCalcFeat}        = 'full_exp_1';
    options.namesExp{options.idxPARSEClipCatColl}        = 'full_exp_1';
    options.namesExp{options.idxPARSEClipInstColl}       = 'full_exp_1';
    options.namesExp{options.idxPARSEYRPose}             = 'full_exp_1';
    options.namesExp{options.idxPARSEExpr}               = 'full_exp_1';
    options.namesExp{options.idxPARSEGaze}               = 'full_exp_1';
    options.namesExp{options.idxPARSEGend}               = 'full_exp_1';
    options.namesExp{options.idxPARSECalcFeat}           = 'full_exp_1';
    options.namesExp{options.idxExperiments}             = 'full_exp_1';
    options.namesExp{options.idxINTERACTClipInstWho}     = 'full_exp_1';
    
    options.foldersLocal = cell(2*length(options.namesLocal), 1);
    for i = 1:length(options.namesLocal)
      folders = cell(length(options.foldersBase)-1, 1);
      for j = 1:length(options.foldersBase)-1
        folders{j} = fullfile(options.foldersBase{j}, options.namesLocal{i}, options.namesExp{i});
      end
      options.foldersLocal{i} = folders;
    end
    
    CreateFolders(options.foldersBase);
    CreateFolders(options.foldersLocal);
    
    options.fileINTERACTAttributeData = fullfile(options.foldersLocal{options.idxINTERACTAttr}{options.idxDataOutput}, 'interact_semantic_attributes.mat');
    
    options.fileINTERACTVerbList = fullfile(options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataInput}, 'verbs_final.csv');
    
    %options.fileAMTINTERACTColl = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataInput}, [options.namesExp{options.idxINTERACTColl}, '.csv']);
    
    options.fileINTERACTandAlexImgs   = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataInput}, 'all_tasks_alex.mat');
    options.folderINTERACTImgs        = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput}, 'found_imgs');
    
    % @TODO Not hardcode feature numbers?
    options.numINTERACTInfoData  = 3;
    options.numINTERACTFeatsPose = 56;
    options.numINTERACTFeatsExpr = 14;
    options.numINTERACTFeatsGaze = 5;
    options.numINTERACTFeatsGend = 4;
    
    options.numPARSEInfoData  = 3;
    options.numPARSEFeatsPose = 28;
    options.numPARSEFeatsExpr = 7;
    options.numPARSEFeatsGaze = 2;
    options.numPARSEFeatsGend = 2;
    
    % INTERACT AMT Files
    options.fileINTERACTAMTImgColl     = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataInput}, 'interact_image_collection.csv');
    options.fileINTERACTAMTImgHumanAgr = fullfile(options.foldersLocal{options.idxINTERACTImgHumanAgr}{options.idxDataInput}, 'interact_human_agreement_results.csv');
    options.fileINTERACTAMTImgAttrBL   = fullfile(options.foldersLocal{options.idxINTERACTAttr}{options.idxDataInput}, 'interact_attribute_baseline.results');
    options.fileINTERACTAMTPose        = fullfile(options.foldersLocal{options.idxINTERACTPose}{options.idxDataInput}, 'interact_gt_pose.results');
    options.fileINTERACTAMTExpr        = fullfile(options.foldersLocal{options.idxINTERACTExpr}{options.idxDataInput}, 'interact_gt_expr_results.csv');
    options.fileINTERACTAMTGaze        = fullfile(options.foldersLocal{options.idxINTERACTGaze}{options.idxDataInput}, 'interact_gt_gaze_results.csv');
    options.fileINTERACTAMTGend        = fullfile(options.foldersLocal{options.idxINTERACTGend}{options.idxDataInput}, 'interact_gt_gend_results.csv');
    options.fileINTERACTAMTClipCat     = fullfile(options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataInput}, 'interact_clipart_category.results');
    options.fileINTERACTAMTClipInst    = fullfile(options.foldersLocal{options.idxINTERACTClipInstColl}{options.idxDataInput}, 'interact_clipart_instance.results');
    options.fileINTERACTAMTClipInstWho = fullfile(options.foldersLocal{options.idxINTERACTClipInstWho}{options.idxDataInput}, 'interact_clipart_instance_who.csv');
    
    % PARSE AMT Files
    options.filePARSEAMTExpr     = fullfile(options.foldersLocal{options.idxPARSEExpr}{options.idxDataInput}, 'parse_gt_expr_results.csv');
    options.filePARSEAMTGaze     = fullfile(options.foldersLocal{options.idxPARSEGaze}{options.idxDataInput}, 'parse_gt_gaze_results.csv');
    options.filePARSEAMTGend     = fullfile(options.foldersLocal{options.idxPARSEGend}{options.idxDataInput}, 'parse_gt_gend_results.csv');
    options.filePARSEAMTClipCat  = fullfile(options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataInput}, 'parse_clipart_category.results');
    options.filePARSEAMTClipInst = fullfile(options.foldersLocal{options.idxPARSEClipInstColl}{options.idxDataInput}, 'parse_clipart_instance.results');
          
    options.fileINTERACTavgPose     = fullfile(options.foldersLocal{options.idxINTERACTPose}{options.idxDataOutput}, 'avg_pose_tasks_pose.mat');
    options.fileINTERACTavgPoseExpr = fullfile(options.foldersLocal{options.idxINTERACTExpr}{options.idxDataOutput}, 'avg_pose_tasks_expr.mat');
    options.fileINTERACTavgPoseGaze = fullfile(options.foldersLocal{options.idxINTERACTGaze}{options.idxDataOutput}, 'avg_pose_tasks_gaze.mat');
    options.fileINTERACTavgPoseGend = fullfile(options.foldersLocal{options.idxINTERACTGend}{options.idxDataOutput}, 'avg_pose_tasks_gend.mat');
    
%     options.filePARSEavgPose     = fullfile(options.foldersLocal{options.idxPARSEPose}{options.idxDataOutput},     'avg_pose_tasks_.mat');
    options.filePARSEavgPoseExpr = fullfile(options.foldersLocal{options.idxPARSEExpr}{options.idxDataOutput}, 'avg_pose_tasks_expr.mat');
    options.filePARSEavgPoseGaze = fullfile(options.foldersLocal{options.idxPARSEGaze}{options.idxDataOutput}, 'avg_pose_tasks_gaze.mat');
    options.filePARSEavgPoseGend = fullfile(options.foldersLocal{options.idxPARSEGend}{options.idxDataOutput}, 'avg_pose_tasks_gend.mat');
    
    options.fileInitDatasetInfo     = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput}, 'init_dataset_info.txt');
    options.fileInitDatasetVerbs    = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput}, 'init_dataset_verb_labeling.txt');
    options.fileWorkerGroupings     = fullfile(options.foldersLocal{options.idxINTERACTColl}{options.idxDataOutput}, 'worker_groupings.txt');
    
    options.fileINTERACTImgHumanAgr    = fullfile(options.foldersLocal{options.idxINTERACTImgHumanAgr}{options.idxDataOutput}, 'interact_img_human_agreement.mat');
    options.fileINTERACTDatasetCleanup = fullfile(options.foldersLocal{options.idxINTERACTCleanup}{options.idxDataOutput}, 'interact_cleaned_up.mat');
    
    options.fileFmtINTERACTGISTFeat = fullfile(options.foldersLocal{options.idxINTERACTCleanup}{options.idxDataOutput}, 'feat_data_GIST_%d_%dx%d.mat');
    
    options.fileINTERACTavgPoseFinal     = fullfile(options.foldersLocal{options.idxINTERACTPose}{options.idxDataOutput}, 'avg_pose_tasks_pose_final.mat');
    options.fileINTERACTavgPoseExprFinal = fullfile(options.foldersLocal{options.idxINTERACTExpr}{options.idxDataOutput}, 'avg_pose_tasks_expr_final.mat');
    options.fileINTERACTavgPoseGazeFinal = fullfile(options.foldersLocal{options.idxINTERACTGaze}{options.idxDataOutput}, 'avg_pose_tasks_gaze_final.mat');
    options.fileINTERACTavgPoseGendFinal = fullfile(options.foldersLocal{options.idxINTERACTGend}{options.idxDataOutput}, 'avg_pose_tasks_gend_final.mat');
    
    %% INTERACT Image Features
    options.INTERACTImgFeatFolderName = 'features';
    outputBaseFolder = options.foldersLocal{options.idxINTERACTCalcFeat}{options.idxDataOutput};
    featFolder = fullfile(outputBaseFolder);
    if ~exist(featFolder, 'dir')
        mkdir(featFolder);
    end
    
    % Specifying the MATLAB files for INTERACT image features
    options.fileINTERACTImgDataInfoGT      = fullfile(featFolder, 'interact_imageGT_info_data.txt');
    options.fileINTERACTImgVerbLabelGT     = fullfile(featFolder, 'interact_imageGT_verb_labeling.txt');
    options.fileINTERACTImgNE2GT           = fullfile(featFolder, 'interact_imageGT_not_eq2_count.txt');
    options.fileINTERACTImgBadAnnGT        = fullfile(featFolder, 'interact_imageGT_bad_ann_count.txt');
    options.fileINTERACTImgWorkerGT        = fullfile(featFolder, 'interact_imageGT_worker_groupings.txt');
    
    options.fileINTERACTImgPoseDataGT1     = fullfile(featFolder, 'interact_imageGT_order1_pose.txt');
    options.fileINTERACTImgPoseDataGT2     = fullfile(featFolder, 'interact_imageGT_order2_pose.txt');
    
    options.fileINTERACTImgExprDataGT1     = fullfile(featFolder, 'interact_imageGT_order1_exprFeat.txt');
    options.fileINTERACTImgExprDataGT2     = fullfile(featFolder, 'interact_imageGT_order2_exprFeat.txt');
    options.fileINTERACTImgExprDataYRD1    = fullfile(featFolder, 'interact_imageYRD_order1_exprFeat.txt');
    options.fileINTERACTImgExprDataYRD2    = fullfile(featFolder, 'interact_imageYRD_order2_exprFeat.txt');
    options.fileINTERACTImgExprDataYRBB1   = fullfile(featFolder, 'interact_imageYRBB_order1_exprFeat.txt');
    options.fileINTERACTImgExprDataYRBB2   = fullfile(featFolder, 'interact_imageYRBB_order2_exprFeat.txt');
    
    options.fileINTERACTImgGazeDataGT1_m   = fullfile(featFolder, 'interact_imageGT_order1_gazeFeat_missing.txt');
    options.fileINTERACTImgGazeDataGT1_z   = fullfile(featFolder, 'interact_imageGT_order1_gazeFeat_zero.txt');
    options.fileINTERACTImgGazeDataGT1_p   = fullfile(featFolder, 'interact_imageGT_order1_gazeFeat_prior.txt');
    options.fileINTERACTImgGazeDataGT2_m   = fullfile(featFolder, 'interact_imageGT_order2_gazeFeat_missing.txt');
    options.fileINTERACTImgGazeDataGT2_z   = fullfile(featFolder, 'interact_imageGT_order2_gazeFeat_zero.txt');
    options.fileINTERACTImgGazeDataGT2_p   = fullfile(featFolder, 'interact_imageGT_order2_gazeFeat_prior.txt');
    
    options.finalGazeData = 3; % 1 -> missing, 2 -> zero, 3 -> prior
    options.fileINTERACTImgGazeDataGT1     = fullfile(featFolder, 'interact_imageGT_order1_gazeFeat.txt');
    options.fileINTERACTImgGazeDataGT2     = fullfile(featFolder, 'interact_imageGT_order2_gazeFeat.txt');
    options.fileINTERACTImgGazeDataYRD1    = fullfile(featFolder, 'interact_imageYRD_order1_gazeFeat.txt');
    options.fileINTERACTImgGazeDataYRD2    = fullfile(featFolder, 'interact_imageYRD_order2_gazeFeat.txt');
    options.fileINTERACTImgGazeDataYRBB1   = fullfile(featFolder, 'interact_imageYRBB_order1_gazeFeat.txt');
    options.fileINTERACTImgGazeDataYRBB2   = fullfile(featFolder, 'interact_imageYRBB_order2_gazeFeat.txt');

    options.fileINTERACTImgGendDataGT1     = fullfile(featFolder, 'interact_imageGT_order1_gendFeat.txt');
    options.fileINTERACTImgGendDataGT2     = fullfile(featFolder, 'interact_imageGT_order2_gendFeat.txt');
    options.fileINTERACTImgGendDataYRD1    = fullfile(featFolder, 'interact_imageYRD_order1_gendFeat.txt');
    options.fileINTERACTImgGendDataYRD2    = fullfile(featFolder, 'interact_imageYRD_order2_gendFeat.txt');
    options.fileINTERACTImgGendDataYRBB1   = fullfile(featFolder, 'interact_imageYRBB_order1_gendFeat.txt');
    options.fileINTERACTImgGendDataYRBB2   = fullfile(featFolder, 'interact_imageYRBB_order2_gendFeat.txt');

    options.fileINTERACTImgPoseDataInfoYRD = fullfile(featFolder, 'interact_imageYRD_info_data.txt');
    options.fileINTERACTImgPoseDataYRD1    = fullfile(featFolder, 'interact_imageYRD_order1_pose.txt');
    options.fileINTERACTImgPoseDataYRD2    = fullfile(featFolder, 'interact_imageYRD_order2_pose.txt');
    options.fileINTERACTImgPoseDataInfoYRBB= fullfile(featFolder, 'interact_imageYRBB_info_data.txt');
    options.fileINTERACTImgPoseDataYRBB1   = fullfile(featFolder, 'interact_imageYRBB_order1_pose.txt');
    options.fileINTERACTImgPoseDataYRBB2   = fullfile(featFolder, 'interact_imageYRBB_order2_pose.txt');
    
    % INTERACT Clipart Category Features
    %% Variables for the features
    % filename1.txt is for correct ordering
    % filename2.txt is for flipped ordering
    outputBaseFolder = options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataOutput};
    expName = options.namesExp{options.idxINTERACTClipCatColl};
    featFolder = fullfile(outputBaseFolder, 'features');
    if ~exist(featFolder, 'dir')
        mkdir(featFolder);
    end
    
    options.fileINTERACTClipCatInfoData  = fullfile(featFolder, 'interact_clipart_category_info_data.txt');
    options.fileINTERACTClipCatLabelData = fullfile(featFolder, 'interact_clipart_category_verb_labeling.txt');
    options.fileINTERACTClipCatPoseData1 = fullfile(featFolder, 'interact_clipart_category_order1_pose.txt');
    options.fileINTERACTClipCatExprData1 = fullfile(featFolder, 'interact_clipart_category_order1_exprFeat.txt');
    options.fileINTERACTClipCatGazeData1 = fullfile(featFolder, 'interact_clipart_category_order1_gazeFeat.txt');
    options.fileINTERACTClipCatGendData1 = fullfile(featFolder, 'interact_clipart_category_order1_gendFeat.txt');
    options.fileINTERACTClipCatPoseData2 = fullfile(featFolder, 'interact_clipart_category_order2_pose.txt');
    options.fileINTERACTClipCatExprData2 = fullfile(featFolder, 'interact_clipart_category_order2_exprFeat.txt');
    options.fileINTERACTClipCatGazeData2 = fullfile(featFolder, 'interact_clipart_category_order2_gazeFeat.txt');
    options.fileINTERACTClipCatGendData2 = fullfile(featFolder, 'interact_clipart_category_order2_gendFeat.txt');
    
    options.INTERACTClipInstFeatFolderName = 'features';
    outputBaseFolder = options.foldersLocal{options.idxINTERACTClipInstColl}{options.idxDataOutput};
    expName = options.namesExp{options.idxINTERACTClipInstColl};
    featFolder = fullfile(outputBaseFolder, 'features');
        if ~exist(featFolder, 'dir')
        mkdir(featFolder);
    end
    
    options.fileINTERACTClipInstWho  = fullfile(options.foldersLocal{options.idxINTERACTClipInstWho}{options.idxDataOutput}, 'interact_clipart_instance_who_is_who.txt');
    
    options.fileINTERACTClipInstOrdering  = fullfile(featFolder, 'interact_clipart_instance_gt_ordering.txt');
    options.fileINTERACTClipInstInfoData  = fullfile(featFolder, 'interact_clipart_instance_info_data.txt');
    options.fileINTERACTClipInstLabelData = fullfile(featFolder, 'interact_clipart_instance_verb_labeling.txt');
    options.fileINTERACTClipInstPoseData1 = fullfile(featFolder, 'interact_clipart_instance_order1_pose.txt');
    options.fileINTERACTClipInstExprData1 = fullfile(featFolder, 'interact_clipart_instance_order1_exprFeat.txt');
    options.fileINTERACTClipInstGazeData1 = fullfile(featFolder, 'interact_clipart_instance_order1_gazeFeat.txt');
    options.fileINTERACTClipInstGendData1 = fullfile(featFolder, 'interact_clipart_instance_order1_gendFeat.txt');
    options.fileINTERACTClipInstPoseData2 = fullfile(featFolder, 'interact_clipart_instance_order2_pose.txt');
    options.fileINTERACTClipInstExprData2 = fullfile(featFolder, 'interact_clipart_instance_order2_exprFeat.txt');
    options.fileINTERACTClipInstGazeData2 = fullfile(featFolder, 'interact_clipart_instance_order2_gazeFeat.txt');
    options.fileINTERACTClipInstGendData2 = fullfile(featFolder, 'interact_clipart_instance_order2_gendFeat.txt');
    
    %% PARSE Image Features
    options.folderYR          = fullfile(options.folders3rdParty{options.idxYRPose});
    options.folderYRPARSE     = fullfile(options.folderYR, 'PARSE');
    options.fileYRPARSEGTPose = fullfile(options.folderYRPARSE, 'labels.mat'); % Ground-truth annotations
    options.fileYRPARSEYRPose = fullfile(options.foldersLocal{options.idxPARSEYRPose}{options.idxDataOutput}, 'parse_poses_yr.mat');
    
    options.PARSEImgFeatFolderName = 'features';
    outputBaseFolder = options.foldersLocal{options.idxPARSECalcFeat}{options.idxDataOutput};
    featFolder = fullfile(outputBaseFolder);
    if ~exist(featFolder, 'dir')
        mkdir(featFolder);
    end
    
    % Specifying the MATLAB files for PARSE image features
    
    options.filePARSEVerbList            = fullfile(options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataInput}, 'parse_categories.txt');
    options.filePARSECategorization      = fullfile(options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataInput}, 'parse_img_categorization.txt');
    options.filePARSECategorizationFinal = fullfile(options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataInput}, 'parse_img_categorization_final.txt');
    
    options.filePARSEImgDataInfoGT      = fullfile(featFolder, 'parse_imageGT_info_data.txt');
    options.filePARSEImgVerbLabelGT     = fullfile(featFolder, 'parse_imageGT_verb_labeling.txt');
    options.filePARSEImgNE2GT           = fullfile(featFolder, 'parse_imageGT_not_eq2_count.txt');
    options.filePARSEImgBadAnnGT        = fullfile(featFolder, 'parse_imageGT_bad_ann_count.txt');
    options.filePARSEImgWorkerGT        = fullfile(featFolder, 'parse_imageGT_worker_groupings.txt');
    
    options.filePARSEImgPoseDataGT1     = fullfile(featFolder, 'parse_imageGT_order1_pose.txt');
    
    options.filePARSEImgExprDataGT1     = fullfile(featFolder, 'parse_imageGT_order1_exprFeat.txt');
    options.filePARSEImgExprDataYRD1    = fullfile(featFolder, 'parse_imageYRD_order1_exprFeat.txt');
    
    options.filePARSEImgGazeDataGT1     = fullfile(featFolder, 'parse_imageGT_order1_gazeFeat.txt');
    options.filePARSEImgGazeDataYRD1    = fullfile(featFolder, 'parse_imageYRD_order1_gazeFeat.txt');
    
    options.filePARSEImgGendDataGT1     = fullfile(featFolder, 'parse_imageGT_order1_gendFeat.txt');
    options.filePARSEImgGendDataYRD1    = fullfile(featFolder, 'parse_imageYRD_order1_gendFeat.txt');
    
    options.filePARSEImgPoseDataInfoYRD = fullfile(featFolder, 'parse_imageYRD_info_data.txt');
    options.filePARSEImgPoseDataYRD1    = fullfile(featFolder, 'parse_imageYRD_order1_pose.txt');
    
    % PARSE Clipart Category Features
    %% Variables for the features
    outputBaseFolder = options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataOutput};
    featFolder = fullfile(outputBaseFolder, 'features');
    
    options.filePARSEClipCatInfoData  = fullfile(featFolder, 'parse_clipart_category_info_data.txt');
    options.filePARSEClipCatLabelData = fullfile(featFolder, 'parse_clipart_category_verb_labeling.txt');
    options.filePARSEClipCatPoseData1 = fullfile(featFolder, 'parse_clipart_category_order1_pose.txt');
    options.filePARSEClipCatExprData1 = fullfile(featFolder, 'parse_clipart_category_order1_exprFeat.txt');
    options.filePARSEClipCatGazeData1 = fullfile(featFolder, 'parse_clipart_category_order1_gazeFeat.txt');
    options.filePARSEClipCatGendData1 = fullfile(featFolder, 'parse_clipart_category_order1_gendFeat.txt');

    % PARSE Clipart Instance Features
    %% Variables for the features
    outputBaseFolder = options.foldersLocal{options.idxPARSEClipInstColl}{options.idxDataOutput};
    featFolder = fullfile(outputBaseFolder, 'features');
    
    options.filePARSEClipInstInfoData  = fullfile(featFolder, 'parse_clipart_instance_info_data.txt');
    options.filePARSEClipInstLabelData = fullfile(featFolder, 'parse_clipart_instance_verb_labeling.txt');
    options.filePARSEClipInstPoseData1 = fullfile(featFolder, 'parse_clipart_instance_order1_pose.txt');
    options.filePARSEClipInstExprData1 = fullfile(featFolder, 'parse_clipart_instance_order1_exprFeat.txt');
    options.filePARSEClipInstGazeData1 = fullfile(featFolder, 'parse_clipart_instance_order1_gazeFeat.txt');
    options.filePARSEClipInstGendData1 = fullfile(featFolder, 'parse_clipart_instance_order1_gendFeat.txt');
    
end