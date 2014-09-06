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

function [featuresStr, imgFilenamesStr, labelsStr] = CreateFeatureVarNames(options, whichData)
    featuresStr = sprintf('all%sFeatures', options.featVarBaseName{whichData});
    imgFilenamesStr = sprintf('all%sImgFilename', options.featVarBaseName{whichData});
    labelsStr = sprintf('all%sLabels', options.featVarBaseName{whichData});
end