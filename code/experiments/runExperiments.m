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

% function runExperiments
%clear;

% Add path for some common MTurk task data-related functions
addpath(fullfile('..', 'common'));
addpath(fullfile('..', 'interact_attribute_baseline'));

%% Gets the options that govern directories, what runs, etc.
options = CreateOptionsGlobal();
options = CreateOptionsLocal(options);

addpath(options.folders3rdParty{options.idxLibLinear});
%addpath(options.folders3rdParty{options.idxLibSVM});
addpath(genpath(options.folders3rdParty{options.idxPiotr}));


%% Make sure all the necessary folders are in place
folders = { ...   
    options.outputFolder; ...
    options.data1Folder; ...
    options.data2Folder; ...
    options.data3Folder; ...
    options.data4Folder; ...
    options.data5Folder; ...
    options.data6Folder; ...
    options.data7Folder; ...
    options.data8Folder; ...
    };

for f = 1:numel(folders)
    curFolder = folders{f};
    if ~exist(curFolder, 'dir')
        mkdir(curFolder);
    end
end

%% Read in all of the feature data
% Only need to do this once (unless you update the features)
if ( options.readData ~= 0 )
    whichData = [1 2 3 4 5]; % Just INTERACT
    whichData = [6 7 8 9]; % Just PARSE
    whichData = [ 1 2 3 4 5 6 7 8 9 ]; % All data
% whichData = 2;
    for i = 1:length(whichData)
        ReadAndSaveFeatDataIndv(options, whichData(i));
    end
end

if ( options.runINTERACTCatExp ~= 0 )
    parameters = CreateParametersINTERACTCatExp();
    runINTERACTCategoryExperiment;
end

if ( options.runINTERACTCatFeatAblationExp ~= 0 )
    parameters = CreateParametersINTERACTCatFeatAblationExp();
    runINTERACTCategoryFeatAblationExperiment;
end

if ( options.runINTERACTCatPartThresholdExp ~= 0 )
    parameters = CreateParametersINTERACTCatPartThresholdExp();
    runINTERACTCategoryPartThresholdExperiment;
end

if ( options.runINTERACTInstExp ~= 0 )
   parameters = CreateParametersINTERACTInstExp();
   runINTERACTInstanceExperiment;
%      parameters = CreateParametersINTERACTInstExpSwapDiffSubsets();
%      runINTERACTInstanceExperimentSwapDiffSubsets;
end

if ( options.runPARSECatExp ~= 0 )
    parameters = CreateParametersPARSECatExp();
    runPARSECategoryExperiment;
end

if ( options.runPARSEInstExp ~= 0 )
    parameters = CreateParametersPARSEInstExp();
   runPARSEInstanceExperiment;
%      runPARSEInstanceExpRandBaseline;
end