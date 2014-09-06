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

function duplicatesSubset = KeepOneOfDuplicates(sortedMembers)
    
    seed = RandStream('mt19937ar','Seed', 651);
    duplicates = [sortedMembers{:}];
    kept = [];
    
    for i = 1:numel(sortedMembers)
        members = sortedMembers{i};
        ind = randi(seed, length(members));
        kept = [kept; members(ind)];
        
    end
    
    duplicatesSubset = setdiff(duplicates, kept);
    
end