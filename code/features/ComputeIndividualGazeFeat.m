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

function gazeFeat = ComputeIndividualGazeFeat(options, scene)
    pAFlip = scene.pAFlip;
    gazeFeat = [pAFlip == 0, pAFlip == 1];
end
