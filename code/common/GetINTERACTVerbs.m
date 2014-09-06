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

function verbs = GetINTERACTVerbs(options)

    fid = fopen(options.fileVerbList);
    colsAsCells = textscan(fid, '%s', 'Delimiter', ';');
    fclose(fid);
    verbs = colsAsCells{1}(2:end);

end

