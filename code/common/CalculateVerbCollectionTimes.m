%CALCULATEVERBCOLLECTIONTIMES Processes the task struct to calculate work
%  duration by the users for different verbs.
%
%  [] = CalculateVerbCollectionTimes(options, tasks) 
%
%  INPUT
%    -options:      The options struct created by CreateOptionsGlobal() or
%                   similar that contains all higher level project data.
%    -tasks:        The task struct that contains all data from the AMT
%                   file for the image collection process.
%
%  OUTPUT
%    N/A - Just displays some information.
%
%  Author: Stanislaw Antol (santol@vt.edu)                 Date: 2014-08-18

function CalculateVerbCollectionTimes(options, tasks)

    verbs = GetINTERACTVerbs(options);
    verbGroups = GroupingTasksByVerb(tasks, verbs);

    timeFormat = 'ddd mmm dd HH:MM:SS';

    acceptTimesStr = extractfield(tasks, 'accepttime')';
    acceptTimes = datenum(acceptTimesStr, timeFormat);

    submitTimesStr = extractfield(tasks, 'submittime')';
    submitTimes = datenum(submitTimesStr, timeFormat);

    durationsInDays = submitTimes - acceptTimes;
    durationsInMinutes = durationsInDays*(24*60);
    durationsInSeconds = durationsInDays*(24*60*60);

    meanVerbTimesInMinutes = zeros(numel(verbs), 1);

    for i = 1:numel(verbs)
        verb = verbs{i};
        verbIdxs = verbGroups{i};
        verbTasks = tasks(verbIdxs);
        meanVerbTimesInMinutes(i) = mean(durationsInMinutes(verbIdxs));
    end

    [sortedMeanVerbTimesInMinutes, sortedIdxs] = sort(meanVerbTimesInMinutes, 'descend');

    topVerbs = 60;

    A = sortedMeanVerbTimesInMinutes(1:topVerbs);
    B = verbs(sortedIdxs(1:topVerbs));

    for i = 1:length(A)
       fprintf('Verb: %s\n\tMean duration (min): %f\n', B{i}, A(i)); 
    end
    fprintf('Overall mean duration (min): %f\n', mean(A));
end