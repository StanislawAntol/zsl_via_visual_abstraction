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

function verbPhraseAttrData = AverageSentenceAttributes(options, parameters, tasks)
    
    fid = fopen(options.verbFile);
    colsAsCells = textscan(fid, '%s', 'Delimiter', ';');
    fclose(fid);
    verbPhrases = colsAsCells{1}(2:end);
    
    % Sort verbPhrases to be in same order as clipart stuff
    
    fid = fopen(options.originalLabelingFile);
    colsAsCells = textscan(fid, '%d%s', 'Delimiter', ';');
    fclose(fid);
    origLabels = double(colsAsCells{1});
    origPhrases= colsAsCells{2};
    
    if ( sum(strcmp(verbPhrases, origPhrases)) == length(verbPhrases) )
%         fprintf('Verb Phrase Labels are the same.\n');
    else
        fprintf('Warning: Phrase Labels do not match clipart labels.\n');
    end
    
    
    numVerbPhrases = length(verbPhrases);
    verbPhraseAttrData(numVerbPhrases, 1) = struct('vp', [], ...
                        'contP1', [], 'gazeP1', [], 'gendP1', [], 'exprP1', [], ...
                        'contP2', [], 'gazeP2', [], 'gendP2', [], 'exprP2', []);
    for idxVerbPhrase = 1:length(verbPhrases)
        verbPhraseAttrData(idxVerbPhrase).vp = verbPhrases{idxVerbPhrase};
    end
    
    HITs = extractfield(tasks, 'hitid')';
    [uniqueHITs, UHA, UHC] = unique(HITs);
    
    for idxHIT = 1:length(UHA)
        
        curHITLogIdxs = UHC == idxHIT;
        curTasks = tasks(curHITLogIdxs);
        
        sentCells = extractfield(curTasks, 'sentences')';
        
        sentStruct = sentCells{1};
        sentences = extractfield(sentStruct, 'sent')';
        if ( strcmp( sentences{1}(1), '1') )
            p1 = 1;
        else
            p1 = 0;
        end
        
        for idxSent = 1:length(sentences)
            curVerbPhrase = sentences{idxSent};
            curVerbPhrase = curVerbPhrase(3:end-2);
            idxVerbPhraseData = find(strcmp(verbPhrases, curVerbPhrase));
            if ( p1 ~= 0 )
                conts = cell2mat(cellfun(@(x) x(idxSent).A_cont', sentCells, 'UniformOutput', 0));
                gazes = cell2mat(cellfun(@(x) x(idxSent).A_gaze, sentCells, 'UniformOutput', 0));
                gends = cell2mat(cellfun(@(x) x(idxSent).A_gend, sentCells, 'UniformOutput', 0));
                exprs = cell2mat(cellfun(@(x) x(idxSent).A_expr, sentCells, 'UniformOutput', 0));
            else
                conts = cell2mat(cellfun(@(x) x(idxSent).B_cont', sentCells, 'UniformOutput', 0));
                gazes = cell2mat(cellfun(@(x) x(idxSent).B_gaze, sentCells, 'UniformOutput', 0));
                gends = cell2mat(cellfun(@(x) x(idxSent).B_gend, sentCells, 'UniformOutput', 0));
                exprs = cell2mat(cellfun(@(x) x(idxSent).B_expr, sentCells, 'UniformOutput', 0));
            end

            [avgCont, avgGaze, avgGend, avgExpr] = ComputeResponseAverages(options, parameters, conts, gazes, gends, exprs);
            
            if ( p1 ~= 0 )
                verbPhraseAttrData(idxVerbPhraseData).contP1 = avgCont;
                verbPhraseAttrData(idxVerbPhraseData).gazeP1 = avgGaze;
                verbPhraseAttrData(idxVerbPhraseData).gendP1 = avgGend;
                verbPhraseAttrData(idxVerbPhraseData).exprP1 = avgExpr;
            else
                verbPhraseAttrData(idxVerbPhraseData).contP2 = avgCont;
                verbPhraseAttrData(idxVerbPhraseData).gazeP2 = avgGaze;
                verbPhraseAttrData(idxVerbPhraseData).gendP2 = avgGend;
                verbPhraseAttrData(idxVerbPhraseData).exprP2 = avgExpr;
            end
        end
         
    end

end