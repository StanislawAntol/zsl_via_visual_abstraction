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

    options.readData                 = 1;
    
    % INTERACT Category-level ZSL
    options.runINTERACTCatExp        = 1;
    options.runINTERACTCatExpTrain   = 1;
    options.runINTERACTCatExpDAP     = 1;
    options.runINTERACTCatExpAccCalc = 1;
    options.runINTERACTCatExpAccPlot = 1;    
    options.runINTERACTCatExpQual    = 1;
    options.runINTERACTCatExpConfMat = 1;
    
    % INTERACT Category-level ZSL Feature Ablation
    options.runINTERACTCatFeatAblationExp        = 1;
    options.runINTERACTCatFeatAblationExpTrain   = 1;
    options.runINTERACTCatFeatAblationExpAccCalc = 1;
    options.runINTERACTCatFeatAblationExpAccPlot = 1;
    
    % INTERACT Category-level ZSL Part Thresholhd
    options.runINTERACTCatPartThresholdExp        = 1;
    options.runINTERACTCatPartThresholdExpTrain   = 1;
    options.runINTERACTCatPartThresholdExpAccCalc = 1;
    options.runINTERACTCatPartThresholdExpAccPlot = 1;
    
    % INTERACT Instance-level ZSL
    options.runINTERACTInstExp        = 1;
    options.runINTERACTInstExpOrder   = 1; % Only need to run once. This computes the correct ordering for people so Person 1 is in the first half of features.
    options.runINTERACTInstExpTrain   = 1;
    options.runINTERACTInstExpAccPlot = 1;
    options.runINTERACTInstExpQual    = 0;
    
    % PARSE Category-level ZSL
    options.runPARSECatExp        = 1;
    options.runPARSECatExpTrain   = 1;
    options.runPARSECatExpAccCalc = 1;
    options.runPARSECatExpAccPlot = 1;
    options.runPARSECatExpQual    = 1;
    options.runPARSECatExpConfMat = 1;
    
    % PARSE Instance-level ZSL
    options.runPARSEInstExp        = 1;
    options.runPARSEInstExpTrain   = 1;
    options.runPARSEInstExpAccPlot = 1;
    options.runPARSEInstExpQual    = 0;
    
    %     options.whichData = [ 1 2 3 4 5 6 ];
    options.allNumOrders = [2, 2, 2, 2, 2, 1, 1, 1, 1];
    options.numJoints = 14;

    %% Name of experiment to process (must be same name as results file!)
    options.expType = options.namesLocal{options.idxExperiments};
    options.expName = options.namesExp{options.idxExperiments};

    options.outputBaseFolder  = options.foldersLocal{options.idxExperiments}{options.idxDataOutput};

    options.data1FolderName   = 'features';
    options.data2FolderName   = 'models_instance';
    options.data3FolderName   = 'models_category';
    options.data4FolderName   = 'accuracies';
    options.data5FolderName   = 'plots';
    options.data6FolderName   = 'mapping';
    options.data7FolderName   = 'models_category_feat_ablation';
    options.data8FolderName   = 'models_category_part_ablation';
    options.outputFolder      = fullfile(options.outputBaseFolder);
    options.data1Folder       = fullfile(options.outputFolder, options.data1FolderName);
    options.data2Folder       = fullfile(options.outputFolder, options.data2FolderName);
    options.data3Folder       = fullfile(options.outputFolder, options.data3FolderName);
    options.data4Folder       = fullfile(options.outputFolder, options.data4FolderName);
    options.data5Folder       = fullfile(options.outputFolder, options.data5FolderName);
    options.data6Folder       = fullfile(options.outputFolder, options.data6FolderName);
    options.data7Folder       = fullfile(options.outputFolder, options.data7FolderName);
    options.data8Folder       = fullfile(options.outputFolder, options.data8FolderName);

    options.orderingFile = fullfile(options.data1Folder, 'clipartOrderingGT.txt');

    options.featBaseName{1} = 'pose_basicFeatures_prior.txt';
    options.featBaseName{2} = 'pose_contactFeatures_prior.txt';
    options.featBaseName{3} = 'pose_globalPositionFeatures_prior.txt';
    options.featBaseName{4} = 'pose_orient12Features_prior.txt';
    options.featBaseName{5} = 'exprFeat.txt';
    options.featBaseName{6} = 'gazeFeat.txt';
    options.featBaseName{7} = 'gendFeat.txt';
    options.featBaseName{8} = 'pose.txt';

    % Must add for YR PARSE
    options.featVarBaseName = ...
        { ...
        'INTERACTClipCat'; ...
        'INTERACTClipInst'; ...
        'INTERACTImgGT'; ...
        'INTERACTImgYRD'; ...
        'INTERACTImgYRBB'; ...
        'PARSEClipCat'; ...
        'PARSEClipInst'; ...
        'PARSEImgGT'; ...
        'PARSEImgYRD'; ...
        };
    options.dataFeatDir = ...
        {
        fullfile(options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataOutput}, 'features'); ...
        fullfile(options.foldersLocal{options.idxINTERACTClipInstColl}{options.idxDataOutput}, 'features'); ...
        fullfile(options.foldersLocal{options.idxINTERACTCalcFeat}{options.idxDataOutput}); ...
        fullfile(options.foldersLocal{options.idxINTERACTCalcFeat}{options.idxDataOutput}); ...
        fullfile(options.foldersLocal{options.idxINTERACTCalcFeat}{options.idxDataOutput}); ...
        fullfile(options.foldersLocal{options.idxPARSEClipCatColl}{options.idxDataOutput}, 'features'); ...
        fullfile(options.foldersLocal{options.idxPARSEClipInstColl}{options.idxDataOutput}, 'features'); ...
        fullfile(options.foldersLocal{options.idxPARSECalcFeat}{options.idxDataOutput}); ...
        fullfile(options.foldersLocal{options.idxPARSECalcFeat}{options.idxDataOutput}); ...
        };
    
    options.dataFeatBaseName = ...
        { ...
        'interact_clipart_category_order'; ...
        'interact_clipart_instance_order'; ...
        'interact_imageGT_order'; ...
        'interact_imageYRD_order'; ...
        'interact_imageYRBB_order'; ...
        'parse_clipart_category_order'; ...
        'parse_clipart_instance_order'; ...
        'parse_imageGT_order'; ...
        'parse_imageYRD_order'; ...
        };
    
    options.dataInfoFile = ...
        { ...
        'interact_clipart_category_info_data.txt'; ...
        'interact_clipart_instance_info_data.txt'; ...
        'interact_imageGT_info_data.txt'; ...
        'interact_imageGT_info_data.txt'; ...
        'interact_imageGT_info_data.txt'; ...
        'parse_clipart_category_info_data.txt'; ...
        'parse_clipart_instance_info_data.txt'; ...
        'parse_imageGT_info_data.txt'; ...
        'parse_imageGT_info_data.txt'; ...
        };
    
    options.classificationDataFile = ...
        { ...
        fullfile(options.data1Folder, 'loadedINTERACTClipCatFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedINTERACTClipInstFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedINTERACTImgGTFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedINTERACTImgYRDFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedINTERACTImgYRBBFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedPARSEClipCatFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedPARSEClipInstFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedPARSEImgGTFeatData.mat'); ...
        fullfile(options.data1Folder, 'loadedPARSEImgYRFeatData.mat'); ...
        };

    options.mappingDataFile = sprintf('%s%s', options.data6Folder, ...
       'mapping_expType_%d_trainP_%06.2f_curSeedVal_%d_featSet_%s_method_%d_spread_%06.3f_PCA%06.2f');
    options.retrievalExpDataFile = sprintf('%s%s', options.data2Folder, ...
       'retrieval_expType_%d_trainP_%06.2f_curSeedVal_%d_featSet_%s_method_%d_PCA%06.2f_evalOnTrain_%d');

    options.retrievalZSLPlotFileFmt = sprintf('%s%s', options.data5Folder, 'retrievalZSL_expType_%d_trainP_%06.2f_featSet_%s_method_%s_PCA%06.2f_evalOnTrain_%d'); 
    options.retrievalPlotFileFmt = sprintf('%s%s', options.data5Folder, 'retrieval_expType_%d_trainP_%06.2f_featSet_%s_method_%s_PCA%06.2f_evalOnTrain_%d');
    
    options.zslCatPlotFileFmt     = sprintf('%s', fullfile(options.data5Folder, 'zsl_category_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%d_probTest_%d_feats_%s_trainOnKs_%s_numRandKs_%s'));
    options.zslCatFeatPlotFileFmt = sprintf('%s', fullfile(options.data5Folder, 'zsl_category_feat_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%d_probTest_%d_feats_%s_trainOnKs_%s_numRandKs_%s'));
    options.zslCatPartPlotFileFmt = sprintf('%s', fullfile(options.data5Folder, 'zsl_category_part_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%d_probTest_%d_feats_%s_trainOnKs_%s_numRandKs_%s'));
    options.zslInstPlotFileFmt    = sprintf('%s', fullfile(options.data5Folder, 'zsl_instance_datasetID_%d_trainPerc_%03d_randSplits_%02d_featSet_%s_detectionID_%s_mappings_%s_yToX_%d_spread_%05.2f_grnnMeth_%s'));
    
    options.zslCatConfMatFileFmt  = sprintf('%s', fullfile(options.data5Folder, 'zsl_category_confusion_matrix_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%d_probTest_%d_feats_%s_trainOnKs_%s_numRandKs_%s'));
    
    options.saveModelDAPFormatStr          = '%s_dap_datasetID_%d_featSet_%s_detectionID_%d_biasTrain_%d_probTest_%d_trainOnK_%03d_randIdx_%03d';
    options.saveModelZSLCatFormatStr       = '%s_datasetID_%d_featSet_%s_detectionID_%d_biasTrain_%d_probTest_%d_trainOnK_%03d_randIdx_%03d';
    options.saveModelZSLInstFormatStr      = '%s_datasetID_%d_featSet_%s_spread_%.2e_mapID_%d_trainGRNNID_%02d_detectionID_%d';
    options.saveModelZSLInstFormatStrNew   = '%s_datasetID_%d_featSet_%s_crosstrain_spread_%.2e';
    
    options.saveAccuraciesZSLCatFormatStr      = '%s_cat_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%s_probTest_%s_trainOnK_%s_randIdxs_%s';
    options.saveAccuraciesZSLCatFeatFormatStr  = '%s_cat_feat_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%s_probTest_%s_trainOnK_%s_randIdxs_%s';
    options.saveAccuraciesZSLCatPartFormatStr  = '%s_cat_part_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%s_probTest_%s_trainOnK_%s_randIdxs_%s';
    options.saveAccuraciesDAPFormatStr         = '%s_cat_dap_datasetID_%d_featSet_%s_detectionID_%s_biasTrain_%s_probTest_%s_trainOnK_%s_randIdxs_%s';
    options.saveAccuraciesZSLInstFormatStr     = '%s_inst_datasetID_%d_featSet_%s_spread_%.2e_mapID_%d_trainGRNNID_%02d_detectionID_%d';
    options.saveAccuraciesZSLInstFormatStrNoSpread = '%s_inst_datasetID_%d_featSet_%s_mapID_%d_trainGRNNID_%d_detectionID_%d';
    options.saveAccuraciesZSLInstFormatStrNew  = '%s_inst_datasetID_%d_featSet_%s_crosstrain_spread_%.2e';

%     options.saveAccuraciesZSLInstFormatStr = sprintf('%s%s', options.data2Folder, ...
%        'retrieval_expType_%d_trainP_%06.2f_featSet_%s_method_%d_PCA%06.2f_evalOnTrain_%d');

    options.classificationModelFileInst    = fullfile(options.outputFolder, options.data2FolderName, 'zsl_inst');
    
    options.classificationModelFileCat     = fullfile(options.outputFolder, options.data3FolderName, 'zsl_cat');
    options.classificationModelFileCatFeat = fullfile(options.outputFolder, options.data7FolderName, 'zsl_cat_feat');
    options.classificationModelFileCatPart = fullfile(options.outputFolder, options.data8FolderName, 'zsl_cat_part' );
    options.classificationAccuraciesFile   = fullfile(options.outputFolder, options.data4FolderName, 'accuracies');

    options.humanAgreementBaseDir = '../../data/output/human_agreement/full_exp_1/';
    options.humanAgreementClipartDataFile = fullfile(options.humanAgreementBaseDir, 'clipart', 'clipartHumanAgreementCurve.txt');
    options.humanAgreementRealDataFile = fullfile(options.humanAgreementBaseDir, 'real', 'realHumanAgreementCurve.txt');
    
end