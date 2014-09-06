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

%% Add Person-scaled Noise to Pose
function partXYNoise = AddGaussianNoise(options, partXY, sigma)

    seed = RandStream('mt19937ar','Seed', options.seedVal);
    partXYNoise = partXY;
    avgScale = 0.0;
    numScale = 0;
    
    for i = 1:options.numImgs
        for j = 1:options.numPeople
            baseBodyIdx = mod( j-1, options.numPeople ) + 1;
            IJBodyIdx   = mod( j  , options.numPeople ) + 1;
            personBase = partXY{i, baseBodyIdx};

            mean = [struct('x', 'y'); struct('x', 'y')];

            if (personBase.x(options.ihead) == -1.0 || ...
                    personBase.y(options.ihead) == -1.0 || ...
                    personBase.x(options.ishoulderL) == -1.0 || ...
                    personBase.y(options.ishoulderL) == -1.0 || ...
                    personBase.x(options.ishoulderR) == -1.0 || ...
                    personBase.y(options.ishoulderR) == -1.0 || ...
                    personBase.x(options.ihipL) == -1.0 || ...
                    personBase.y(options.ihipL) == -1.0 || ...
                    personBase.x(options.ihipR) == -1.0 || ...
                    personBase.y(options.ihipR) == -1.0 ...
                    )
                % do nothing

            else
                mean(1+1).x = (personBase.x(options.ishoulderL) + personBase.x(options.ishoulderR) + personBase.x(options.ihipL) + personBase.x(options.ihipR)) / 4.0;
                mean(1+1).y = (personBase.y(options.ishoulderL) + personBase.y(options.ishoulderR) + personBase.y(options.ihipL) + personBase.y(options.ihipR)) / 4.0;

                mean(0+1).x = personBase.x(options.ihead);
                mean(0+1).y = personBase.y(options.ihead);

                scaleBody = sqrt((mean(1+1).x - mean(0+1).x)*(mean(1+1).x - mean(0+1).x) + (mean(1+1).y - mean(0+1).y)*(mean(1+1).y - mean(0+1).y));
                avgScale = avgScale + scaleBody;
                numScale = numScale+1;
            end
        end
    end

    avgScale = avgScale/numScale;
    fprintf('Average body scale = %f\n', avgScale);

    for i = 1:options.numImgs
        fvec = [];
        for j = 1:options.numPeople

            baseBodyIdx = mod( j-1, options.numPeople ) + 1;

            personBase = partXY{i, baseBodyIdx};

            mean = [struct('x', 'y'); struct('x', 'y')];
            scaleBody = avgScale;

            if (    personBase.x(options.ihead) == -1.0 || ...
                    personBase.y(options.ihead) == -1.0 || ...
                    personBase.x(options.ishoulderL) == -1.0 || ...
                    personBase.y(options.ishoulderL) == -1.0 || ...
                    personBase.x(options.ishoulderR) == -1.0 || ...
                    personBase.y(options.ishoulderR) == -1.0 || ...
                    personBase.x(options.ihipL) == -1.0 || ...
                    personBase.y(options.ihipL) == -1.0 || ...
                    personBase.x(options.ihipR) == -1.0 || ...
                    personBase.y(options.ihipR) == -1.0 ...
                    )
                % do nothing

            else
                mean(1+1).x = (personBase.x(options.ishoulderL) + personBase.x(options.ishoulderR) + personBase.x(options.ihipL) + personBase.x(options.ihipR)) / 4.0;
                mean(1+1).y = (personBase.y(options.ishoulderL) + personBase.y(options.ishoulderR) + personBase.y(options.ihipL) + personBase.y(options.ihipR)) / 4.0;

                mean(0+1).x = personBase.x(options.ihead);
                mean(0+1).y = personBase.y(options.ihead);

                scaleBody = sqrt((mean(1+1).x - mean(0+1).x)*(mean(1+1).x - mean(0+1).x) + (mean(1+1).y - mean(0+1).y)*(mean(1+1).y - mean(0+1).y));
            end

            for k = 1:options.numParts

                if ( personBase.x(k) == -1.0 || personBase.y(k) == -1.0 )
                    % Do nothing, already -1.
                    %                 dbstop
                else
                    partXYNoise{i, baseBodyIdx}.x(k) = personBase.x(k) + scaleBody.*sigma.*randn(seed, 1);
                    partXYNoise{i, baseBodyIdx}.y(k) = personBase.y(k) + scaleBody.*sigma.*randn(seed, 1);

                end
            end
        end


%         [partXY{i, 1}.x, partXYNoise{i, 1}.x]
%         [partXY{i, 1}.y, partXYNoise{i, 1}.y]
    end

end
