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

function [filenames, labels] = LoadFilenameAndLabelData(dir, name, delimiter)

    fid = fopen(fullfile(dir, name));
    colsAsCells = textscan(fid, '%d%s%s', 'Delimiter', delimiter);
    fclose(fid);
    labels = double(colsAsCells{1});
    filenames = colsAsCells{2};
    
end