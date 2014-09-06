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

function verbPhrase = GetVerbFromImgName(imgTasks, imgName)

    data = strsplit(imgName, '_');
    assignmentID = strjoin(data(1:end-1), '_');
    
    taskIdx = FindAssignmentInTasks(imgTasks, assignmentID);

    verbPhrase = imgTasks(taskIdx).sentence;

end