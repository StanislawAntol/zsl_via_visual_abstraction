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

function avgPoseTasks = ComputingAllAveragePoses(options, tasks)

    %% Deal with organizing data by verb
    verbs = GetINTERACTVerbs(options);
    verbGroups = GroupingTasksByImg(options, tasks, verbs);
    numVerbs = numel(verbs);

    visualize = options.visualizeAnnotationsDuringAvg;
    
    count = 0;

    avgPoseTasks = [];

    for t = 1:numVerbs
        verb = verbs{t};
        imgsForVerb = verbGroups{t, 1};
        poseImgsForVerb = verbGroups{t, 2};

        if ( isempty(imgsForVerb) == 0 )
            for z = 1:numel(imgsForVerb)
                count = count + 1;

                poseImgs = poseImgsForVerb{z};

                avgPoses = ComputingAveragePoseByConsensus(options, tasks, poseImgs, visualize);

                if (mod(count, 50) == 0)
                    disp(['Currently on image: ', num2str(count)]);
                end

                imgName = strsplit(avgPoses(1).img, '.');
                poseAssignmentID = [imgName{1}];

                avgPoseTask.workerid = 'stan';
                avgPoseTask.comment = '';
                avgPoseTask.assignmentid = poseAssignmentID;
                avgPoseTask.verb = verb;
                avgPoseTask.poseTasks = avgPoses;

                avgPoseTasks = [avgPoseTasks; avgPoseTask];
            end
        end
    end

end