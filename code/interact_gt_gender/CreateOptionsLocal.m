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

    options.parseAMTFile      = 1;
    options.processGenderData = 1;
    
    
    %% Specifying the directory structure for the data

    options.inputFolder  = options.foldersLocal{options.idxINTERACTGend}{options.idxDataInput};
    options.outputFolder = options.foldersLocal{options.idxINTERACTGend}{options.idxDataOutput};
    
    %% Specifying the input file (experiment specific-might need to change!)
    options.genderResults = options.fileINTERACTAMTGend;
    options.avgPoseFile   = options.fileINTERACTavgPose;
    
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.AMTFile           = fullfile(options.outputFolder, 'parsed_amt_data.mat');
    options.avgPoseGenderFile = options.fileINTERACTavgPoseGend;
    
    % This is to strip awy the base URL in the results file
    options.imgBase = 'https://filebox.ece.vt.edu/~santol/cvmlp/pose_clipart/data/output/real_poses/full_exp_1/avgPoseNoHeadImgs/';   
%     options.imgPath = '../../data/output/real_poses/full_exp_1/avgPoseImgs/';
    
end