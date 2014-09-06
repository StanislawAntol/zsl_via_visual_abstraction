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

function lookingAtOther = OneLookingAtOther(X1, X2, flip, X)

    diff = X2 - X1;
    normal = [ -diff(2); diff(1) ];
    val = sign(dot((X-X2), normal)); 

    if (flip == 0)
        lookingAtOther = val >= 0; % we have below x-axis is +ve y
    else
        lookingAtOther = val < 0;
    end

end