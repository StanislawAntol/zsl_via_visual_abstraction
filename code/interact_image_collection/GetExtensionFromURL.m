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

function extension = GetExtensionFromURL(url)            
    extension = lower(url((end-2):end));
    if ( strcmp(extension, 'peg') )
        extension = 'jpeg';
    elseif ( strcmp(extension, 'iff') )
        extension = 'tiff';
    end
end