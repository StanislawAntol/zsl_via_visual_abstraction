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

function ClassificationCategoryAccuracyFeatureAblationPlot(options, parameters, accuraciesOverall, accuraciesAvgClass, datasetID)

featSetsToUse = parameters.featSets;
featTypeNames = parameters.featTypeNames';
biases = parameters.biasTrain;
probs  = parameters.probTest;
trainOnKs = parameters.trainOnKs;
detMethods = parameters.detMethods;
detMethodNames = parameters.detMethodsNames;

numFeatSets = length(featSetsToUse);
numBiases = length(biases);
numProbs = length(probs);
numTrainOnKs = length(trainOnKs);
numDetMethods = length(detMethods);

modelParams = parameters.Cs;
numModelParams = length(modelParams);

maxMPsOverall = zeros(numFeatSets, numBiases, numProbs, numDetMethods, numTrainOnKs);
maxMPsAvgClass = zeros(numFeatSets, numBiases, numProbs, numDetMethods, numTrainOnKs);

% realHumanAgreement = dlmread(options.humanAgreementRealDataFile);

randomChance = @(dims, x) (1./x).*ones(size(dims));
accuraciesAtFeatSet = zeros(numFeatSets, numDetMethods);

for nFt = 1:numFeatSets    
    for nDet = 1:numDetMethods
        temp = accuraciesAvgClass{nFt, 1, 1, nDet};
%         temp = accuraciesOverall{nFt, 1, 1, nDet};
        accuraciesAtFeatSet(nFt, nDet) = temp(1);
    end
end

set(0,'defaulttextinterpreter','none')
set(0,'defaulttextfontsize', 25);
set(0,'defaultaxesfontsize', 25)

% Plot everything
close all;
figure(1);
clf;
hold on;

for nFt = 1:numFeatSets
    featsToUse = featSetsToUse{nFt};
    featName = '';
    for j = 1:length(featsToUse)
        feat = featsToUse(j);
        
        featName = [featName, featTypeNames{feat}, '+'];
    end
    featName = featName(1:end-1);
    featNames{nFt} = featName;
end

featNames = ['Random', featNames];

% u = linspace(0, 100, numFeatSets+1);
u = 1:numFeatSets+1;

randomData = [1/60, zeros(1, length(accuraciesAtFeatSet(:,1)))];
plottedData = [ [0, accuraciesAtFeatSet(:, 1)']; ...
         [0, accuraciesAtFeatSet(:, 3)']; ...
         randomData];
     
     
bar([0, accuraciesAtFeatSet(:, 1)'], 'g');

bar([0, accuraciesAtFeatSet(:, 3)'], 'b');

bar(randomData, 'r');

% set(gca, 'LineWidth', 3);
% xlim([0 max(parameters.jointThreshold)+1]);
ylim([0 0.18]);
% xlabel('Features');
ylabel('Mean Class Raw Accuracies');
legend('PP', 'YR-BB', 'Random', 'Location', 'Northwest');

% % Make full screen
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
set(gcf, 'PaperPositionMode', 'auto')

set(gca,'XTick', u)
xticklabel_rotate(u, 90, featNames);

filenameStr = sprintf(options.zslCatFeatPlotFileFmt, ...
                datasetID, parameters.featsStr, parameters.detMethodsStr, biases(1), probs(1), 'all', parameters.trainOnKsStr, parameters.numRandKsStr);
filenameEPS = [filenameStr, '.eps'];
filenamePNG = [filenameStr, '.png'];
filenameCSV = [filenameStr, '.csv'];
print(gcf, '-depsc2', filenameEPS);

% Convert eps to png
eps2pngStr = sprintf('%s %s %s', options.convertEPS2PNGCommand, filenameEPS, filenamePNG);
system(eps2pngStr);

dlmwrite(filenameCSV, plottedData, ',');

end