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

function sigmaVal = ComputeYRSigma(inputGTFile, inputYRFile, numPeople)

    options.numPeople = numPeople;
    options.numParts = 14;
    options.numJointPairs = 8;
    
    options.ihead = 0+1;
    options.ishoulderL = 2+1;
    options.ishoulderR = 5+1;
    options.ihipL = 11+1;
    options.ihipR = 8+1;

    [~, partXYGT] = LoadRelationData(options, inputGTFile);
    [options, partXYYR] = LoadRelationData(options, inputYRFile);
    
    avgScale = 0.0;
    numScale = 0;
    
    for i = 1:options.numImgs
        for j = 1:options.numPeople
            baseBodyIdx = mod( j-1, options.numPeople ) + 1;
            IJBodyIdx   = mod( j  , options.numPeople ) + 1;
            personBaseGT = partXYGT{i, baseBodyIdx};

            mean = [struct('x', 'y'); struct('x', 'y')];

            if (personBaseGT.x(options.ihead) == -1.0 || ...
                    personBaseGT.y(options.ihead) == -1.0 || ...
                    personBaseGT.x(options.ishoulderL) == -1.0 || ...
                    personBaseGT.y(options.ishoulderL) == -1.0 || ...
                    personBaseGT.x(options.ishoulderR) == -1.0 || ...
                    personBaseGT.y(options.ishoulderR) == -1.0 || ...
                    personBaseGT.x(options.ihipL) == -1.0 || ...
                    personBaseGT.y(options.ihipL) == -1.0 || ...
                    personBaseGT.x(options.ihipR) == -1.0 || ...
                    personBaseGT.y(options.ihipR) == -1.0 ...
                    )
                % do nothing

            else
                mean(1+1).x = (personBaseGT.x(options.ishoulderL) + personBaseGT.x(options.ishoulderR) + personBaseGT.x(options.ihipL) + personBaseGT.x(options.ihipR)) / 4.0;
                mean(1+1).y = (personBaseGT.y(options.ishoulderL) + personBaseGT.y(options.ishoulderR) + personBaseGT.y(options.ihipL) + personBaseGT.y(options.ihipR)) / 4.0;

                mean(0+1).x = personBaseGT.x(options.ihead);
                mean(0+1).y = personBaseGT.y(options.ihead);

                scaleBody = sqrt((mean(1+1).x - mean(0+1).x)*(mean(1+1).x - mean(0+1).x) + (mean(1+1).y - mean(0+1).y)*(mean(1+1).y - mean(0+1).y));
                avgScale = avgScale + scaleBody;
                numScale = numScale+1;
            end
        end
    end

    avgScale = avgScale/numScale;
    fprintf('Average body scale = %f\n', avgScale);

    sigmaSum = [];
    for i = 1:options.numImgs
        
        fvec = [];
        for j = 1:options.numPeople

            baseBodyIdx = mod( j-1, options.numPeople ) + 1;

            personBaseGT = partXYGT{i, baseBodyIdx};
            personBaseYR = partXYYR{i, baseBodyIdx};

            mean = [struct('x', 'y'); struct('x', 'y')];
            scaleBody = avgScale;

            if (    personBaseGT.x(options.ihead) == -1.0 || ...
                    personBaseGT.y(options.ihead) == -1.0 || ...
                    personBaseGT.x(options.ishoulderL) == -1.0 || ...
                    personBaseGT.y(options.ishoulderL) == -1.0 || ...
                    personBaseGT.x(options.ishoulderR) == -1.0 || ...
                    personBaseGT.y(options.ishoulderR) == -1.0 || ...
                    personBaseGT.x(options.ihipL) == -1.0 || ...
                    personBaseGT.y(options.ihipL) == -1.0 || ...
                    personBaseGT.x(options.ihipR) == -1.0 || ...
                    personBaseGT.y(options.ihipR) == -1.0 ...
                    )
                % do nothing

            else
                mean(1+1).x = (personBaseGT.x(options.ishoulderL) + personBaseGT.x(options.ishoulderR) + personBaseGT.x(options.ihipL) + personBaseGT.x(options.ihipR)) / 4.0;
                mean(1+1).y = (personBaseGT.y(options.ishoulderL) + personBaseGT.y(options.ishoulderR) + personBaseGT.y(options.ihipL) + personBaseGT.y(options.ihipR)) / 4.0;

                mean(0+1).x = personBaseGT.x(options.ihead);
                mean(0+1).y = personBaseGT.y(options.ihead);

                scaleBody = sqrt((mean(1+1).x - mean(0+1).x)*(mean(1+1).x - mean(0+1).x) + (mean(1+1).y - mean(0+1).y)*(mean(1+1).y - mean(0+1).y));
            end

            offsets = [];
            for k = 1:options.numParts
                
                if ( personBaseGT.x(k) == -1.0 || personBaseGT.y(k) == -1.0 || ...
                        personBaseYR.x(k) == -1.0 || personBaseYR.y(k) == -1.0 )
                    % Do nothing, already -1.
                    %                 dbstop
                else
%                     personBaseGT.x(k) + scaleBody.*sigma.*randn(seed, 1);
%                     personBaseGT.y(k) + scaleBody.*sigma.*randn(seed, 1);
%                     
                    offsets = [offsets; (personBaseYR.x(k)-personBaseGT.x(k))/scaleBody; (personBaseYR.y(k)-personBaseGT.y(k))/scaleBody];

                end
            end
            
%             sigmaSum = sigmaSum + std(offsets);
            sigmaSum = [sigmaSum; offsets];
            
        end

        
%         [partXYGT{i, 1}.x, partXYGTNoise{i, 1}.x]
%         [partXYGT{i, 1}.y, partXYGTNoise{i, 1}.y]
    end
    
%     sigmaVal = sigmaSum/(options.numImgs*options.numPeople);
    sigmaVal = std(sigmaSum);

end