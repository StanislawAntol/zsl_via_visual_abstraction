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

function SavingPARSEPoses(options, imgs, poses)

    infoFID  = fopen(options.filePARSEImgDataInfoGT , 'w');
    labelFID = fopen(options.filePARSEImgVerbLabelGT, 'w');
    
    [verbLabels, verbNames] = GetPARSEVerbs(options);

%     %% Create file with the numeric label to verb mapping
    for i = 1:numel(verbLabels)
        fprintf(labelFID, '%03d;%s\n', verbLabels(i), verbNames{i});
    end

    imgVerbs = GetPARSECategorization(options);
    
    allPoseData = zeros(numel(poses), 2*options.numParts);
    
    for i = 1:numel(poses)
        img = imgs{i};
        verb = imgVerbs(i);
        verbIdx = find( verb == verbLabels );
        verbLabel = verbLabels(verbIdx);
        sentence = verbNames{verbIdx};
        fprintf(infoFID, '%03d;%s;%s\n', verbLabel, img, sentence);

        poseData = [reshape(poses{i}', 2*options.numParts, 1);];

        allPoseData(i, :) = poseData;
    end

    dlmwrite(options.filePARSEImgPoseDataGT1, allPoseData, ';');        
    fclose(infoFID);
    fclose(labelFID);

end