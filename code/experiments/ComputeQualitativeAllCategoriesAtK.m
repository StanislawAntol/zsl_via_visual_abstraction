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

function [imgIdxs, imgLabels, sortedTestLabels, imgCorrectness] = ComputeQualitativeAllCategoriesAtK(options, parameters, modelClasses, testLabels, dec1Values, dec2Values)  

    for i = 1:numel(dec1Values)
        if ( nargin == 5 )
            maxScores = dec1Values{i};
        else
            maxScores = max(dec1Values{i}, dec2Values{i});
        end

        [imgMaxScores, imgPredIdxs] = sort(maxScores, 2, 'descend'); 
         imgMaxScore = imgMaxScores(:, 1); % Top score per image
         imgPredIdx = imgPredIdxs(:, 1);

        [~, imgIdxs] = sort(imgMaxScore, 1, 'descend'); 
        imgLabels = modelClasses(imgPredIdx(imgIdxs));

        sortedTestLabels = testLabels(imgIdxs);
        imgCorrectness = imgLabels == testLabels(imgIdxs);
    end

end