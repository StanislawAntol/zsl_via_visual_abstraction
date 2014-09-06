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

function tasks = ProcessUserResults(options, taskStruct, resHeaders, resData)

    tasks = taskStruct;

    [tasks.comments] = tasks.answer_comments;
    tasks = rmfield(tasks, 'answer_comments');
    tasks = rmfield(tasks, 'answer_next');

    lineData = cellfun(@(x) strsplit(x, '#!#'), resData, 'UniformOutput', 0);

    % counter = 1;
    % task.poseTasks = [];
    % newPose = struct();
    % lineData = strsplit(resultEntry,'#!#');

    for idxTask = 1:size(lineData, 1)
        tasks(idxTask).poseTasks = [];
        if (numel(lineData{idxTask}) >= 2)
            for idxPose = 2:(options.numPoses+1) % Hack-ish
                newPose = struct();
                dataParts = strsplit(lineData{idxTask}{idxPose}, ',');

                % All below adheres to the answer string provided by the AMT
                % interface HTML file.
                newPose.img = dataParts{1};
                newPose.pose = zeros(numel(options.partParent), 2 ); % x, y
                newPose.occluded = zeros(numel(options.partParent), 1);

                for k = 2:2:(numel(dataParts)-1)
                    vName = dataParts{k};
                    numFromFirstStr = str2num(vName(3:end))+1;
                    numFromSecondStr = str2num(dataParts{k+1});
                    if regexp(vName,'Oc','start')
                        newPose.occluded(numFromFirstStr, 1) = numFromSecondStr;
                    elseif regexp(vName,'Px','start')
                        newPose.pose(numFromFirstStr,1) = numFromSecondStr;
                    elseif regexp(vName,'Py','start')
                        newPose.pose(numFromFirstStr,2) = numFromSecondStr;
                    else
                        disp('ERROR: datatype not understood');
                        disp(vName);
                    end

                end

                tasks(idxTask).poseTasks = [tasks(idxTask).poseTasks; newPose];
            end
        else
            tasks(idxTask).poseTasks = [];
            fprintf('ERROR from ProcessUserResults.\n');
        end
    end

end