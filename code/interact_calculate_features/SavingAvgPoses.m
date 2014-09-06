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

function savingAvgPoses(options, avgPoseTasks)

    allPoseData1 = zeros(numel(avgPoseTasks), 4*options.numParts);
    allPoseData2 = zeros(numel(avgPoseTasks), 4*options.numParts);

    for i = 1:numel(avgPoseTasks)
        avgPoseTask = avgPoseTasks(i);

        avgPoses = avgPoseTask.poseTasks;

        poseData1 = [reshape(avgPoses(1).pose', 2*options.numParts, 1);
                     reshape(avgPoses(2).pose', 2*options.numParts, 1)];
        poseData2 = [reshape(avgPoses(2).pose', 2*options.numParts, 1);
                     reshape(avgPoses(1).pose', 2*options.numParts, 1)];

        allPoseData1(i, :) = poseData1;
        allPoseData2(i, :) = poseData2;
    end

    dlmwrite(options.fileINTERACTImgPoseDataGT1, allPoseData1, ';');
    dlmwrite(options.fileINTERACTImgPoseDataGT2, allPoseData2, ';');

end