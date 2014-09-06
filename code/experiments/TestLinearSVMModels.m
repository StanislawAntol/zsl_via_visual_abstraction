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

function [decValues1, decValues2] = TestLinearSVMModels(options, parameters, probTest, models, testLabels, testFeat1, testFeat2)

    Cs = parameters.Cs;
    numCs = numel(Cs);
    
    if ( probTest ~= 0 )
        testOptions = '-q -b 1';
    else
        testOptions = '-q -b 0';
    end
    
    for i = 1:numCs
        fprintf('Testing #%d with C = %f\n', i, Cs(i));
        [~, ~, decValues1{i}] = predict(testLabels, sparse(testFeat1), models{i}, testOptions);
        [~, ~, decValues2{i}] = predict(testLabels, sparse(testFeat2), models{i}, testOptions);
    end
    
end