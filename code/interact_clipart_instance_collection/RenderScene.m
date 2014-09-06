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

function finalImg = RenderScene(options, scene)

    %% Load configuration data
    dollDataStruct = options.clipartInterfaceGlobals;
    
    %% Load background image
    bgImg = imread([dollDataStruct.imgDirectory dollDataStruct.background]);
    bgImg = bgImg(1:dollDataStruct.height,1:dollDataStruct.width, :);

    %% Display background image
    h = imshow(bgImg);
    hold on;
    set(h,'Tag','export_fig_native');
    title(scene.img, 'FontSize', 24);
    
    %% Process and display the clipart man first (same order as HTML)
    xPosePersonA = scene.pAPose(:, 1);
    yPosePersonA = scene.pAPose(:, 2);
    rPosePersonA = scene.pAPose(:, 3);
    personAExpr  = scene.pAExp;
    personAFlip  = scene.pAFlip;
    hair = 0;
    if ( scene.pAGend == 0 )
        woman = 0;
    else
        woman = 1;
    end

    processPerson(dollDataStruct, hair, woman, ...
                  xPosePersonA, yPosePersonA, rPosePersonA, personAExpr, personAFlip);

    %% Process and display the clipart woman second (same order as HTML)
    xPosePersonB = scene.pBPose(:, 1);
    yPosePersonB = scene.pBPose(:, 2);
    rPosePersonB = scene.pBPose(:, 3);
    personBExpr  = scene.pBExp;
    personBFlip  = scene.pBFlip;
    hair = 1;
    if ( scene.pBGend == 0 )
        woman = 0;
    else
        woman = 1;
    end

    processPerson(dollDataStruct, hair, woman, ...
                  xPosePersonB, yPosePersonB, rPosePersonB, personBExpr, personBFlip);

    hold off
    
    %% Extract the image data from the figure
	imgFrame = getframe();
    finalImg = imgFrame.cdata;
    
    % SA: THIS IS A HACK! (I.e., I don't know why it (e.g., using 2s) works.)
    % Might need to redo for other sized images...
    finalImg = finalImg((1:dollDataStruct.height)+1, (1:dollDataStruct.width)+1, :);

end

% % Helper function to process a person
% % INPUT
% % -dollDataStruct: the struct from getDollGlobals (containing relevant
% %                  data).
% % -hair:           0 for Yellow/blonde, 1 for Brown
% % -woman:          0 for man, 1 for woman
% % -xPose:          15x1 vector containing the person's x- pose data (for
% %                  all clipart pieces.
% % -yPose:          15x1 vector containing the person's y- pose data (for
% %                  all clipart pieces.
% % -rPose:          15x1 vector containing the person's rotation data (for
% %                  all clipart pieces.
% % -expr:           index for which face expression image to use
% % -flip:           0 for not flip, 1 for flip (same as HTML page)
% % OUTPUT
% % NONE, only side effects (i.e., plotting)
function processPerson(dollDataStruct, hair, woman, xPose, yPose, rPose, expr, flip)

    numParts = numel(dollDataStruct.renderOrder);
    xScale = dollDataStruct.personScale;
    yScale = dollDataStruct.personScale;

    for i = 1:numParts

        idx = dollDataStruct.renderOrder(i);

        %% Loads the correct image for the part
        if (idx ~= dollDataStruct.headIdx)
            if (woman == 0)
                if ( hair == 0 ) % Yellow/blonde
                    [part, ~, alph] = imread([dollDataStruct.imgDirectory, dollDataStruct.manYPoseFiles{idx}] );
                else % Brown
                    [part, ~, alph] = imread([dollDataStruct.imgDirectory, dollDataStruct.manBPoseFiles{idx}] );
                end
            else % (woman == 1)
                if ( hair == 0 ) % Yellow/blonde
                    [part, ~, alph] = imread([dollDataStruct.imgDirectory, dollDataStruct.womanYPoseFiles{idx}] );
                else % Brown
                    [part, ~, alph] = imread([dollDataStruct.imgDirectory, dollDataStruct.womanBPoseFiles{idx}] );
                end
            end
        else
            if (woman == 0)
                [part, ~, alph] = imread([dollDataStruct.imgDirectory, dollDataStruct.manExpFiles{expr}] );
            else % (woman == 1)
                [part, ~, alph] = imread([dollDataStruct.imgDirectory, dollDataStruct.womanExpFiles{expr}] );
            end        
        end

        %% X1 contains the local offset of the part
        if (woman == 0)
            X1 = [-dollDataStruct.x1PoseMan(idx);
                  -dollDataStruct.y1PoseMan(idx);];
        else % (woman == 1)
            X1 = [-dollDataStruct.x1PoseWoman(idx);
                  -dollDataStruct.y1PoseWoman(idx);];        
        end

        %% X contains the global position of the part
        X = [xPose(idx);
             yPose(idx);];

        [newPart, xData, yData] = transformForRendering(part, X1, X, rPose(idx), flip, xScale, yScale );
        
        %% Places the new_part image in the correct position
        h = imshow(newPart,...
            'XDATA', xData,...
            'YDATA', yData);


        %% Makes sure the alpha values are correct (for transparency)
        [newAlph, xData, yData] = transformForRendering(alph, X1, X, rPose(idx), flip, xScale, yScale );
        set(h,'alphaData', newAlph, ...
            'XDATA', xData,...
            'YDATA', yData);
        
    end
end

% % Helper function to deal with transforming the images like in the HTML
% % INPUT
% % -imgIn:          Input (color) image (i.e, clipart part)
% % -X1:             2x1 vector of the part's local offset (x,y)
% % -X1:             2x1 vector of the part's global offset (x,y)
% % -rad:            global rotation of the part in radians
% % -flip:           binary value to flip about the vertical axis
% % -xScale:         how much to scale the x-dimension
% % -yScale:         how much to scale the y-dimension
% % OUTPUT
% % -imgOut:         Output (color) transformed image 
% %                  (i.e., transformed clipart part)
% % -xData:          2x1 vector containing the x-axis start and end for
% %                  imshow
% % -yData:          2x1 vector containing the y-axis start and end for
% %                  imshow
function [imgOut, xData, yData] = transformForRendering(imgIn, X1, X, rad, flip, xScale, yScale)

    S = [xScale 0 0; 0 yScale 0; 0 0 1];
    if (flip == 0)
        T1 = [1 0 0; 0 1 0; X1(1) X1(2) 1]; % Translation matrix
        T2 = [1 0 0; 0 1 0; X(1)  X(2) 1];
        R  = [cos(rad) sin(rad) 0; -sin(rad) cos(rad) 0; 0 0 1]; % Rotation matrix
        % This is the same order of transformations from HTML file
        tform = maketform('affine', T1*R*T2*S);
    else % (flip == 1)
        T1 = [1 0 0; 0 1 0; X1(1) X1(2) 1]; % Translation matrix
        T2 = [1 0 0; 0 1 0; -X(1)  X(2) 1];
        R  = [cos(-rad) sin(-rad) 0; -sin(-rad) cos(-rad) 0; 0 0 1]; % Rotation matrix
        
        F  = [-1 0 0; 0 1 0; 0 0 1];
        % This is the same order of transformations from HTML file
        tform = maketform('affine', T1*R*T2*S*F);
    end
    
    [imgOut, xData, yData] = imtransform(imgIn, tform);

end