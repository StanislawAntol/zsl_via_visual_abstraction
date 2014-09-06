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

function model = InitYRCode(options)
    currentFolder = pwd;

    YRPosePath = fullfile(options.folders3rdParty{options.idxYRPose}, '..', 'code-basic');

    addpath(YRPosePath);
    addpath(fullfile(YRPosePath, 'visualization'));

    if isunix()
        addpath(fullfile(YRPosePath,  'mex_unix'));
    elseif ispc()
        addpath(fullfile(YRPosePath,  'mex_pc'));
    end

    cd(YRPosePath)
    compile;
    cd(currentFolder)

    % % load and display model
    if ( options.usePARSEModel ~= 0 )
        load('PARSE_model')
    else
        load('BUFFY_model'); % ONLY UPPER BODY
    end

    % load('renamedParseModel.mat');
    % visualizemodel(PARSEModel);
    % disp('model template visualization');
    % disp('press any key to continue');
    % % pause;
    % visualizeskeleton(PARSEModel);
    % disp('model tree visualization');
    % disp('press any key to continue');
    % pause;
end