% function createIllustrationCategoryDataset

[verbsNum, verbsName] = GetINTERACTVerbTuples(options);

%% Create file with the numeric label to verb mapping
labelData = cell(numel(verbsNum), 2);
for i = 1:numel(verbsNum)
    labelData{i, 1} = verbsNum(i);
    labelData{i, 2} = verbsName{i};
end


standaloneDatasetFolder     = fullfile(options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataOutput}, 'interact_illustration_category_dataset');
standaloneDatasetImgsFolder = fullfile(standaloneDatasetFolder, 'imgs');
standaloneDatasetHTMLFolder = fullfile(standaloneDatasetFolder, 'html');
if ~exist(standaloneDatasetFolder, 'dir')
    mkdir(standaloneDatasetFolder);
    mkdir(standaloneDatasetImgsFolder);
    mkdir(standaloneDatasetHTMLFolder);
end

fileWrite = 0;

if ( 1 )
    labelsAndFilesFN = fullfile(standaloneDatasetFolder, 'interact_illustration_category_dataset_labels_and_images.txt');
    posesFN          = fullfile(standaloneDatasetFolder, 'interact_illustration_category_dataset_poses.txt');
    exprsFN          = fullfile(standaloneDatasetFolder, 'interact_illustration_category_dataset_expressions.txt');
    gazesFN          = fullfile(standaloneDatasetFolder, 'interact_illustration_category_dataset_gazes.txt');
    gendsFN          = fullfile(standaloneDatasetFolder, 'interact_illustration_category_dataset_genders.txt');
    
    if ( fileWrite )
        labelsAndFilesFID = fopen(labelsAndFilesFN, 'w');
        posesFID          = fopen(posesFN, 'w');
        exprsFID          = fopen(exprsFN, 'w');
        gazesFID          = fopen(gazesFN, 'w');
        gendsFID          = fopen(gendsFN, 'w');
    end
    numTasks = length(tasks);

    filenames = {};
    labels = [];
    %% Loop through all tasks and every scene for each task
    for i = 1:numTasks
        task = tasks(i);
        assignmentID = task.assignmentid;
        
        for j = 1:numel(task.scenes)
            
            scene = task.scenes(j);
                
            zeroPadNum = sprintf(['%0', num2str(options.renderImgNameZeroPad),...
                'd'], j);
            imgName = [assignmentID, '_', zeroPadNum, '.', options.renderImgExt];
            filenames = [filenames; imgName];
            sentence = scene.sent;
            verb = sentence(10:end-10);
            verbLabel = find( strcmp(verbsName, verb) );
            labels = [labels; verbLabel];
            
            poseData = ConvertClipartToRealJointDataTwoPerson(options, scene);
            poseDataStr = sprintf('%.6f;', poseData);
            
            if ( options.clipartType == 1 )
                curP1 = scene.p1;
            else
                curP1 = 1; % Just have arbitrary order
            end
            
            if ( curP1 == 1 ) % Person 1 (first part of sentence) is Person A
                p1Expr = scene.pAExp;
                p2Expr = scene.pBExp;
                
                p1Gaze = scene.pAFlip;
                p2Gaze = scene.pBFlip;
                
                p1Gend = scene.pAGend;
                p2Gend = scene.pBGend;

            elseif ( curP1 == 2 ) % Person 1 (first part of sentence) is Person B
                p1Expr = scene.pBExp;
                p2Expr = scene.pAExp;
                
                p1Gaze = scene.pBFlip;
                p2Gaze = scene.pAFlip;
                
                p1Gend = scene.pBGend;
                p2Gend = scene.pAGend;
            end

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

            if ( fileWrite )
%                 copyfile(fullfile(options.foldersLocal{options.idxINTERACTClipCatColl}{options.idxDataOutput}, 'rendered_illustrations', imgName), fullfile(standaloneDatasetImgsFolder, imgName));
                
                fprintf(labelsAndFilesFID, '%02d;%s;%s\n', verbLabel, imgName, sentence);
                fprintf(posesFID, '%s\n', poseDataStr(1:end-1));
                fprintf(exprsFID, '%d;%d\n', p1Expr, p2Expr);
                fprintf(gazesFID, '%d;%d\n', p1Gaze, p2Gaze);
                fprintf(gendsFID, '%d;%d\n', p1Gend, p2Gend);
            end
        end
    end
    
    if ( fileWrite )
        fclose(labelsAndFilesFID);
        fclose(posesFID);
        fclose(exprsFID);
        fclose(gazesFID);
        fclose(gendsFID);
    end
end

CreateHTMLPagesByVerb(filenames, labels, verbsNum, verbsName, ...
    standaloneDatasetFolder, ...
    strrep(standaloneDatasetHTMLFolder, [standaloneDatasetFolder, filesep], ''), ...
    strrep(standaloneDatasetImgsFolder, [standaloneDatasetFolder, filesep], ''));

curDir = pwd;
cd(standaloneDatasetFolder);
zipCmdStr = sprintf('zip %s %s %s %s %s %s %s %s', ...
    'interact_illustration_category_dataset_annotations', ...
    strrep(labelsAndFilesFN, [standaloneDatasetFolder, filesep], ''), ...
    strrep(posesFN, [standaloneDatasetFolder, filesep], ''), ...
    strrep(exprsFN, [standaloneDatasetFolder, filesep], ''), ...
    strrep(gazesFN, [standaloneDatasetFolder, filesep], ''), ...
    strrep(gendsFN, [standaloneDatasetFolder, filesep], ''), ...
    'README_interact_illustration_category_dataset.txt');
system(zipCmdStr);

% Zip up image directory
system(sprintf('zip -r %s ./imgs/', 'interact_illustration_category_dataset_images'));

system(sprintf('zip -r %s interact_dataset_gallery.html ./html/', 'interact_il_dataset_images'));

cd(curDir);