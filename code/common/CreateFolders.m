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

function CreateFolders(foldersArray)

    if ( ~iscell(foldersArray{1}) )
       foldersArray = {foldersArray}; 
    end

    for t = 1:numel(foldersArray)
        folders = foldersArray{t};

        for f = 1:numel(folders)
            curFolder = folders{f};

            if ~exist(curFolder, 'dir')
                mkdir(curFolder);
            end
        end
    end

end