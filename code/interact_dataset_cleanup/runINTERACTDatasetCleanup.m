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

% function INTERACTDatasetCleanup()

addpath(fullfile('..', 'common'));
addpath(fullfile('..', 'interact_human_agreement'));
addpath(fullfile('..', 'common'));

options = CreateOptionsGlobal();

addpath(options.folders3rdParty{options.idxGIST})

load(options.fileINTERACTavgPose);
load(options.fileINTERACTavgPoseExpr);
load(options.fileINTERACTavgPoseGaze);
load(options.fileINTERACTavgPoseGend);

copyfile(options.fileInitDatasetVerbs, options.fileINTERACTImgVerbLabelGT);
infoData = readtext(options.fileInitDatasetInfo, ';');
imgLabels    = str2double(infoData(:, 1));
imgFilenames = infoData(:, 2);

NE2Anns = extractfield(avgPoseTasksExpr, 'NE2Count')';
badAnns = extractfield(avgPoseTasksGaze, 'badAnnTotal')';

parameters.NE2Threshold = 3;
parameters.badAnnThreshold = 1;

whichUserInit = load(options.fileWorkerGroupings);

imgConditions = (~(( (whichUserInit>3) | (whichUserInit<1) ) )...
    & (NE2Anns <= parameters.NE2Threshold) & ( badAnns <= parameters.badAnnThreshold ) );
intIdxs = find( imgConditions );
goodIdxsLogical = RemoveDuplicates(options, imgFilenames, imgLabels, whichUserInit, intIdxs);

idxsFinal = find(goodIdxsLogical);
% Consider moving to 1149 (not 1175), it's proper location...
idxFixedOrder = [1:1149, length(idxsFinal), 1150:length(idxsFinal)-1]; % Fixes it because of forgetting one for average poses 
idxsFinal = idxsFinal(idxFixedOrder);

B = infoData(idxsFinal, :);
cell2csv(options.fileINTERACTImgDataInfoGT, B, ';', '%02d');

load(options.fileINTERACTImgHumanAgr) % Loads

consistFilenames = sum(strcmp(imgFilenames, imgFilenames))/length(imgLabels);
consistLabels = sum(imgLabels == imgLabels)/length(imgLabels);

if ~( (consistFilenames == 1) && (consistLabels == 1) )
    fprintf('Warning: Human agreement data does not align with pose data\n');    
end

avgPoseTasks = avgPoseTasks(idxsFinal);
avgPoseTasksExpr = avgPoseTasksExpr(idxsFinal);
avgPoseTasksGaze = avgPoseTasksGaze(idxsFinal);
avgPoseTasksGender = avgPoseTasksGender(idxsFinal);

% humanAgreeDataRealFinal = allGuesses(idxsFinal, :);

CalculateAndSortHumanAgreementAccuracies(options, parameters, imgFilenames(idxsFinal), imgLabels(idxsFinal), bestGuesses(idxsFinal, :), invalidGuesses(idxsFinal, :), randGuesses(idxsFinal, :));

% imgAgreement = zeros(length(realGTImgLabelsFinal), 1);
% for i = 1:length(realGTImgLabelsFinal)
%     labels = humanAgreeDataRealFinal{i, 1};
%     labelCounts = humanAgreeDataRealFinal{i, 2};
%     countIdx = find(labels == realGTImgLabelsFinal(i));
%     if isempty(countIdx)
%         imgAgreement(i) = 0.0;
%     else
%         imgAgreement(i) = labelCounts(countIdx)/10;
%     end
%     
% end

save(options.fileINTERACTavgPoseFinal,       'avgPoseTasks'); 
save(options.fileINTERACTavgPoseExprFinal,   'avgPoseTasksExpr');
save(options.fileINTERACTavgPoseGazeFinal,   'avgPoseTasksGaze');
save(options.fileINTERACTavgPoseGendFinal,   'avgPoseTasksGender');
% save(options.humanAgreeDataRealFinal, 'humanAgreeDataRealFinal');