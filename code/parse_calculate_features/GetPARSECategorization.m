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

function imgVerbs = GetPARSECategorization(options)

    fid = fopen(options.filePARSECategorizationFinal);
    colsAsCells = textscan(fid, '%d', 'Delimiter', ';');
    fclose(fid);
    imgVerbs = colsAsCells{1};
    
end