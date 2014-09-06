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

function contFeat = ComputeSimpleContactFeat(options, contH, contE, contK, contF)
    contFeat = [ConvertToBinary(options, contH); ConvertToBinary(options, contE); ConvertToBinary(options, contK); ConvertToBinary(options, contF)];
end

function contBinary = ConvertToBinary(options, cont)
    contBinary = zeros(length(options.jointNames), 1);
    numbers = str2double(strsplit(cont, ','));
    if (~isnan(numbers))
        for idx = 1:length(numbers)
            binaryIdx = numbers(idx);
            contBinary(binaryIdx) = 1;
        end
    end
end