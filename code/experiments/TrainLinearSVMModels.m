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

function models = TrainLinearSVMModels(options, parameters, biasTrain, trainLabels, trainFeatMat)

    Cs = parameters.Cs;
    numCs = numel(Cs);
    
    models = cell(numCs, 1);
    
    for i = 1:numCs
        if ( parameters.normalizeCByTrain ~= 0 )
            curC = Cs(i)./length(trainLabels); % Scale since liblinear doesn't normalize by dataset sizesss
        else
            curC = Cs(i);
        end
        %fprintf('Training #%d with C = %f\n', i, curC);
        if ( biasTrain ~= 0 )
            trainOptions = ['-q -c ' num2str(curC) ' -B 1'];
        else
            trainOptions = ['-q -c ' num2str(curC) ' -B 0'];
        end
        seed = RandStream('mt19937ar','Seed', parameters.seedVal);
        models{i} = train(trainLabels, sparse(trainFeatMat), trainOptions);
    end

end