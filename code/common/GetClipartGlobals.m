%GETCLIPARTGLOBALS Create options for AMT rendering pipeline.
%  clipartStruct = GetClipartGlobals(options) returns an options struct 
%  that contains the important data for the pipeline (e.g., folder paths, 
%  names of output, etc.).
%
%  INPUT
%    -options:      Struct containing all configuration data (i.e., from
%                   createOptions.m . Mainly for clipart image directory
%                   and background image filename.
%
%  OUTPUT
%    -clipartStruct:   Struct containing clipart specific information, such as
%                      image directory, render order, offsets, etc.
%                      Most of this information is copied from the HTML file.
%
%   Author: Stanislaw Antol (santol@vt.edu)                Date: 2014-08-18

function clipartStruct = GetClipartGlobals(options)

%% Data pertaining to general layout
    clipartStruct.imgDirectory = options.clipartImgDir;
    clipartStruct.background   = options.backgroundImgName;
    
    clipartStruct.personScale = 0.4;
    clipartStruct.height      = 400;
    clipartStruct.width       = 500;

    clipartStruct.renderOrder = [0 13,14,7,9,11,8,10,12,1,3,5,2,4,6]+1; %0Indexing to 1indexing
    
    clipartStruct.headIdx = 13+1;
    clipartStruct.hairIdx = 14+1;
    
    parentMap(0+1)  = -1;
    parentMap(1+1)  =  0;
    parentMap(2+1)  =  0;
    parentMap(3+1)  =  1;
    parentMap(4+1)  =  2;
    parentMap(5+1)  =  3;
    parentMap(6+1)  =  4;
    parentMap(7+1)  =  0;
    parentMap(8+1)  =  0;
    parentMap(9+1)  =  7;
    parentMap(10+1) =  8;
    parentMap(11+1) =  9;
    parentMap(12+1) = 10;
    parentMap(13+1) =  0;
    parentMap(14+1) = 13;

    clipartStruct.parentMap = parentMap + 1; % MATLAB indexing...

%% Loading all of the image filenames
    clipartStruct.manYPoseFiles = {...
        ('PaperMan01TorsoClothed0.png'); ...
        ('PaperMan01RightSleeveClothed0.png'); ...
        ('PaperMan01LeftSleeveClothed0.png'); ...
        ('PaperMan01RightArmBottom0.png'); ...
        ('PaperMan01LeftArmBottom0.png');...
        ('PaperMan01RightHand0.png');...
        ('PaperMan01LeftHand0.png');...
        ('PaperMan01RightThighClothed0.png');...
        ('PaperMan01LeftThighClothed0.png');...
        ('PaperMan01RightCalfClothed0.png');...
        ('PaperMan01LeftCalfClothed0.png');...
        ('PaperMan01RightFoot0.png');...
        ('PaperMan01LeftFoot0.png');...
        ('NeutralMan0104.png');...
        ('HairMens0103.png');...
        };
    
    clipartStruct.manBPoseFiles = {...
        ('PaperMan01TorsoClothed0.png'); ...
        ('PaperMan01RightSleeveClothed0.png'); ...
        ('PaperMan01LeftSleeveClothed0.png'); ...
        ('PaperMan01RightArmBottom0.png'); ...
        ('PaperMan01LeftArmBottom0.png');...
        ('PaperMan01RightHand0.png');...
        ('PaperMan01LeftHand0.png');...
        ('PaperMan01RightThighClothed0.png');...
        ('PaperMan01LeftThighClothed0.png');...
        ('PaperMan01RightCalfClothed0.png');...
        ('PaperMan01LeftCalfClothed0.png');...
        ('PaperMan01RightFoot0.png');...
        ('PaperMan01LeftFoot0.png');...
        ('NeutralMan0104.png');...
        ('HairMens0101.png');...
        };

    clipartStruct.womanYPoseFiles = {...
        ('PaperWoman01TorsoClothed0.png');...
        ('PaperWoman01RightSleeveClothed0.png');...
        ('PaperWoman01LeftSleeveClothed0.png');...
        ('PaperWoman01RightArmBottom0.png');...
        ('PaperWoman01LeftArmBottom0.png');...
        ('PaperWoman01RightHand0.png');...
        ('PaperWoman01LeftHand0.png');...
        ('PaperWoman01RightThighClothed0.png');...
        ('PaperWoman01LeftThighClothed0.png');...
        ('PaperWoman01RightCalfClothed0.png');...
        ('PaperWoman01LeftCalfClothed0.png');...
        ('PaperWoman01RightFoot0.png');...
        ('PaperWoman01LeftFoot0.png');...
        ('NeutralWoman0104.png');...
        ('WomensHair0401.png');...
        };
    
    clipartStruct.womanBPoseFiles = {...
        ('PaperWoman01TorsoClothed0.png');...
        ('PaperWoman01RightSleeveClothed0.png');...
        ('PaperWoman01LeftSleeveClothed0.png');...
        ('PaperWoman01RightArmBottom0.png');...
        ('PaperWoman01LeftArmBottom0.png');...
        ('PaperWoman01RightHand0.png');...
        ('PaperWoman01LeftHand0.png');...
        ('PaperWoman01RightThighClothed0.png');...
        ('PaperWoman01LeftThighClothed0.png');...
        ('PaperWoman01RightCalfClothed0.png');...
        ('PaperWoman01LeftCalfClothed0.png');...
        ('PaperWoman01RightFoot0.png');...
        ('PaperWoman01LeftFoot0.png');...
        ('NeutralWoman0104.png');...
        ('WomensHair0403.png');...
        };

    clipartStruct.manExpFiles = {...
        ('NeutralMan0104.png')...
        ('HappyMan0104.png')...;
        ('ShockedMan0104.png')...;
        ('ScaredMan0104.png')...;
        ('SadMan0104.png')...;
        ('DisgustedMan0104.png')...;
        ('AngryMan0104.png')...;
        };

    clipartStruct.womanExpFiles = {...
        ('NeutralWoman0104.png')...
        ('HappyWoman0104.png')...
        ('ShockedWoman0104.png')...
        ('ScaredWoman0104.png')...
        ('SadWoman0104.png')...
        ('DisgustedWoman0104.png')...
        ('AngryWoman0104.png')...;
        };

%% Setting the x0/x1/y0/y1 pose data (values taken from HTML file)
    lenRenderOrder = length(clipartStruct.renderOrder);
    x1PoseMan = zeros(lenRenderOrder, 1);
    y1PoseMan = zeros(lenRenderOrder, 1);
    x0PoseMan = zeros(lenRenderOrder, 1);
    y0PoseMan = zeros(lenRenderOrder, 1);

    x1PoseWoman = zeros(lenRenderOrder, 1);
    y1PoseWoman = zeros(lenRenderOrder, 1);
    x0PoseWoman = zeros(lenRenderOrder, 1);
    y0PoseWoman = zeros(lenRenderOrder, 1);
    
    x1PoseMan(0+1) = 57;
    y1PoseMan(0+1) = 128;
    x1PoseMan(1+1) = 26;
    y1PoseMan(1+1) = 19;
    x1PoseMan(2+1) = 13;
    y1PoseMan(2+1) = 17;
    x1PoseMan(3+1) = 14;
    y1PoseMan(3+1) = 10;
    x1PoseMan(4+1) = 14;
    y1PoseMan(4+1) = 9;
    x1PoseMan(5+1) = 16;
    y1PoseMan(5+1) = 12;
    x1PoseMan(6+1) = 26;
    y1PoseMan(6+1) = 12;
    x1PoseMan(7+1) = 33;
    y1PoseMan(7+1) = 24;
    x1PoseMan(8+1) = 34;
    y1PoseMan(8+1) = 24;
    x1PoseMan(9+1) = 19;
    y1PoseMan(9+1) = 20;
    x1PoseMan(10+1) = 22;
    y1PoseMan(10+1) = 20;
    x1PoseMan(11+1) = 42;
    y1PoseMan(11+1) = 21;
    x1PoseMan(12+1) = 42;
    y1PoseMan(12+1) = 21;
    x1PoseMan(13+1) = 48;
    y1PoseMan(13+1) = 102;
    x1PoseMan(14+1) = 59;
    y1PoseMan(14+1) = 45;

    x0PoseMan(0+1) = 0;
    y0PoseMan(0+1) = 0;
    x0PoseMan(1+1) = 16;
    y0PoseMan(1+1) = 46;
    x0PoseMan(2+1) = 96;
    y0PoseMan(2+1) = 44;
    x0PoseMan(3+1) = 24;
    y0PoseMan(3+1) = 128;
    x0PoseMan(4+1) = 16;
    y0PoseMan(4+1) = 128;
    x0PoseMan(5+1) = 19;
    y0PoseMan(5+1) = 98;
    x0PoseMan(6+1) = 21;
    y0PoseMan(6+1) = 99;
    x0PoseMan(7+1) = 34;
    y0PoseMan(7+1) = 213;
    x0PoseMan(8+1) = 80;
    y0PoseMan(8+1) = 213;
    x0PoseMan(9+1) = 28;
    y0PoseMan(9+1) = 160;
    x0PoseMan(10+1) = 39;
    y0PoseMan(10+1) = 165;
    x0PoseMan(11+1) = 20;
    y0PoseMan(11+1) = 147;
    x0PoseMan(12+1) = 19;
    y0PoseMan(12+1) = 149;
    x0PoseMan(13+1) = 54;
    y0PoseMan(13+1) = 12;
    x0PoseMan(14+1) = 43;
    y0PoseMan(14+1) = 17;

    x1PoseWoman(0+1) = 56;
    y1PoseWoman(0+1) = 118;
    x1PoseWoman(1+1) = 21;
    y1PoseWoman(1+1) = 17;
    x1PoseWoman(2+1) = 18;
    y1PoseWoman(2+1) = 17;
    x1PoseWoman(3+1) = 12;
    y1PoseWoman(3+1) = 17;
    x1PoseWoman(4+1) = 10;
    y1PoseWoman(4+1) = 16;
    x1PoseWoman(5+1) = 14;
    y1PoseWoman(5+1) = 11;
    x1PoseWoman(6+1) = 18;
    y1PoseWoman(6+1) = 10;
    x1PoseWoman(7+1) = 25;
    y1PoseWoman(7+1) = 18;
    x1PoseWoman(8+1) = 23;
    y1PoseWoman(8+1) = 18;
    x1PoseWoman(9+1) = 16;
    y1PoseWoman(9+1) = 20;
    x1PoseWoman(10+1) = 15;
    y1PoseWoman(10+1) = 20;
    x1PoseWoman(11+1) = 28;
    y1PoseWoman(11+1) = 17;
    x1PoseWoman(12+1) = 28;
    y1PoseWoman(12+1) = 17;
    x1PoseWoman(13+1) = 48;
    y1PoseWoman(13+1) = 102;
    x1PoseWoman(14+1) = 62;
    y1PoseWoman(14+1) = 51;

    x0PoseWoman(0+1) = 0;
    y0PoseWoman(0+1) = 0;
    x0PoseWoman(1+1) = 16;
    y0PoseWoman(1+1) = 46;
    x0PoseWoman(2+1) = 94;
    y0PoseWoman(2+1) = 46;
    x0PoseWoman(3+1) = 18;
    y0PoseWoman(3+1) = 113;
    x0PoseWoman(4+1) = 20;
    y0PoseWoman(4+1) = 111;
    x0PoseWoman(5+1) = 17;
    y0PoseWoman(5+1) = 85;
    x0PoseWoman(6+1) = 16;
    y0PoseWoman(6+1) = 84;
    x0PoseWoman(7+1) = 24;
    y0PoseWoman(7+1) = 185;
    x0PoseWoman(8+1) = 84;
    y0PoseWoman(8+1) = 185;
    x0PoseWoman(9+1) = 24;
    y0PoseWoman(9+1) = 158;
    x0PoseWoman(10+1) = 29;
    y0PoseWoman(10+1) = 158;
    x0PoseWoman(11+1) = 21;
    y0PoseWoman(11+1) = 127;
    x0PoseWoman(12+1) = 20;
    y0PoseWoman(12+1) = 130;
    x0PoseWoman(13+1) = 58;
    y0PoseWoman(13+1) = 9;
    x0PoseWoman(14+1) = 35;
    y0PoseWoman(14+1) = 23;

    clipartStruct.x0PoseMan = x0PoseMan;
    clipartStruct.y0PoseMan = y0PoseMan;
    clipartStruct.x1PoseMan = x1PoseMan;
    clipartStruct.y1PoseMan = y1PoseMan;

    clipartStruct.x0PoseWoman = x0PoseWoman;
    clipartStruct.y0PoseWoman = y0PoseWoman;
    clipartStruct.x1PoseWoman = x1PoseWoman;
    clipartStruct.y1PoseWoman = y1PoseWoman;
    
end