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
    options.createGTPoseFiles    = 1;
    options.createYRPoseFiles    = 1;
    options.calculateGTPoseFeats = 1;
    options.calculateYRPoseFeats = 1;
    options.calculateExprFeats   = 1;
    options.calculateGazeFeats   = 1;
    options.calculateGenderFeats = 1; 
    
%     options.seed = RandStream('mt19937ar','Seed', 730);
%     options.seedVal = 1;

    options.visualize = 0;
    options.numPeople = 1;
    options.numParts = 14;
    options.isReal = 1;
    options.numPoses = 1;
    options.imgNameZeroPad = 2;
    options.annotateImgExt = 'jpg';
    options.verbFile = options.filePARSEVerbList;
    
    options.PARSEGT2Stickman = [ ...
                        14, ... % Head
                        13, ... % Neck
                        10, ... % Left Shoulder
                        11, ... % Left Elbow
                        12, ... % Left Wrist
                         9, ... % Right Shoulder
                         8, ... % Right Elbow
                         7, ... % Right Wrist
                         3, ... % Right Hip
                         2, ... % Right Knee
                         1, ... % Right Ankle
                         4, ... % Left Hip
                         5, ... % Left Knee
                         6, ... % Left Ankle
                        ];

end