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

function verbGroups = GroupingTasksByImgFile(options, tasks, verbsNum)
    
    numScenesPerHit = length(tasks(1).scenes);
    realImgFilenames = extractfield( reshape([tasks(:).scenes], length(tasks)*numScenesPerHit, 1), 'img');
    realImgFilenames = reshape(realImgFilenames, numScenesPerHit, length(tasks))';
    
    fid = fopen(options.realImgFile);
    colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', ';');
    fclose(fid);
    labelsNum = double(colsAsCells{1});
    imgFilenamesLabels = colsAsCells{2};
    
    verbsNumeric = double(colsAsCells{1});
    verbsName = colsAsCells{2};

    numVerbs = numel(verbsNum);
    verbGroups = cell(numVerbs, 1);
    numTasks = numel(tasks);

    for v = 1:numVerbs
        verb = verbsNum(v);
        verbFilenames = imgFilenamesLabels( verb == labelsNum );
        
        curStructs = [];
        for f = 1:length(verbFilenames)
            curStruct = [];
            curFilename = verbFilenames{f};
            curStruct.img = curFilename;
            
            idxs = find(strcmp(realImgFilenames, curFilename));
            
            if ( ~isempty(idxs) )
                [taskIdxs, sceneIdxs] = ind2sub(size(realImgFilenames), idxs);

                array = [];
                for s = 1:length(sceneIdxs)
                   array = [array; [taskIdxs(s), sceneIdxs(s)]]; 
                end
                curStruct.idxPairs = array;
                curStructs = [curStructs; curStruct];
            end
        end
        verbGroups{v} = curStructs;
    end
%     verbGroups = [verbGroups{:}]';
end