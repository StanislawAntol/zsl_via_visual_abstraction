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

addpath(fullfile('..', 'common'));

options = CreateOptionsGlobal();

options.readParsedData            = 1;
options.processHumanAgreementData = 1;
options.isReal                    = 1;
parameters.seedVal = 9781;

resultsFileDir = fullfile(options.foldersLocal{options.idxINTERACTImgHumanAgr}{options.idxDataInput});
outputDirBase  = fullfile(options.foldersLocal{options.idxINTERACTImgHumanAgr}{options.idxDataOutput});
if ~exist(resultsFileDir, 'dir')
    mkdir(resultsFileDir);
end
if ~exist(outputDirBase, 'dir')
    mkdir(outputDirBase);
end

origData = readtext(options.fileInitDatasetInfo, ';', '', '', 'textual-empty2zero');
imgFilenames = origData(:, 2);
imgLabels    = str2double(origData(:, 1));

if ( options.isReal ~= 0 )
    options.prename              = 'https://filebox.ece.vt.edu/~santol/pose_clipart/data/output/image_collection/full_exp_1/foundImgs/'; % Remove URL in 'Results' filenames
    options.readFile             = options.fileINTERACTAMTImgHumanAgr;
    options.saveNameParsed       = fullfile(outputDirBase, 'interact_img_parsed_data.mat');
    options.saveNameFilteredData = options.fileINTERACTImgHumanAgr;
else
    options.prename = 'https://filebox.ece.vt.edu/~santol/pose_clipart/data/output/clipart_collection/full_exp_1/renderedImgs/';
    options.readFile             = options.fileINTERACTAMTClipCatHumanAgr;
    options.saveNameParsed       = fullfile(outputDirBase, 'interact_clipart_category_parsed_data.mat');
    options.saveNameFilteredData = options.fileINTERACTClipCatHumanAgr;
end

ProcessAMTHumanAgreementData(options, parameters, imgFilenames, imgLabels);