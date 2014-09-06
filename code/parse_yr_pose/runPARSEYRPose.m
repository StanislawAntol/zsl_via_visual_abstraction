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

% Mostly taken from the Yang and Ramanan demo code

absCommonPath = fullfile(cd(cd('..')), 'common');
addpath(absCommonPath);

options = CreateOptionsGlobal();

pretrainedPARSEModel = fullfile(options.folders3rdParty{options.idxYRPose}, '..', 'code-basic', 'PARSE_model.mat');

curDir = pwd;

cd(options.folders3rdParty{options.idxYRPose});

globals();
addpath PARSE;

name = 'PARSE';

% --------------------
% specify model parameters
% number of mixtures for 26 parts
K = [6 6 6 6 6 6 6 6 6 6 6 6 6 6 ...
    6 6 6 6 6 6 6 6 6 6 6 6];
% Tree structure for 26 parts: pa(i) is the parent of part i
% This structure is implicity assumed during data preparation
% (PARSE_data.m) and evaluation (PARSE_eval_pcp)
pa = [0 1 2 3 4 5 6 3 8 9 10 11 12 13 2 15 16 17 18 15 20 21 22 23 24 25];
% Spatial resolution of HOG cell, interms of pixel width and hieght
% The PARSE dataset contains low-res people, so we use low-res parts
sbin = 4;
% --------------------
% Prepare training and testing images and part bounding boxes
% You will need to write custom *_data() functions for your own dataset
[pos neg test] = PARSE_data(name);

% On both test AND train, although train would be "cheating"
% But we don't use train images in our testing anyway.
parseImgs = [pos(1:100) test]; 
% pos = point2box(pos,pa);
% --------------------
% training
% model = trainmodel(name,pos,neg,K,pa,sbin);
%load('../code-basic/PARSE_model.mat');
load(pretrainedPARSEModel);

% --------------------
% testing phase 1
% human detection + pose estimation
suffix = num2str(K')';
model.thresh = min(model.thresh, -2);
boxes = testmodel(name, model,parseImgs, suffix);
det = PARSE_transback(boxes);

visualize = 0;

parsePosesYR = [];

for demoimid = 1:length(parseImgs)
    
    fprintf('demoid: %03d\n', demoimid);
    
    box = boxes{demoimid};
    if ( visualize )
        
        im = imread(parseImgs(demoimid).im);
        colorset = {'g','g','y','r','r','r','r','y','y','y','m','m','m','m','y','b','b','b','b','y','y','y','c','c','c','c'};
        
        % show all detections
        figure(3);
        clf
        subplot(1,2,1); showboxes(im,box(1,:),colorset);
        subplot(1,2,2); showskeletons(im,box(1,:),colorset,model.pa);
        
    end
    pose =  GetSkeletonPose(box, model.pa);
    YRpose.img = parseImgs(demoimid).im;
    YRpose.pose = pose;
    
    parsePosesYR = [parsePosesYR; YRpose];

    if ( visualize )
        pause();
    end
end

cd(curDir);

save(options.fileYRPARSEYRPose, 'parsePosesYR');