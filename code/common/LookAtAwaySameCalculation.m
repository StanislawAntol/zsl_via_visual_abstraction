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
