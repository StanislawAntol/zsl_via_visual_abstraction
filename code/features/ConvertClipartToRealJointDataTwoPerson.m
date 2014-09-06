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

function allData = ConvertClipartToRealJointDataTwoPerson(options, scene)

    curPAPose = options.clipartInterfaceGlobals.personScale*scene.pAPose+.00000132; % In case clipart is out of bounds
    curPBPose = options.clipartInterfaceGlobals.personScale*scene.pBPose+.00000132; % 
    curPAFlip = scene.pAFlip;
    curPBFlip = scene.pAFlip;
    convertPAPose = curPAPose(options.clipartToStickmanIdxs(:, curPAFlip+1), 1:2);
    convertPBPose = curPBPose(options.clipartToStickmanIdxs(:, curPBFlip+1), 1:2);

    if ( options.clipartType == 1 )
        curP1 = scene.p1;
    else
        curP1 = 1; % Just have arbitrary order until GT collected
    end
    
    if ( curP1 == 1 ) % Person 1 is Person A
        allData = [ reshape(convertPAPose', numel(convertPAPose), 1);
                    reshape(convertPBPose', numel(convertPBPose), 1)];
    elseif ( curP1 == 2 ) % Person 1 is Person B
        allData = [ reshape(convertPBPose', numel(convertPBPose), 1);
                    reshape(convertPAPose', numel(convertPAPose), 1)];
    else
        disp('Warning: Sentence is non-standard.')
        allData = -1*ones(2*numel(convertPAPose), 1);
    end
end

