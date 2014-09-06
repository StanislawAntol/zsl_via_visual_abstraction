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

function contSents = CreateContactSentences(options, p1, cont)

    actualContIdxs = cont==1;
    actualCont = find(actualContIdxs);
    contSents = cell(length(actualCont), 1);
    numJoints = length(options.jointNames);
    
    if ( p1 ~= 0 )
        p1 = '1';
        p2 = '2';
    else
        p1 = '2';
        p2 = '1';
    end
    
    for idx = 1:length(actualCont)
        idxFeat = actualCont(idx);
        % Hacky and ugly -- fix!
        limb  = options.limbNames{ceil((idxFeat-1)/numJoints+.01)};
        joint = options.jointNames{mod((idxFeat-1), numJoints)+1};
        curSent = sprintf('%s''s %s is touching %s''s %s.', p1, limb, p2, joint);
        contSents{idx} = curSent;
    end

end