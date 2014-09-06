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

function gazeFeat = ComputeGazeFeat(options, scene, curP1)

        pAPose = options.clipartInterfaceGlobals.personScale*scene.pAPose;
        pBPose = options.clipartInterfaceGlobals.personScale*scene.pBPose;
        pAFlip = scene.pAFlip;
        pBFlip = scene.pBFlip;
        pAHeadNeckConverted = pAPose(options.clipartToStickmanIdxs(1:2, pAFlip+1), 1:2);
        pBHeadNeckConverted = pBPose(options.clipartToStickmanIdxs(1:2, pBFlip+1), 1:2);
        
        pAHead = [pAHeadNeckConverted(1, 1); -1*pAHeadNeckConverted(1, 2)];
        pANeck = [pAHeadNeckConverted(2, 1); -1*pAHeadNeckConverted(2, 2)];
        
        pBHead = [pBHeadNeckConverted(1, 1); -1*pBHeadNeckConverted(1, 2)];
        pBNeck = [pBHeadNeckConverted(2, 1); -1*pBHeadNeckConverted(2, 2)];
    
        if ( curP1 == 1 ) % Person 1 is Person A
            gazeFeat = GazeCalculation(pANeck, pAHead, pAFlip, ...
                                   pBNeck, pBHead, pBFlip);
        elseif ( curP1 == 2 ) % Person 1 is Person B
            gazeFeat = GazeCalculation(pBNeck, pBHead, pBFlip, ...
                                    pANeck, pAHead, pAFlip);
        else
            disp('Warning: Scene is non-standard.')
            gazeFeat = -1*ones(5, 1);
        end
        
end

function gazeFeat = GazeCalculation(N1, H1, flip1, N2, H2, flip2)

    oneLookTwo = OneLookingAtOther(N1, H1, flip1, H2);
    twoLookOne = OneLookingAtOther(N2, H2, flip2, H1);
    
    lookingAtOtherFeat = [oneLookTwo; twoLookOne];
    
    lAASFeat = LookAtAwaySameCalculation(oneLookTwo, twoLookOne);
    
    gazeFeat = [lookingAtOtherFeat; lAASFeat];
end
