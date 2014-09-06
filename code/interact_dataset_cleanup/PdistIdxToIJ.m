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

function [row, col] = PdistIdxToIJ(ind, m)
    level = 1;
    cutoff = m - 1;
    
    while ( ind > cutoff )
       ind    = ind - cutoff;
       m      = m - 1;
       level  = level + 1;
       cutoff = m - 1;
    end
    
    col = level;
    row = ind + level;

end