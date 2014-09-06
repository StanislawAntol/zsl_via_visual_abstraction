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

function DAPBinMat = ConvertDAPDataToBinMat(options, DAPData)

%     numFeats = 79;
%     Contact (56), Expr (14), Gaze (5), Gend (4)
%     DAPBinMat = zeros(length(DAPData), numFeats);
    DAPBinMat = [];
    for idx = 1:length(DAPData)
        % The way contact feature code (real images) is written, it's 2's
        % limbs touching 1's joints, followed by the inverse
       contFeat = [DAPData(idx).contP1', DAPData(idx).contP2'];
       exprFeat = [DAPData(idx).exprP1, DAPData(idx).exprP2];
       gazeFeat = CalculateGazeFeat(DAPData(idx).gazeP1, DAPData(idx).gazeP2)';
       gendFeat = [DAPData(idx).gendP1, DAPData(idx).gendP2];
       DAPBinMat(idx, :) = [contFeat, exprFeat, gazeFeat, gendFeat];
    end

end

function gazeFeat = CalculateGazeFeat(oneLookTwo, twoLookOne)

    lookingAtOtherFeat = [oneLookTwo; twoLookOne];

    lAASFeat = LookAtAwaySameCalculation(oneLookTwo, twoLookOne);

    gazeFeat = [lookingAtOtherFeat; lAASFeat];

end

function lAASFeat = LookAtAwaySameCalculation(oneLookTwo, twoLookOne)
    
    if ( oneLookTwo && twoLookOne )
        % Looking at each other
        lAASFeat = [1; 0; 0];
    elseif ( (~oneLookTwo) && (~twoLookOne) )
        % Looking away from each other
        lAASFeat = [0; 1; 0];
    else
        % Looking same direction
        lAASFeat = [0; 0; 1];
    end
    
end