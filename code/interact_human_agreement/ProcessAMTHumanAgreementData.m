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

function ProcessAMTHumanAgreementData(options, parameters, imgFilenames, imgLabels)

seed = RandStream('mt19937ar','Seed', parameters.seedVal);

numFilenames = length(imgFilenames);
numVerbs = max(unique(imgLabels));

if ( options.readParsedData ~= 0 )
    origData = readtext(options.readFile, ',', '', '""', 'textual-empty2zero');
    save(options.saveNameParsed, 'origData');
else
    load(options.saveNameParsed);
end

if ( options.processHumanAgreementData ~= 0 )
    
    numTasksPerHit = 10;
    numTasksTotal = numFilenames;
    numHits = ceil(numTasksTotal/numTasksPerHit);
        
    %     data = origData(1:3, :);
    data = origData;
    titles = data(1,:);
    titles = strrep(titles,'"','');
    data(1,:) = [];
    startInput = find(strcmp(titles, 'Input.im_1'));
    urls = data(:, startInput:startInput+numTasksPerHit-1);
    urls = strrep(urls,'"','');
    urls = strrep(urls, options.prename, '');
    startOutput = find(strcmp(titles, 'Answer.label_1'));
    choices = data(:,startOutput:startOutput+numTasksPerHit-1);
    choices = strrep(choices, '"', '');
    choices = choices(:,[1 3 4 5 6 7 8 9 10 2]);
    choices = cellfun(@BreakBarList,choices,'UniformOutput',false);
    clear data
    
    if ( options.isReal == 0 )
        choices = cleanupClipartMistakes(urls, choices);
    end
    
    invalidGuesses = true( numFilenames, numTasksPerHit );
    randGuesses    = zeros( numFilenames, numTasksPerHit );
    bestGuesses    = zeros( numFilenames, numTasksPerHit );
    
    for i = 1:numFilenames
        
        correctIdx = strcmp(urls, imgFilenames{i});
        
        [taskIdxs, answerIdxs] = find(correctIdx==1);
        if ( isempty(taskIdxs) )
            fprintf('Filename not found in URLs.\n');
        else
            for j = 1:length(taskIdxs)
                
                userChoices = choices{taskIdxs(j),answerIdxs(j)};
                
                if ( isempty(userChoices) )
                    randGuess = randperm(seed, numVerbs, 1); % RANDOMLY SELECT LABEL IF NO CHOICE
                    invalidGuess   = true(1);
                else
                    randIdx   = randperm(seed, length(userChoices));
                    randGuess = userChoices(randIdx(1));
                    invalidGuess   = false(1);
                end
                
                correctIdx = find( userChoices == imgLabels(i) );
                if ( isempty(correctIdx) )
                    bestGuess = randGuess;
                else
                    bestGuess = userChoices(correctIdx);
                end
                
                invalidGuesses(i, j) = invalidGuess;
                randGuesses(i, j)    = randGuess;
                bestGuesses(i, j)    = bestGuess;
            end
        end
    end
    
    save(options.saveNameFilteredData, 'imgFilenames', 'imgLabels', 'invalidGuesses', 'randGuesses', 'bestGuesses');
else
    load(options.saveNameFilteredData);
end

end