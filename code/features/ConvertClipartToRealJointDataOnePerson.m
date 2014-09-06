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

function allData = ConvertClipartToRealJointDataOnePerson(options, scene)

    curPAPose = options.clipartInterfaceGlobals.personScale*scene.pAPose+.00000132; % In case clipart is out of bounds 
    curPAFlip = scene.pAFlip;
    convertPAPose = curPAPose(options.clipartToStickmanIdxs(:, curPAFlip+1), 1:2);

    allData = [ reshape(convertPAPose', numel(convertPAPose), 1);];
end

