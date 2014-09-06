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

function parameters = CreateParameters()

    parameters.seedVal = 100;
    parameters.responseThreshold = 0.5;
    
    parameters.responseMethod = 1;
    
    parameters.trainingPercs =  [ 0 ];
    parameters.trainingPercsStr = strrep(num2str(parameters.trainingPercs), '  ', '_');
    parameters.randTrainSplits = [ 1 ]; % one for each trainPercs

    parameters.featSets = { ...
                        [2, 5, 6, 7]; ... % Contact, Expr, Gaze, Gend
                        };
end