%runAllCode Allows you to run the code for all parts of the project.
%
%  INPUT
%   Have all of the AMT results files in the appropriate directories
%   and make sure that ./common/CreateOptionsGlobal.m is updated
%   for where the directories for the data and 3rd party packages are.
%
%  OUTPUT
%    This produces everything, including data from parsing the AMT data. 
%    The AMT data was anonymized so the worker IDs are randomly assigned,
%    but there is worker ID consistency across all data collection.
%    It then runs the experiments for the ECCV 2014 paper.
%
%  NOTES
%    MATLAB 2014a is the preferred system. GRNN function in 2013a has a
%    bug, so it takes up 200GB of memory (vs 1.3GB in 2014a).
%    It also uses imtransform, which is a new function (R2013a and later)
%    of the Image Proccesing Toolbox that replaces imwarp.
%
%  Author: Stanislaw Antol (santol@vt.edu)                 Date: 2014-08-18

addpath('common');

%% Let's you toggle what code runs
createPARSEYRPose         = 0;
createPARSEGTExpr         = 0;	
createPARSEGTGaze         = 0;
createPARSEGTGend         = 0;
createPARSEFeats          = 0;
createPARSEClipCat        = 0; 
createPARSEClipInst       = 0; 

createINTERACTDatasetDL   = 0;
createINTERACTGTPose      = 0;
createINTERACTGTExpr      = 0;
createINTERACTGTGaze      = 0;
createINTERACTGTGend      = 0;
createINTERACTHumanAgr    = 0;
createINTERACTDatasetF    = 0;
createINTERACTYRPose      = 0;
createINTERACTFeats       = 0;
createINTERACTClipCat     = 0;
createINTERACTClipInst    = 0;
createINTERACTClipInstWho = 0;
createINTERACTAttributes  = 0;

runExp                    = 1;

clearVarsStr = ['clearvars -except ', ...
    '-regexp createPARSE* createINTERACT* runExp* clearVarsStr', ...
    ];
% clearVarsStr = ''; % Don't delete variables from individual script runs

%% Process all of the PARSE-related data

if ( createPARSEYRPose )
    cd('parse_yr_pose');
    runPARSEYRPose;
    cd('..');
    eval(clearVarsStr);
end

if ( createPARSEGTExpr )
    cd('parse_gt_expr');
    runPARSEGTExpr;
    cd('..');
    eval(clearVarsStr);
end

if ( createPARSEGTGaze )
    cd('parse_gt_gaze');
    runPARSEGTGaze;
    cd('..');
    eval(clearVarsStr);
end

if ( createPARSEGTGend )
    cd('parse_gt_gender');
    runPARSEGTGender;
    cd('..');
    eval(clearVarsStr);
end

if ( createPARSEFeats ) 
    cd('parse_calculate_features');
    runPARSECalculateFeatures;
    cd('..');
    eval(clearVarsStr);
end

if ( createPARSEClipCat )
    cd('parse_clipart_category_collection');
    runPARSEClipartCategoryCollection;
    cd('..');
    eval(clearVarsStr);
end

if ( createPARSEClipInst )
    cd('parse_clipart_instance_collection');
    runPARSEClipartInstanceCollection;
    cd('..');
    eval(clearVarsStr);
end

%% Process all of the INTERACT-related data
if ( createINTERACTDatasetDL )
    cd('interact_image_collection');
    runINTERACTImageCollection;
    % You probably want to just use the already downloaded images
    % since the downloading code is not very robust...
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTGTPose )
    cd('interact_gt_pose');
    runINTERACTGTPose;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTGTExpr )
    cd('interact_gt_expr');
    runINTERACTGTExpr;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTGTGaze )
    cd('interact_gt_gaze');
    runINTERACTGTGaze;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTGTGend )
    cd('interact_gt_gender');
    runINTERACTGTGender;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTHumanAgr )
    cd('interact_human_agreement');
    runINTERACTHumanAgreement;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTDatasetF )
    cd('interact_dataset_cleanup');
    runINTERACTDatasetCleanup;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTYRPose )
    cd('interact_yr_pose');
    runINTERACTYRPose;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTFeats )
    cd('interact_calculate_features');
    runINTERACTCalculateFeatures;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTClipCat )
    cd('interact_clipart_category_collection');
    runINTERACTClipartCategoryCollection;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTClipInst )
    cd('interact_clipart_instance_collection');
    runINTERACTClipartInstanceCollection;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTClipInstWho )
    cd('interact_clipart_instance_who_is_who');
    runINTERACTClipartInstanceWhoIsWho;
    cd('..');
    eval(clearVarsStr);
end

if ( createINTERACTAttributes )
    cd('interact_attribute_baseline');
    runINTERACTAttributeBaseline;
    cd('..');
    eval(clearVarsStr);
end

%% Run the experiments for the ECCV 2014 paper
if ( runExp )
    cd('experiments');
    runExperiments;
    cd('..');
    eval(clearVarsStr);
end