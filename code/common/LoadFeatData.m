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

function features = LoadFeatData(dir, featFileBase, featBaseName, numOrders)
        
    numFeats = numel(featBaseName);
    features = cell(numFeats, numOrders);
    for j = 1:numOrders
        for i = 1:numFeats
            filename = [featFileBase, num2str(j), '_', featBaseName{i}];
            features{i, j} = load(fullfile(dir, filename));
        end
    end
    
end