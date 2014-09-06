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

function [verbLabels, verbNames] = GetPARSEVerbs(options)

    fid = fopen(options.verbFile);
    colsAsCells = textscan(fid, '%d%s', 'Delimiter', ';');
    fclose(fid);
    verbLabels = double(colsAsCells{1});
    verbNames = colsAsCells{2};
    
end