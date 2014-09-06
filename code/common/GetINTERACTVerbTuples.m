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

function [verbsNum, verbsName] = GetINTERACTVerbTuples(options)

    fid = fopen(options.fileInitDatasetVerbs);
    colsAsCells = textscan(fid, '%d%s', 'Delimiter', ';');
    fclose(fid);
    verbsNum  = colsAsCells{1};
    verbsName = colsAsCells{2};

end

