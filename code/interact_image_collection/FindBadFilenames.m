%FINDBADFILENAMES Function to find possibly bad URLs via current filenames.
%   badFilenames = findBadFilenames(options) looks through the current 
%   files to find files with extensions that aren't what we need. This 
%   helps us find the URLs that do not strictly end with .<ext>.
%
%   INPUT
%    -options:      Struct containing all configuration data.
%                   Should be created by createOptions function.
%
%   OUTPUT
%     -badFilenames: Cell array containing all bad filenames to further
%                    investigate.
%
%   Author: Stanislaw Antol (santol@vt.edu)                Date: 2014-08-18

function badFilenames = FindBadFilenames(options)

    badFilenames = {};

    filesStruct = dir(options.dataFolder);
    files = extractfield(filesStruct, 'name')';
    % Get rid of the current folder and previous folder links
    files = setdiff(files, '.');
    files = setdiff(files, '..');

    % Checks to see if there are some files with non-acceptable extensions
    % This is only to find images that downloaded without trouble but had a
    % weird URL that didn't end with only the image filename.
    for i = 1:numel(files)
        found = 0;
        file = lower(files{i});
        
        for j = 1:numel(options.imgTypes)
            if ( isempty(strfind(file, options.imgTypes{j})) == 0 )
                found = 1;
            end
        end
        
        if (found == 0)
            badFilenames = [badFilenames; files(i)];
        end

    end

end