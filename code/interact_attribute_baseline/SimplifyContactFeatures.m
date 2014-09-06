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

function newContFeat = SimplifyContactFeatures(contFeat)

    numContFeats = size(contFeat, 2)/4;
    % 104 is the last of the self-contact features
    simpleContIdxs = [numContFeats+1:numContFeats*2];
    contFeatP2 = contFeat(:, simpleContIdxs);
    contFeatP1 = contFeat(:, size(contFeat, 2)/2+simpleContIdxs);
    newContFeat = [ExtractSimpleFeats(contFeatP1), ExtractSimpleFeats(contFeatP2)];
    
end

function newContFeat = ExtractSimpleFeats(tempContFeat)

    numLimbs  = 8;
    numJoints = 13;
    limbCount = 1;
    
    idxJHead      = [ 1];
    idxsJShoulder = [ 2,  5];
    idxsJElbow    = [ 3,  6];
    idxsJHand     = [ 4,  7];
    idxsJHip      = [ 8, 11];
    idxsJKnee     = [ 9, 12];
    idxsJFoot     = [10, 13];
    
    idxsLHand  = [2, 4];
    idxsLElbow = [1, 3];
    idxsLKnee  = [5, 7];
    idxsLFoot  = [6, 8];
    
    for limbCount = 1:numLimbs 
        idxs = (numJoints*(limbCount-1))+[1:numJoints];
        tempFeats = tempContFeat(:, idxs);
        featsHead = tempFeats(:, idxJHead);
        featsShoulder = max(tempFeats(:, idxsJShoulder(1)), tempFeats(:, idxsJShoulder(2)));
        featsElbow    = max(tempFeats(:, idxsJElbow(1)), tempFeats(:, idxsJElbow(2)));
        featsHand     = max(tempFeats(:, idxsJHand(1)), tempFeats(:, idxsJHand(2)));
        featsHip      = max(tempFeats(:, idxsJHip(1)), tempFeats(:, idxsJHip(2)));
        featsKnee     = max(tempFeats(:, idxsJKnee(1)), tempFeats(:, idxsJKnee(2)));
        featsFoot     = max(tempFeats(:, idxsJFoot(1)), tempFeats(:, idxsJFoot(2)));
        
        limbFeats{limbCount, 1} = [featsHead, featsShoulder, featsElbow, featsHand, featsHip, featsKnee, featsFoot];
    end
    
    featsHands  = max(limbFeats{idxsLHand(1)}, limbFeats{idxsLHand(2)});
    featsElbows = max(limbFeats{idxsLElbow(1)}, limbFeats{idxsLElbow(2)});
    featsKnees  = max(limbFeats{idxsLKnee(1)}, limbFeats{idxsLKnee(2)});
    featsFeet   = max(limbFeats{idxsLFoot(1)}, limbFeats{idxsLFoot(2)});
    
    newContFeat = [featsHands, featsElbows, featsKnees, featsFeet];
end