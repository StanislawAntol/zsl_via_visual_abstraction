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

function parameters = CreateParametersPARSEInstExp()

    parameters = CreateParameters();
    
    parameters.trainingPercs =  [ 65 ]; % Training split is fixed on PARSE
    parameters.trainingPercsStr = strrep(num2str(parameters.trainingPercs), '  ', '_');
    parameters.randTrainSplits = [1]; % one for each trainPercs
    parameters.randTrainSplitsStr = strrep(num2str(parameters.randTrainSplits), '  ', '_');
    parameters.mapMethods = [1 2];
%     parameters.mapMethods = [2];
    parameters.spread = 1;
    parameters.yToX = 1;
    parameters.mapMethodsNames = { ...
                                   'None', ...
                                   'GRNN', ...
                                   };
                               
    parameters.mapMethodsStr = strrep(num2str(parameters.mapMethods), '  ', '_');
                               
    parameters.detMethods  = [1 2];
%     parameters.detMethods  = [1];
    parameters.detMethodsNames = { ...
        'PP'; ... % Perfect Pose "Detection"
        'YR'; ... % Yang and Ramanan Detection
    };
    
	parameters.detMethodsStr = strrep(num2str(parameters.detMethods), '  ', '_');
    parameters.detMethodsNamesStr = strjoin(parameters.detMethodsNames', '_');
    
    % 1 is all trained on GT, 2 is each trained with own training
    parameters.trainGRNNMethods  = [1, 2, 3]; 
    parameters.trainGRNNMethodsNames = { ...
        'PP'; ... % Perfect Pose "Detection" for GRNN training
        'self'; ... % Use own detection data for GRNN training
        'rand-NN'; ... % Random Baseline
    };
    
	parameters.trainGRNNMethodsStr = strrep(num2str(parameters.trainGRNNMethods), '  ', '_');
    
    parameters.featSets = { ...
                        [1, 2, 3, 4, 5, 6, 7]; ...  
                        };
%     parameters.featSets = { ...
%         [8]; ...  
%                         };
                    
%     parameters.featSets = { ...
%                             [1]; ...                % Baseline with no appearance
%                             [2]; ...
%                             [3]; ...
%                             [4]; ...
%                             [1 2]; ...
%                             [1 3]; ...
%                             [1 4]; ...
%                             [1, 5, 6, 7]; ...       % Baseline
%                             [1, 2, 3, 4]; ...       %     Ours with no appearance
%                             [1, 2, 3, 4, 5]; ... 
%                             [2, 3, 4, 5, 6, 7]; ...
%                             [1, 3, 4, 5, 6, 7]; ...
%                             [1, 2, 4, 5, 6, 7]; ...
%                             [1, 2, 3, 5, 6, 7]; ...
%                             [1, 2, 3, 4, 6, 7]; ...  %     Ours no expression
%                             [1, 2, 3, 4, 5, 7]; ...  %     Ours no expression
%                             [1, 2, 3, 4, 5, 6]; ...  %     Ours no expression
%                             [1, 2, 3, 4, 5, 6, 7]; ...  %     Ours
%                               };
    
    str = '';
    for i = 1:length(parameters.featSets)
        if ( i == 1 )
            str = [str, '[', strrep(num2str(parameters.featSets{i}), '  ', '_'), ']'];
        else
            str = [str, '_[', strrep(num2str(parameters.featSets{i}), '  ', '_'), ']'];
        end
    end
    parameters.featsStr = str;
    
    parameters.recallAtKNumDivs = 100;

end