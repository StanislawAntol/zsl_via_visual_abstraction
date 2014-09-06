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

%% Computes the pose features for averaged posess
if ( options.createPoseFiles ~= 0 )
    load(options.fileINTERACTavgPoseFinal);
    SavingAvgPoses(options, avgPoseTasks);
end

if ( options.calculatePoseFeats ~= 0 )
    ComputeFeatures(options.fileINTERACTImgDataInfoGT, options.fileINTERACTImgPoseDataGT1, options.numPeople, options.isReal, options.numOrients, options.visualize);
    ComputeFeatures(options.fileINTERACTImgDataInfoGT, options.fileINTERACTImgPoseDataGT2, options.numPeople, options.isReal, options.numOrients, options.visualize); 
end

if ( options.calculateYRDPoseFeats ~= 0 )
    ComputeFeatures(options.fileINTERACTImgDataInfoGT, options.fileINTERACTImgPoseDataYRD1, options.numPeople, options.isReal, options.numOrients, options.visualize);
    ComputeFeatures(options.fileINTERACTImgDataInfoGT, options.fileINTERACTImgPoseDataYRD2, options.numPeople, options.isReal, options.numOrients, options.visualize);
end

if ( options.calculateYRBBPoseFeats ~= 0 )
    ComputeFeatures(options.fileINTERACTImgDataInfoGT, options.fileINTERACTImgPoseDataYRBB1, options.numPeople, options.isReal, options.numOrients, options.visualize);
    ComputeFeatures(options.fileINTERACTImgDataInfoGT, options.fileINTERACTImgPoseDataYRBB2, options.numPeople, options.isReal, options.numOrients, options.visualize);
end

if ( options.calculateExprFeats ~= 0 )

    load(options.fileINTERACTavgPoseExprFinal);
    ComputeExprFeatures(options, avgPoseTasksExpr);
    
    % Copy files as YR data (easier in later code)
    copyfile(options.fileINTERACTImgExprDataGT1, options.fileINTERACTImgExprDataYRD1);
    copyfile(options.fileINTERACTImgExprDataGT2, options.fileINTERACTImgExprDataYRD2);
    copyfile(options.fileINTERACTImgExprDataGT1, options.fileINTERACTImgExprDataYRBB1);
    copyfile(options.fileINTERACTImgExprDataGT2, options.fileINTERACTImgExprDataYRBB2);
    
end

if ( options.calculateNE2Feats ~= 0 )
    load(options.fileINTERACTavgPoseExprFinal);
    NE2Vals = extractfield(avgPoseTasksExpr, 'NE2Count')';
	dlmwrite(options.fileINTERACTImgNE2GT, NE2Vals, ';');
end

if ( options.calculateGazeFeats ~= 0 )
%     load(options.avgPosesGazeFile);
    load(options.fileINTERACTavgPoseGazeFinal);
    ComputeGazeFeatures(options, avgPoseTasksGaze);
    
    if ( options.finalGazeData == 1 )
        src1 = options.fileINTERACTImgGazeDataGT1_m;
        src2 = options.fileINTERACTImgGazeDataGT2_m;
    elseif ( options.finalGazeData == 2 )
        src1 = options.fileINTERACTImgGazeDataGT1_z;
        src2 = options.fileINTERACTImgGazeDataGT2_z;
    else
        src1 = options.fileINTERACTImgGazeDataGT1_p;
        src2 = options.fileINTERACTImgGazeDataGT2_p;
    end
    
    copyfile(src1, options.fileINTERACTImgGazeDataGT1)
    copyfile(src2, options.fileINTERACTImgGazeDataGT2)
    
    % Copy files as YR data (easier in later code)
    copyfile(options.fileINTERACTImgGazeDataGT1, options.fileINTERACTImgGazeDataYRD1);
    copyfile(options.fileINTERACTImgGazeDataGT2, options.fileINTERACTImgGazeDataYRD2);
    copyfile(options.fileINTERACTImgGazeDataGT1, options.fileINTERACTImgGazeDataYRBB1);
    copyfile(options.fileINTERACTImgGazeDataGT2, options.fileINTERACTImgGazeDataYRBB2);
    
end

if ( options.calculateBadAnns ~= 0 )
    load(options.fileINTERACTavgPoseGazeFinal);
    badAnnVals = extractfield(avgPoseTasksGaze, 'badAnnTotal')';
    dlmwrite(options.fileINTERACTImgBadAnnGT, badAnnVals, ';');
end

if ( options.calculateGenderFeats ~= 0 )
%     load(options.avgPosesGenderFile);
    load(options.fileINTERACTavgPoseGendFinal);
    ComputeGenderFeatures(options, avgPoseTasksGender);
    
    % Copy files as YR data (easier in later code)
    copyfile(options.fileINTERACTImgGendDataGT1, options.fileINTERACTImgGendDataYRD1);
    copyfile(options.fileINTERACTImgGendDataGT2, options.fileINTERACTImgGendDataYRD2);
    copyfile(options.fileINTERACTImgGendDataGT1, options.fileINTERACTImgGendDataYRBB1);
    copyfile(options.fileINTERACTImgGendDataGT2, options.fileINTERACTImgGendDataYRBB2);
end

if ( options.computeNoiseOfYR ~= 0 )
    numPeople = 2;
    scaledSigmaYRD  = ComputeYRSigma(options.fileINTERACTImgPoseDataGT1, options.poseDataYRDFile1, numPeople);  % 2.14 - D
    scaledSigmaYRBB = ComputeYRSigma(options.fileINTERACTImgPoseDataGT1, options.poseDataYRBBFile1, numPeople); % 1.705 - BB
end