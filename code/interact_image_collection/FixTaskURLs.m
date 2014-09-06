%FIXTASKURLS Fixes bad URLs that are from the AMT results file.
%   newTasks = FixTaskURLs(tasks, badURLs) goes through the current tasks
%   struct array and replaces any "bad" URLs (as deemed by getBadURLs())
%   with the good ones (provided by that same function).
%
%   INPUT
%    -options:      Struct array of the tasks, possibly with bad URLs.
%    -badURLs:      Struct array of the bad URLs along with their
%                   corrections. See getBadURLs function for details.
%
%   OUTPUT
%     -newTasks:    New struct array of the old tasks array except with
%                   any problematic URLs fixed.
%
%   Author: Stanislaw Antol (santol@vt.edu)                Date: 2013-08-18

function newTasks = FixTaskURLs(tasks, badURLs)

    newTasks = tasks;
    
    for i = 1:numel(badURLs)
        badURLStrct = badURLs(i);
        assignmentid = badURLStrct.assignmentid;
        URLNum = badURLStrct.URLNum;
        newURL = badURLStrct.newURL;
        taskIdx = FindAssignmentInTasks(tasks, assignmentid);
        if (taskIdx > 0)
            newTasks(taskIdx).urls{URLNum} = newURL;
        else
            disp('WARNING: Bad assignment ID passed in from badURLs.')
            disp(['Bad assignment ID is: ', assignmentid]);
        end
        
    end
    
end