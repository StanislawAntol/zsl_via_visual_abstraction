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

function ComputeExprFeatures(options, avgPoseTasksExpr)

    exprList = options.exprList;
    numExprs = numel(exprList);
        
    exprFeat1 = zeros(numel(avgPoseTasksExpr), 2*numExprs);
    exprFeat2 = zeros(numel(avgPoseTasksExpr), 2*numExprs);
    
    for i = 1:numel(avgPoseTasksExpr)
        
        avgPoseTask = avgPoseTasksExpr(i);

        exprs = avgPoseTask.expr;

        exprBinary1 = exprs(1) == exprList;
        exprBinary2 = exprs(2) == exprList;
        
        exprFeat1(i, :) = [exprBinary1, exprBinary2];
        exprFeat2(i, :) = [exprBinary2, exprBinary1];
        
    end

    dlmwrite(options.fileINTERACTImgExprDataGT1, exprFeat1, ';');
    dlmwrite(options.fileINTERACTImgExprDataGT2, exprFeat2, ';');

end