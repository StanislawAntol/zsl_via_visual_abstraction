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

    options.initYR              = 1;
    options.runYRD              = 1;
    options.runExtractPosesYRD  = 1;
    options.runYRBB             = 1;
    options.runExtractPosesYRBB = 1;
    
    options.YRPosePath = fullfile(options.folders3rdParty{options.idxYRPose}, '..', 'code-basic'); 
    options.usePARSEModel = 1; % else use upper-body BUFFY
    options.poseTasksFile = options.fileINTERACTavgPoseFinal;
    options.imgDir = options.folderINTERACTImgs;
    
    options.colorset = {'g','g','y','m','m','m','m','y','y','y','r','r','r','r','y','c','c','c','c','y','y','y','b','b','b','b'};
    
    %% Specifying the directory structure for the data
    options.data1FolderName     = 'YRDBoxes';
    options.data2FolderName     = 'YRBBBoxes';
    
    options.inputFolder       = options.foldersLocal{options.idxINTERACTYRPose}{options.idxDataInput};
    options.outputFolder      = options.foldersLocal{options.idxINTERACTYRPose}{options.idxDataOutput};
    options.data1Folder       = fullfile(options.outputFolder, options.data1FolderName);
    options.data2Folder       = fullfile(options.outputFolder, options.data2FolderName);
    
    %% Make sure all the necessary folders are in place
    folders = { ...
        options.data1Folder; ...
        options.data2Folder; ...
        };
    
    for f = 1:numel(folders)
        curFolder = folders{f};
        
        if ~exist(curFolder, 'dir')
            mkdir(curFolder);
        end
    end
    
    options.infoDataDFile  = options.fileINTERACTImgPoseDataInfoYRD;
    options.poseDataDFile1 = options.fileINTERACTImgPoseDataYRD1;
    options.poseDataDFile2 = options.fileINTERACTImgPoseDataYRD2;

    options.infoDataBBFile  = options.fileINTERACTImgPoseDataInfoYRBB;
    options.poseDataBBFile1 = options.fileINTERACTImgPoseDataYRBB1;
    options.poseDataBBFile2 = options.fileINTERACTImgPoseDataYRBB2;
    
end