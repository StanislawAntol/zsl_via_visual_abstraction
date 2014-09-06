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

function accuracy = CalculateAndSortHumanAgreementAccuracies(options, parameters, imgFilenames, imgLabels, bestGuesses, invalidGuesses, randGuesses)

labelsClassifier = imgLabels;
filenamesClassifier = imgFilenames;

seed = RandStream('mt19937ar','Seed', 651);

randAccuracyMajVoteWOMissing = zeros(size(bestGuesses, 1), 1);
randAccuracyMeanWOMissing = zeros(size(bestGuesses, 1), 1);
randAccuracyAtLeastOneWOMissing = zeros(size(bestGuesses, 1), 1);

bestAccuracyMajVoteWOMissing = zeros(size(bestGuesses, 1), 1);
bestAccuracyMeanWOMissing = zeros(size(bestGuesses, 1), 1);
bestAccuracyAtLeastOneWOMissing = zeros(size(bestGuesses, 1), 1);

for i = 1:size(invalidGuesses, 1)
    validIdxs = ~invalidGuesses(i, :);
    numValidIdxs = sum(validIdxs);
    if ( numValidIdxs > 0 )
        randGuessSet = randGuesses(i, validIdxs);
        [~, ~, randC] = mode(randGuessSet, 2);
        randPermC = randC{randperm(seed, length(randC))};
        randMajVoteGuess = randPermC(1);
        randAccuracyMajVoteWOMissing(i) = randMajVoteGuess == imgLabels(i);
        
        randCorrect = randGuessSet == imgLabels(i);
        randAccuracyMeanWOMissing(i) = sum(randCorrect)/numValidIdxs;
        randAccuracyAtLeastOneWOMissing(i) = sum(randCorrect, 2) > 0;
        
        bestGuessSet = bestGuesses(i, validIdxs);
        [~, ~, bestC] = mode(bestGuessSet, 2);
        bestPermC = bestC{randperm(seed, length(bestC))};
        bestMajVoteGuess = bestPermC(1);
        bestAccuracyMajVoteWOMissing(i) = bestMajVoteGuess == imgLabels(i);
        
        bestCorrect = bestGuessSet == imgLabels(i);
        bestAccuracyMeanWOMissing(i) = sum(bestCorrect)/numValidIdxs;
        bestAccuracyAtLeastOneWOMissing(i) = sum(bestCorrect, 2) > 0;
    end
end

badFilenameIdxs = sum(invalidGuesses, 2) == 10;

randAccuracyMajVoteWOMissing(badFilenameIdxs) = [];
randAccuracyMeanWOMissing(badFilenameIdxs) = [];
randAccuracyAtLeastOneWOMissing(badFilenameIdxs) = [];

bestAccuracyMajVoteWOMissing(badFilenameIdxs) = [];
bestAccuracyMeanWOMissing(badFilenameIdxs) = [];
bestAccuracyAtLeastOneWOMissing(badFilenameIdxs) = [];

randAccuracyAtLeastOneWOMissingFinal = mean(randAccuracyAtLeastOneWOMissing);
randAccuracyMajVoteWOMissingFinal = mean(randAccuracyMajVoteWOMissing);
randAccuracyMeanWOMissingFinal = mean(randAccuracyMeanWOMissing);

bestAccuracyAtLeastOneWOMissingFinal = mean(bestAccuracyAtLeastOneWOMissing);
bestAccuracyMajVoteWOMissingFinal = mean(bestAccuracyMajVoteWOMissing);
bestAccuracyMeanWOMissingFinal = mean(bestAccuracyMeanWOMissing);

randAccuraciesWOMissing = 100*[randAccuracyAtLeastOneWOMissingFinal, randAccuracyMajVoteWOMissingFinal, randAccuracyMeanWOMissingFinal]
bestAccuraciesWOMissing = 100*[bestAccuracyAtLeastOneWOMissingFinal, bestAccuracyMajVoteWOMissingFinal, bestAccuracyMeanWOMissingFinal]

GTMatrix = repmat(imgLabels, 1, size(bestGuesses, 2));
[~, ~, randC] = mode(randGuesses, 2);
randPermC = cellfun(@(element) element(randperm(seed, length(element))), randC, 'UniformOutput', false);
randGuessMajVote = cellfun(@(element) element(1), randPermC);
[~, ~, randC] = mode(bestGuesses, 2);
bestPermC = cellfun(@(element) element(randperm(seed, length(element))), randC, 'UniformOutput', false);
bestGuessMajVote = cellfun(@(element) element(1), bestPermC);

randCorrect = GTMatrix == randGuesses;
randCorrectMajVote = imgLabels == randGuessMajVote;
randCorrectAtLeastOne = sum(randCorrect, 2) > 0;
bestCorrect = GTMatrix == bestGuesses;
bestCorrectMajVote = imgLabels == bestGuessMajVote;
bestCorrectAtLeastOne = sum(bestCorrect, 2) > 0;

