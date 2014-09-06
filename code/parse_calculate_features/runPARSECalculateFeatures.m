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

% Add path for some common MTurk task data-related functions
addpath(fullfile('..', 'common'));
addpath(fullfile('..', 'features'));

%% Gets the options that govern directories, what runs, etc.
options = CreateOptionsGlobal();
options = CreateOptionsLocal(options);

%% Gets GT poses from PARSE dataset
if ( options.createGTPoseFiles ~= 0 )

    files = dir(fullfile(options.folderYRPARSE, '*.jpg')); % PARSE are all .jpg
    filenames = extractfield(files, 'name');

    load(options.fileYRPARSEGTPose); % Loads ptsAll
    imgPoses = {};
    for imgIdx = 1:length(filenames)
        imgPoses{imgIdx, 1} = ptsAll(options.PARSEGT2Stickman, :, imgIdx);
    end

    SavingPARSEPoses(options, filenames, imgPoses);
end

if ( options.createYRPoseFiles ~= 0 )
   load(options.fileYRPARSEYRPose); % loads struct with YR poses in number order
   
   for idx = 1:length(parsePosesYR)
       poseData = [reshape(parsePosesYR(idx).pose', 2*options.numParts, 1);];
       allPoseData(idx, :) = poseData;
   end

   dlmwrite(options.filePARSEImgPoseDataYRD1, allPoseData, ';');
end

if ( 0 )
    numPeople = 1;
    scaledSigma = ComputeYRSigma(options.filePARSEImgPoseDataGT1, options.poseDataYRFile1, numPeople);
end

if ( options.calculateGTPoseFeats ~= 0 )
    ComputeFeatures(options.filePARSEImgDataInfoGT, options.filePARSEImgPoseDataGT1, options.numPeople, options.isReal, options.numOrient, options.visualize);
end

if ( options.calculateYRPoseFeats ~= 0 )
    ComputeFeatures(options.filePARSEImgDataInfoGT, options.filePARSEImgPoseDataYRD1, options.numPeople, options.isReal, options.numOrient, options.visualize);    
end

if ( options.calculateExprFeats ~= 0 )
    load(options.filePARSEavgPoseExpr);
    ComputeIndvExprFeatures(options, avgPoseTasksExpr);
    copyfile(options.filePARSEImgExprDataGT1, options.filePARSEImgExprDataYRD1);
end

if ( options.calculateGazeFeats ~= 0 )
    load(options.fileYRPARSEGTPose); % Loads ptsAll
    imgPoses = {};
    for imgIdx = 1:size(ptsAll, 3)
        imgPoses{imgIdx, 1} = ptsAll(options.PARSEGT2Stickman, :, imgIdx);
    end
    
    load(options.filePARSEavgPoseGaze); % Loads avgPoseTasksGaze
    ComputeIndvGazeFeatures(options, imgPoses, avgPoseTasksGaze);
    copyfile(options.filePARSEImgGazeDataGT1, options.filePARSEImgGazeDataYRD1);
end

if ( options.calculateGenderFeats ~= 0 )
    load(options.filePARSEavgPoseGend);
    ComputeIndvGenderFeatures(options, avgPoseTasksGender);
    copyfile(options.filePARSEImgGendDataGT1, options.filePARSEImgGendDataYRD1);
end

% fun = 'ComputeFeatures.m'; [list,builtins,classes,prob_files,~,eval_strings, called_from] = depfun(fun);