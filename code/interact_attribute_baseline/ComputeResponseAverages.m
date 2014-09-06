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

function [avgCont, avgGaze, avgGend, avgExpr] = ComputeResponseAverages(options, parameters, conts, gazes, gends, exprs)
    
        if ( parameters.responseMethod == 1 ) % randomness in mode
        [avgContR, avgGazeR, avgGendR, avgExprR] = ComputeResponseRandomModes(options, parameters, conts, gazes, gends, exprs);
        avgCont = avgContR;
        avgGaze = avgGazeR;
        avgGend = avgGendR;
        avgExpr = avgExprR;
    elseif ( parameters.responseMethod == 2 ) % mode with lowest tie-breaker
        [avgContM, avgGazeM, avgGendM, avgExprM] = ComputeResponseModes(options, parameters, conts, gazes, gends, exprs);
        avgCont = avgContM;
        avgGaze = avgGazeM;
        avgGend = avgGendM;
        avgExpr = avgExprM;
    else
        [avgContT, avgGazeT, avgGendT, avgExprT] = ComputeResponseThreshold(options, parameters, conts, gazes, gends, exprs);
        avgCont = avgContT;
        avgGaze = avgGazeT;
        avgGend = avgGendT;
        avgExpr = avgExprT;
        end
end

function [avgCont, avgGaze, avgGend, avgExpr] = ComputeResponseModes(options, parameters, conts, gazes, gends, exprs)    
    
    avgCont = mode(conts, 1)';
    avgGaze = mode(gazes);
    avgGend = mode(gends);
    avgExpr = mode(exprs);
    
    avgGend = avgGend == options.genderList;
    avgExpr = avgExpr == options.exprList;
    
end

function [avgCont, avgGaze, avgGend, avgExpr] = ComputeResponseRandomModes(options, parameters, conts, gazes, gends, exprs)

    rStream = RandStream('mt19937ar','Seed', parameters.seedVal);
    
    [~, ~, Ccont] = mode(conts, 1);
    [~, ~, Cgaze] = mode(gazes);
    [~, ~, Cgend] = mode(gends);
    [~, ~, Cexpr] = mode(exprs);
    Cgaze = Cgaze{1};
    Cgend = Cgend{1};
    Cexpr = Cexpr{1};
    numCgaze = length(Cgaze);
    numCgend = length(Cgend);
    numCexpr = length(Cexpr);

    avgCont = zeros(length(Ccont), 1);
    numCont = cellfun(@(x) length(x), Ccont);
    singleContLogIdxs = numCont == 1;
    avgCont(singleContLogIdxs) = cell2mat(Ccont(singleContLogIdxs));
    avgCont(~singleContLogIdxs) = cellfun(@(x) x(randperm(rStream, length(x), 1)), Ccont(~singleContLogIdxs));

    if ( numCgaze > 1 )
        avgGaze = Cgaze(randperm(rStream, numCgaze, 1));
%         fprintf('Multiple gaze modes.\n ');
    else
        avgGaze = Cgaze;
    end
    %             fprintf('gaze: %d\n', avgGaze);

    if ( numCgend > 1 )
        avgGend = Cgend(randperm(rStream, numCgend, 1));
%         fprintf('Multiple gender modes.\n ');
    else
        avgGend = Cgend;
    end
    avgGend = avgGend == options.genderList;
    %             fprintf('gend: %d\n', avgGend);

    if ( numCexpr > 1 )
        avgExpr = Cexpr(randperm(rStream, numCexpr, 1));
%         fprintf('Multiple expression modes.\n ');
    else
        avgExpr = Cexpr;
    end
    
    avgExpr = avgExpr == options.exprList;
    %             fprintf('expr: %d\n', avgExpr);
end

function [avgCont, avgGaze, avgGend, avgExpr] = ComputeResponseThreshold(options, parameters, conts, gazes, gends, exprs)

    rStream = RandStream('mt19937ar','Seed', parameters.seedVal);
    
    meanConts = mean(conts, 1)';
    meanGazes = mean(gazes);
    meanGends = mean(repmat(gends, 1, length(options.genderList)) == repmat(options.genderList, length(gends), 1), 1);
    meanExprs = mean(repmat(exprs, 1, length(options.exprList)) == repmat(options.exprList, length(exprs), 1), 1);
    
    avgCont = meanConts > parameters.responseThreshold;
    avgGaze = meanGazes > parameters.responseThreshold;
    avgGend = meanGends > parameters.responseThreshold;
    avgExpr = meanExprs > parameters.responseThreshold;
    
end