randCorrectMean = mean(randCorrect, 2);
bestCorrectMean = mean(bestCorrect, 2);

randAccuracyMean = mean(randCorrectMean);
randAccuracyMajVote = mean(randCorrectMajVote);
randAccuracyAtLeastOne = mean(randCorrectAtLeastOne);
bestAccuracyMean = mean(bestCorrectMean);
bestAccuracyMajVote = mean(bestCorrectMajVote);
bestAccuracyAtLeastOne = mean(bestCorrectAtLeastOne);

randAccuracies = 100*[randAccuracyAtLeastOne, randAccuracyMajVote, randAccuracyMean]

bestAccuracies = 100*[bestAccuracyAtLeastOne, bestAccuracyMajVote, bestAccuracyMean]

numPermutations = 10000;

accuracy = 0.0;
for k = 1:numPermutations
    randIdxs = randperm(seed, size(bestCorrect, 2));
    correct = bestCorrect(:, randIdxs);
    acc = cumsum(correct, 2) > 0;
    accuracy = accuracy + 100*mean(acc);
end
accuracy = accuracy/numPermutations;
% keepFilename = [base, 'HumanAgreementCurve.txt'];
% keepFile = fullfile(outputDataDir, keepFilename);
% dlmwrite(keepFile, accuracy);

% plot(accuracy)
% xlim([0, 60]);
% ylim([0, 100]);

% numUsers = length(unique(whichUser));
% 
% intIdxs = 1:K;
% verbs = unique(imgLabels);
% numVerbs = length(verbs);
% keepFinalClassifier = zeros(numel(filenamesClassifier), 1);
% 
% numImgsByUser = zeros(numUsers, numVerbs);
% 
% for u = 1:numUsers
%     
%     groupsByVerb = cell(numVerbs, 2);
%     groupsByVerbSorted = cell(numVerbs, 2);
%     groupsByVerbSortedTopK = cell(numVerbs, 2);
%     
%     keepClassifier = zeros(size(labelsClassifier, 1), 1);
%     
%     % imgLabelsWOMissing = imgLabels;
%     % imgLabelsWOMissing(badFilenameIdxs) = [];
%     % for i = 1:numVerbs
%     %     verb = verbs(i);
%     %     verbIdxs = find( imgLabelsWOMissing == verb );
%     %     fprintf('Number indices for verb %d is %d\n', i, length(verbIdxs));
%     %     groupsByVerb{i, 1} = verbIdxs;
%     %     groupsByVerb{i, 2} = bestAccuracyMeanWOMissing(verbIdxs);
%     % end
%     
%     for i = 1:numVerbs
%         verb = verbs(i);
%         verbIdxs = find( (imgLabels == verb) & ( whichUser == u ) );
% %         fprintf('Number indices for verb %d is %d.\n', i, length(verbIdxs));
%         groupsByVerb{i, 1} = verbIdxs;
%         groupsByVerb{i, 2} = bestCorrectMean(verbIdxs);
%     end
%     
%     for i = 1:numVerbs
%         group = groupsByVerb{i, 1};
%         [sortedMeanAcc, sortedIdxs] = sort(groupsByVerb{i, 2}, 'descend');
%         groupsByVerbSorted{i, 1} = group(sortedIdxs);
%         groupsByVerbSorted{i, 2} = sortedMeanAcc;
%     end
%     
%     for i = 1:numVerbs
%         group = groupsByVerbSorted{i, 1};
%         maxGroup = length(group);
%         numImgsByUser(u, i) = maxGroup;
%         if ( maxGroup < K )
%             maxIdxs = intIdxs(1:maxGroup);
%             fprintf('User %d, Verb %d only has %d images.\n', u, i, maxGroup);
%         else
%             maxIdxs = intIdxs;
%         end
%         groupTopK = group(maxIdxs);
%         filenamesTopK = imgFilenames(groupTopK);
%         groupsByVerbSortedTopK{i, 1} = filenamesTopK;
%         groupsByVerbSortedTopK{i, 2} = groupTopK;
%     end
%     
%     for i = 1:numVerbs
%         
%         filenamesTopK = groupsByVerbSortedTopK{i, 1};
%         idxsTopK = groupsByVerbSortedTopK{i, 2};
%         for j = 1:size(filenamesTopK, 1)
%             
%             filename = filenamesTopK{j, 1};
%             logicalIdxs = strcmp(filenamesClassifier, filename);
%             keepClassifier(logicalIdxs) = intIdxs(j);
%             
%         end
%     end
%    
%     keepFinalClassifier = keepFinalClassifier + keepClassifier.*(whichUser == u);
% end
% 
% totalsByUser = sum( numImgsByUser, 2 );
% minByVerb = min( numImgsByUser, [], 1);
% minVerb = min(minByVerb)
% 
% keepFilename = sprintf('%sTop%03dImages.txt', base, K);
% keepFile = fullfile(outputDataDir, keepFilename);
% dlmwrite(keepFile, keepFinalClassifier);

end