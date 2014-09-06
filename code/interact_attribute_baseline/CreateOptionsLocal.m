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

    %% Which parts of the process to run
    options.parseAMTFile            = 1;
    options.filterApproved          = 1;
    options.processData1            = 1;
    options.createHTML              = 0;
    
    options.filterLabel     = 'Approved';
    
    % Number of sentences per HIT
    options.numSents = 3;
    
    options.exprNames = {'neutral', 'happy', 'shocked', 'scared', 'sad', 'disgusted', 'angry'};
    
    options.firstLetter = {'A', 'B'};
    options.secondLetter = {'H', 'E', 'K', 'F'};
    options.limbNames = {'hand', 'elbow', 'knee', 'foot'};
    options.jointNames = {'head', 'shoulder', 'elbow', 'hand', 'hip', 'knee', 'foot'};

    %% Specifying the directory structure for the data
    options.inputFolder  = options.foldersLocal{options.idxINTERACTAttr}{options.idxDataInput};
    options.outputFolder = options.foldersLocal{options.idxINTERACTAttr}{options.idxDataOutput};

    %% Specifying the input file
    options.AMTFile  = options.fileINTERACTAMTImgAttrBL;
    options.verbFile = options.fileINTERACTVerbList;
    
    %% Specifying the MATLAB file for the parsed input (i.e., .results->.mat w/ struct)
    options.outDataFile         = fullfile(options.outputFolder, 'parsed_amt_data.mat');
    
    options.originalLabelingFile = options.fileINTERACTClipCatLabelData;
    options.saveModelDAPFormatStr   = '%s_datasetID_%d_trainP_%06.2f_curSeedVal_%d_featSet_%s_classifier_DAP';

end