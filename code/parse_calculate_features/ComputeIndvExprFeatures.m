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

function ComputeIndvExprFeatures(options, avgPoseTasksExpr)

    exprList = options.exprList;
    numExprs = numel(exprList);
        
    exprFeat1 = zeros(numel(avgPoseTasksExpr), numExprs);
    
    for i = 1:numel(avgPoseTasksExpr)
        
        avgPoseTask = avgPoseTasksExpr(i);

        exprs = avgPoseTask.expr;

        exprBinary1 = exprs == exprList;
        
        exprFeat1(i, :) = exprBinary1;
        
    end

    dlmwrite(options.filePARSEImgExprDataGT1, exprFeat1, ';');

end