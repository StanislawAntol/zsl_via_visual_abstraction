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

function createJSONForPoseCollection(options, tasks)

    JSONFilename = 'assignments.json';
    fid = fopen(JSONFilename, 'w');
    
    fprintf(fid, '{\n');
    fprintf(fid, '"pairs": [\n');
    
    for i = 1:(numel(tasks)-1)
        pairFormat = '{ "assignmentid":"%s", "sentence":"%s" },\n';
        fprintf(fid, pairFormat, tasks(i).assignmentid, tasks(i).sentence);
    end
    
    pairFormat = '{ "assignmentid":"%s", "sentence":"%s" }\n';
    fprintf(fid, pairFormat, tasks(i).assignmentid, tasks(i).sentence);
    fprintf(fid, ']\n}\n');
    
    fclose(fid);
    
    
end