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

function options = CreateOptionsLocal(options)

    options.parseAMTFile        = 1;
    options.processWhoIsWhoData = 1;
    
    % who is who - 1 = blonde, 2 = brown; blonde is always person one in
    % original clipart data

    %% Specifying the directory structure for the data
    options.inputFolder         = options.foldersLocal{options.idxINTERACTClipInstWho}{options.idxDataInput};
    options.outputFolder        = options.foldersLocal{options.idxINTERACTClipInstWho}{options.idxDataOutput};
    
    options.AMTFile           = fullfile(options.outputFolder, 'parsed_amt_data.mat');

    %% Specifying the input file
    options.AMTInput     = options.fileINTERACTAMTClipInstWho;
    
    %% Specifying the output file
    options.whoIsWhoFile = options.fileINTERACTClipInstWho;
    
end