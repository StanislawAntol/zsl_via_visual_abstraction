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

function avgPoses = ComputingAveragePoseByConsensus(options, tasks, poseImgsIdxPairs, visualize)

    numParts = options.numParts;
    numWorkerAgree = options.numWorkerAgree;

    numIdxPairs = size(poseImgsIdxPairs, 1);
    occSum      = zeros(numIdxPairs, 1);

    %% Compute the annotation pair with the fewest "not in image"/"occluded" points
     % This pair will be the "ground truth" for the Person 0/Person 1 labeling
    for idx = 1:numIdxPairs
        idxPair = poseImgsIdxPairs(idx, :);
        curTask = tasks(idxPair(1));
        curPoseTask = curTask.poseTasks(idxPair(2));
        curOccluded = curPoseTask.occluded;
        occSum(idx) = sum(sum( curOccluded ));
    end
    occSum = occSum(1:2:numIdxPairs) + occSum(2:2:numIdxPairs);
    [~, minOccIdx] = min(occSum);

    img = curPoseTask.img;
%     disp(img);

    idxOffset = [-1, 0];
    numPeopleInImg = numel(idxOffset);

    GTPersonIdxs = zeros(numPeopleInImg, 1);
    GTPersonOcclMatrices = cell(numPeopleInImg, 1);
    GTPersonPoses = cell(numPeopleInImg, 1);

    for j = 1:numel(idxOffset)

        idx = 2*minOccIdx + idxOffset(j);
        GTPersonIdxs(j) = idx;

        idxPair = poseImgsIdxPairs(idx, :);
        personTask = tasks(idxPair(1));
        personPoseTask = personTask.poseTasks(idxPair(2));
        % Make it equal size matrix for easy multiplication
        GTPersonOcclMatrices{j} = repmat(personPoseTask.occluded, 1, 2); 
        GTPersonPoses{j} = personPoseTask.pose;

        if (visualize ~= 0)
            figure(j)
            renderPose(options, personPoseTask);
        end
    end

    if (visualize ~= 0)
        pause();
    end

    %% Figure out which of the "ground truth" the rest of the annotations map to
    remainingIdxs = setdiff(1:2:numIdxPairs, GTPersonIdxs(1))';

    mappings = zeros(1+numel(remainingIdxs), 2);
    mappings(1, :) = [0, 1];
    offsets = [0, 1];

    for i = 1:1:numel(remainingIdxs)

        guessPersonPoseTask = [];
        guessPersonOcclMatrices = cell(numPeopleInImg, 1);
        guessPersonPoses = cell(numPeopleInImg, 1);
        occludedIntersect = zeros( size(GTPersonOcclMatrices{1}) );

        for j = 1:numPeopleInImg
            idx = remainingIdxs(i) + offsets(j);
            idxPair = poseImgsIdxPairs(idx, :);
            personTask = tasks(idxPair(1));
            guessPersonPoseTask = [guessPersonPoseTask; personTask.poseTasks(idxPair(2))];
            % Make it equal size matrix for easy multiplication
            guessPersonOcclMatrices{j} = repmat(guessPersonPoseTask(j).occluded, 1, 2); 
            guessPersonPoses{j} = guessPersonPoseTask(j).pose;

            occludedIntersect = occludedIntersect + GTPersonOcclMatrices{j} + guessPersonOcclMatrices{j};
        end

        diff1A = (~occludedIntersect).*( GTPersonPoses{1} - guessPersonPoses{1} );
        diff1A = norm(reshape(diff1A, 2*numParts, 1));
        diff2B = (~occludedIntersect).*( GTPersonPoses{2} - guessPersonPoses{2} );
        diff2B = norm(reshape(diff2B, 2*numParts, 1));

        diff1B = (~occludedIntersect).*( GTPersonPoses{1} - guessPersonPoses{2} );
        diff1B = norm(reshape(diff1B, 2*numParts, 1));
        diff2A = (~occludedIntersect).*( GTPersonPoses{2} - guessPersonPoses{1} );
        diff2A = norm(reshape(diff2A, 2*numParts, 1));

        sumOrder1 = diff1A + diff2B;
        sumOrder2 = diff1B + diff2A;

        if ( sumOrder1 < sumOrder2 )
            mapping = [ 0 1 ];
        elseif ( sumOrder1 > sumOrder2 )
            mapping = [ 1 0 ];
        else
            disp('Distances equal; probably no comparison points');
            mapping = [ 0 1 ];
        end

        mappings(i+1, :) = mapping;

    %     for j = 1:numPeopleInImg
    %         structIdx = mapping(j) + 1;
    %         figure( structIdx )
    %         renderPose(options, guessPersonPoseTask( structIdx ) );
    %     end
    %     pause()

    end

    idxOrder = [GTPersonIdxs(1); remainingIdxs];

    if ( sum( mappings(:, 1) ) > sum( mappings(:, 2) ) )
        mappings = ~mappings;
        disp('Flipping mappings');
    end

    for i = 1:numel(idxOrder)
        idxBase = idxOrder(i);
        idxA = idxBase + mappings(i, 1);
        idxB = idxBase + mappings(i, 2);

        idxPairA = poseImgsIdxPairs(idxA, :);
        personATask = tasks(idxPairA(1));
        personAPoseTask = personATask.poseTasks(idxPairA(2));
        personAOccluded = personAPoseTask.occluded;
        personAOccludedMatrix = repmat(~personAOccluded, 1, 2);
        personAPose = personAPoseTask.pose.*personAOccludedMatrix;
        personAPoseMatX(:, i) = personAPose(:, 1);
        personAPoseMatY(:, i) = personAPose(:, 2);

        idxPairB = poseImgsIdxPairs(idxB, :);
        personBTask = tasks(idxPairB(1));
        personBPoseTask = personBTask.poseTasks(idxPairB(2));
        personBOccluded = personBPoseTask.occluded;
        personBOccludedMatrix = repmat(~personBOccluded, 1, 2);
        personBPose = personBPoseTask.pose.*personBOccludedMatrix;
        personBPoseMatX(:, i) = personBPose(:, 1);
        personBPoseMatY(:, i) = personBPose(:, 2);

        OccMatA(:, i) = personAOccluded;
        OccMatB(:, i) = personBOccluded;
    end

    avgOccA = ~(sum(~OccMatA, 2) >= numWorkerAgree);
    avgOccB = ~(sum(~OccMatB, 2) >= numWorkerAgree);

    avgPoseA = zeros(14, 2);
    avgPoseB = zeros(14, 2);

    for i = 1:numel(avgOccA)
        personAX = personAPoseMatX(i, :);
        personAY = personAPoseMatY(i, :);
        personBX = personBPoseMatX(i, :);
        personBY = personBPoseMatY(i, :);

        I = find(personAX);
        personAX = personAX(I);
        avgPoseA(i, 1) = median(personAX);

        I = find(personAY);
        personAY = personAY(I);
        avgPoseA(i, 2) = median(personAY);

        I = find(personBX);
        personBX = personBX(I);
        avgPoseB(i, 1) = median(personBX);

        I = find(personBY);
        personBY = personBY(I);
        avgPoseB(i, 2) = median(personBY);
    end

    notInImgIdxs = find(avgOccA);
    avgPoseA( notInImgIdxs, 1) = -1;
    avgPoseA( notInImgIdxs, 2) = -1;
    
    notInImgIdxs = find(avgOccB);
    avgPoseB( notInImgIdxs, 1) = -1;
    avgPoseB( notInImgIdxs, 2) = -1;
    
    avgPoseAStr.img      = img;
    avgPoseAStr.pose     = avgPoseA;
    avgPoseAStr.occluded = avgOccA;
    
    avgPoseBStr.img      = img;
    avgPoseBStr.pose     = avgPoseB;
    avgPoseBStr.occluded = avgOccB;
    

    if (visualize ~= 0)
        figure(1)
        poseAImg = renderPose(options, avgPoseAStr);

        figure(2)
        poseBImg = renderPose(options, avgPoseBStr);
    end
    
    avgPoses = [avgPoseAStr; avgPoseBStr];

end