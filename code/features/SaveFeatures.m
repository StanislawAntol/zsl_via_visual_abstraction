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

function SaveFeatures(baseName, features)

    numImages = size(features, 1);
    numFeatures = size(features, 2);
    numTotal = numImages*numFeatures;

    fprintf('Number of features = %d\n', numFeatures);
    fprintf('Number of images = %d\n', numImages);

    missingIdxs = features == -1.0;
    validIdxs = ~missingIdxs;

    numMissing = sum(sum( missingIdxs ));
    oneGoodVec = sum(missingIdxs, 2) ~= 0;
    numMissingAll = sum(oneGoodVec);

        
    goodFeats = validIdxs.*features;
    avgValSum = sum( goodFeats, 1 );
    avgValCt = sum( validIdxs, 1 );
    avgVal = avgValSum./avgValCt;
    if ( sum( isnan(avgVal) ) > 0 )
        fprintf('WARNING: Divided by zero for prior.\n');
    end

    fprintf('Percentage missing = %f\n', numMissing / numTotal);
    fprintf('Percentage missing all = %f\n', numMissingAll / numImages);

    % Write the original feature file (i.e., with missing data as -1)
    name = sprintf('%s_missing.txt', baseName);
    fprintf('Saving %s\n', name);
    dlmwrite(name, features, ';');

    % Write the file with missing data as 0
    name = sprintf('%s_zero.txt', baseName);
    fprintf('Saving %s\n', name);

    featuresZero = features;
    featuresZero(missingIdxs) = 0.0;
    dlmwrite(name, featuresZero, ';');

    % Write the file with missing data as feature prior
    name = sprintf('%s_prior.txt', baseName);
    fprintf('Saving %s\n', name);

    featuresPrior = features;
    priorFeaturesMat = repmat(avgVal, numImages, 1);
    featuresPrior(missingIdxs) = priorFeaturesMat(missingIdxs);
    dlmwrite(name, featuresPrior, ';');
    
    badVals = featuresPrior > 1.0 | featuresPrior < -0.00001;
    numBadVals = sum(sum( badVals == 1 ));
    if ( numBadVals > 0 )
        fprintf('ERROR: Number of bad values (in prior) is %d.\n', numBadVals);
    end

end