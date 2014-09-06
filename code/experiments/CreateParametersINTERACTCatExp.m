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

function parameters = CreateParametersINTERACTCatExp()

    parameters = CreateParameters();
                          
    %% ZSL
    parameters.detMethods  = [1 2 3];
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
    parameters.trainOnKs = [1, 2, 6, 12, 20 , 50];
    parameters.numRandKs = [50, 50, 50, 50, 50, 1];
% 
%     parameters.trainOnKs = [50];
%     parameters.numRandKs = [1]; 
    
%     parameters.trainOnKs = [1, 10, 50];
%     parameters.numRandKs = [50, 50, 1]; 

%     % % Devi Stanford
%     parameters.trainOnKs = [ 10];
%     parameters.numRandKs = [ 50 ];
    
    parameters.biasTrain = [0];
    parameters.probTest  = [1];
    
    parameters.trainOnKsStr = strrep(num2str(parameters.trainOnKs), '  ', '_');
    parameters.numRandKsStr = strrep(num2str(parameters.numRandKs), '  ', '_');
    parameters.biasTrainStr = strrep(num2str(parameters.biasTrain), '  ', '_');
    parameters.probTestStr = strrep(num2str(parameters.probTest), '  ', '_');
    
    parameters.featsToUseDAP = [2, 5, 6, 7]; 
    parameters.featSets = { ...
                        [1, 2, 3, 4, 5, 6, 7]; ...  
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

    parameters.detMethodsStr = strrep(num2str(parameters.detMethods), '  ', '_');
    parameters.detMethodsNamesStr = strjoin(parameters.detMethodsNames', '_');

end