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
    [taskAMT, taskData] = ProcessRetrievalClipartWhoIsWhoResultsData(options);
    save(options.AMTFile, 'taskAMT', 'taskData');
else
    load(options.AMTFile); % Loads already processed taskAMT, taskData
end


if ( options.processWhoIsWhoData ~= 0 )
    % Save to file
    ProcessRetrievalClipartWhoIsWhoData(options, taskAMT, taskData);
end