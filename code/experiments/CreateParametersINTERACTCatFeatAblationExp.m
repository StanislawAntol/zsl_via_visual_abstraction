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

function parameters = CreateParametersINTERACTCatFeatAblationExp()

    parameters = CreateParameters();
                          
    %% ZSL
    parameters.detMethods  = [1 2 3];
%     parameters.detMethods  = [1];
    parameters.detMethodsNames = { ...
        'PP'; ... % Perfect Pose "Detection"
        'YR'; ... % Yang and Ramanan Detection
        'YR-BB'; ... % Yang and Ramanan Detection w/ Bounding Boxes
    };
    
    % More standard way
    parameters.normalizeCByTrain = 1;
    parameters.Cs = 30; %10.^([-2]);
    
    % Original ECCV 2014 paper way
    parameters.normalizeCByTrain = 0; 
    parameters.Cs = 10.^([-2]);
    
    % Final Paper
    parameters.trainOnKs = [50];% Dataset/Feature Ablation
    parameters.numRandKs = [1]; % Dataset/Feature Ablation

    parameters.biasTrain = [0];
    parameters.probTest  = [1];
    
    parameters.trainOnKsStr = strrep(num2str(parameters.trainOnKs), '  ', '_');
    parameters.numRandKsStr = strrep(num2str(parameters.numRandKs), '  ', '_');
    parameters.biasTrainStr = strrep(num2str(parameters.biasTrain), '  ', '_');
    parameters.probTestStr = strrep(num2str(parameters.probTest), '  ', '_');

    parameters.featSets = { ...
                            [1]; ...                % Baseline with no appearance
                            [2]; ...
                            [3]; ...
                            [4]; ...
                            [1 2]; ...
                            [1 3]; ...
                            [1 4]; ...
                            [1, 5, 6, 7]; ...       % Baseline
                            [1, 2, 3, 4]; ...       %     Ours with no appearance
                            [1, 2, 3, 4, 5]; ... 
                            [2, 3, 4, 5, 6, 7]; ...
                            [1, 3, 4, 5, 6, 7]; ...
                            [1, 2, 4, 5, 6, 7]; ...
                            [1, 2, 3, 5, 6, 7]; ...
                            [1, 2, 3, 4, 6, 7]; ...  %     Ours no expression
                            [1, 2, 3, 4, 5, 7]; ...  %     Ours no expression
                            [1, 2, 3, 4, 5, 6]; ...  %     Ours no expression
                            [1, 2, 3, 4, 5, 6, 7]; ...  %     Ours
                              };
    
    str = '';
    for i = 1:length(parameters.featSets)
        if ( i == 1 )
            str = [str, '[', strrep(num2str(parameters.featSets{i}), '  ', '_'), ']'];
        else
            str = [str, '_[', strrep(num2str(parameters.featSets{i}), '  ', '_'), ']'];
        end
    end
    parameters.featsStr = str;
    parameters.featsStr = 'feature_ablation';
    
    featTypeNames = parameters.featTypeNames';

    parameters.detMethodsStr = strrep(num2str(parameters.detMethods), '  ', '_');
    parameters.detMethodsNamesStr = strjoin(parameters.detMethodsNames', '_');

end