% function createStandaloneFinalDataset(options, parameters)

addpath(fullfile('..', 'common'));

options = CreateOptionsGlobal();

load(options.fileINTERACTavgPoseFinal);
load(options.fileINTERACTavgPoseExprFinal);
load(options.fileINTERACTavgPoseGazeFinal);
load(options.fileINTERACTavgPoseGendFinal);

avgPoseTasksIDs = extractfield(avgPoseTasks, 'assignmentid')';
avgPoseTasksExprIDs = extractfield(avgPoseTasks, 'assignmentid')';
avgPoseTasksGazeIDs = extractfield(avgPoseTasks, 'assignmentid')';
avgPoseTasksGenderIDs = extractfield(avgPoseTasks, 'assignmentid')';

if ( (sum(strcmp(avgPoseTasksIDs, avgPoseTasksExprIDs)) == length(avgPoseTasks)) && ...
        (sum(strcmp(avgPoseTasksIDs, avgPoseTasksGazeIDs)) == length(avgPoseTasks)) && ...
        (sum(strcmp(avgPoseTasksIDs, avgPoseTasksGenderIDs)) == length(avgPoseTasks)) )
    
else
    fprintf('Error: IDs are inconsistent.\n');
end

fid = fopen(options.fileINTERACTImgDataInfoGT);
colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', ';');
fclose(fid);
labels = double(colsAsCells{1});
filenames = colsAsCells{2};

fid = fopen(options.fileINTERACTImgVerbLabelGT);
colsAsCells2 = textscan(fid, '%d%s', 'Delimiter', ';');
fclose(fid);
verbPhrasesID = colsAsCells2{1};
verbPhrasesVP = colsAsCells2{2};

parts = cellfun(@(x) strsplit(x, '.'), filenames, 'UniformOutput', 0);
filenamesWOExt = cellfun(@(x) x(1), parts, 'UniformOutput', 0);

if (~sum(strcmp(filenamesWOExt, avgPoseTasksIDs)) == length(filenamesWOExt) )
    fprintf('Warning: IDs are inconsistent with feature order.\n');
else
    standaloneDatasetFolder     = fullfile(options.foldersLocal{options.idxINTERACTCleanup}{options.idxDataOutput}, 'interact_stand-alone_dataset');
    standaloneDatasetImgsFolder = fullfile(standaloneDatasetFolder, 'imgs');
    standaloneDatasetHTMLFolder = fullfile(standaloneDatasetFolder, 'html');
    if ~exist(standaloneDatasetFolder, 'dir')
        mkdir(standaloneDatasetFolder);
        mkdir(standaloneDatasetImgsFolder);
        mkdir(standaloneDatasetHTMLFolder);
    end
    
    if ( 0 )
        labelsAndFilesFN = fullfile(standaloneDatasetFolder, 'interact_final_dataset_labels_and_images.txt');
        posesFN          = fullfile(standaloneDatasetFolder, 'interact_final_dataset_poses.txt');
        posesNIIFN       = fullfile(standaloneDatasetFolder, 'interact_final_dataset_poses_not_in_image.txt');
        exprsFN          = fullfile(standaloneDatasetFolder, 'interact_final_dataset_expressions.txt');
        gazesFN          = fullfile(standaloneDatasetFolder, 'interact_final_dataset_gazes.txt');
        gendsFN          = fullfile(standaloneDatasetFolder, 'interact_final_dataset_genders.txt');
        
        labelsAndFilesFID = fopen(labelsAndFilesFN, 'w');
        posesFID          = fopen(posesFN, 'w');
        posesOutFID       = fopen(posesNIIFN, 'w');
        exprsFID          = fopen(exprsFN, 'w');
        gazesFID          = fopen(gazesFN, 'w');
        gendsFID          = fopen(gendsFN, 'w');
        
        for idxFilename = 1:length(filenames)
            avgPoseTask = avgPoseTasks(idxFilename);
            avgPoses = avgPoseTask.poseTasks;
            poseData = [reshape(avgPoses(1).pose', 2*options.numParts, 1);
                reshape(avgPoses(2).pose', 2*options.numParts, 1)];
            poseDataStr = sprintf('%.6f;', poseData);
            outOfImgStr = sprintf('%d;', [avgPoses(1).occluded; avgPoses(2).occluded]);
            
            % The pose data follows this structure:
            % [Person1Data, Person2Data], where Person1Data should correspond to
            % Person 1 is the sentences (and likewise for Person2Data).
            % outOfImgData is 1 if the joint is not within the image boundary
            % poseData is just the pixel coordinates of the specific joint
            % The joints are always x1,y1,x2,y2,...
            % The joint body part order is: head, neck, left shoulder, left
            % elbow, left wrist, right shoulder, right elbow, right wrist,
            % right hip, right knee, right ankle, left hip, left knee, left
            % ankle
            
            imgFilename = filenames{idxFilename};
%             copyfile(fullfile(options.folderINTERACTImgs, imgFilename), fullfile(standaloneDatasetImgsFolder, imgFilename));
            
            fprintf(labelsAndFilesFID, '%02d;%s;Person 1 %s Person 2.\n', labels(idxFilename), imgFilename, verbPhrasesVP{(verbPhrasesID == labels(idxFilename))});
            fprintf(posesFID, '%s\n', poseDataStr(1:end-1));
            fprintf(posesOutFID, '%s\n', outOfImgStr(1:end-1));
            fprintf(exprsFID, '%d;%d\n', avgPoseTasksExpr(idxFilename).expr(1), avgPoseTasksExpr(idxFilename).expr(2));
            fprintf(gazesFID, '%d;%d\n', avgPoseTasksGaze(idxFilename).gaze(1), avgPoseTasksGaze(idxFilename).gaze(2));
            fprintf(gendsFID, '%d;%d\n', avgPoseTasksGender(idxFilename).gender(1), avgPoseTasksGender(idxFilename).gender(2));
            
        end
        
        fclose(labelsAndFilesFID);
        fclose(posesFID);
        fclose(exprsFID);
        fclose(gazesFID);
        fclose(gendsFID);
    end
    
    CreateHTMLPagesByVerb(filenames, labels, verbPhrasesID, verbPhrasesVP, ...
        standaloneDatasetFolder, ...
        strrep(standaloneDatasetHTMLFolder, [standaloneDatasetFolder, filesep], ''), ...
        strrep(standaloneDatasetImgsFolder, [standaloneDatasetFolder, filesep], ''));
    
    curDir = pwd;
    cd(standaloneDatasetFolder);
    %     zipCmdStr = sprintf('zip %s %s %s %s %s %s %s %s', ...
    %         'interact_stand-alone_dataset_annotations', ...
    %         strrep(labelsAndFilesFN, [standaloneDatasetFolder, filesep], ''), ...
    %         strrep(posesFN, [standaloneDatasetFolder, filesep], ''), ...
    %         strrep(posesNIIFN, [standaloneDatasetFolder, filesep], ''), ...
    %         strrep(exprsFN, [standaloneDatasetFolder, filesep], ''), ...
    %         strrep(gazesFN, [standaloneDatasetFolder, filesep], ''), ...
    %         strrep(gendsFN, [standaloneDatasetFolder, filesep], ''), ...
    %         'README.txt');
    %     system(zipCmdStr);
    %
    %     % Zip up image directory
    %     system(sprintf('zip -r %s ./imgs/', 'interact_stand-alone_dataset_images'));
    
    system(sprintf('zip -r %s interact_dataset_gallery.html ./html/', 'interact_stand-alone_dataset_images'));
    
    cd(curDir);

end

