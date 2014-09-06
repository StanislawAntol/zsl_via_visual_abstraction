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

% Add path for some common MTurk task data-related functions
addpath(fullfile('..', 'common'));

%% Gets the options that govern directories, what runs, etc.
options = CreateOptionsGlobal();
options = CreateOptionsLocal(options);

if ( options.parseAMTFile ~= 0 )
    [taskAMT, taskData] = ProcessPARSEGazeResultsData(options);    
    save(options.AMTFile, 'taskAMT', 'taskData');
else
    load(options.AMTFile); % Loads already processed taskAMT, taskData
end

if ( options.processGazeData ~= 0 )
    avgPoseTasksGaze = ProcessPARSEGazeData(options, taskAMT, taskData);
    save(options.avgPoseGazeFile, 'avgPoseTasksGaze');
else
    load(options.avgPoseGazeFile)
end

% for i = 1:length(avgPoseTasksGaze)
%     task = avgPoseTasksGaze(i);
%     assignmentid = task.assignmentid;
%     for j = 1:length(task.poseTasks)
%         poseTask = task.poseTasks(j);
%         if (task.badAnnTotal > 1)
%             imgFilename = sprintf('%s_avgPoses_%02d.png', assignmentid, 1);
%             subplot(1, 2, 1);
%             imshow( fullfile(options.imgPath, imgFilename ) );
%             imgFilename = sprintf('%s_avgPoses_%02d.png', assignmentid, 2);
%             subplot(1, 2, 2);
%             imshow( fullfile(options.imgPath, imgFilename ) );
%             pause();
%         end
%         
%     end
% end