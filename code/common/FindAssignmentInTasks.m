%FINDASSIGNMENTINTASKS Gets you the 'tasks' index for an assignment ID.
%   taskIdx = FindAssignmentInTasks(tasks, assignmentid) searches the
%   current tasks struct array to find the index of the assignment ID.
%
%   INPUT
%    -tasks:        Struct array of the tasks.
%    -assignmentID: String of assignment ID of interest.
%
%   OUTPUT
%     -taskIdx:     'tasks' index of the query assignment ID.
%
%   Author: Stanislaw Antol (santol@vt.edu)                Date: 2014-08-18

function taskIdx = FindAssignmentInTasks(tasks, assignmentID)

    assignmentIDs = extractfield(tasks, 'assignmentid');
    
    taskIdx = find( strcmp(assignmentIDs, assignmentID) );
    
    if ( isempty(taskIdx) )
        taskIdx = -1;
    end

end