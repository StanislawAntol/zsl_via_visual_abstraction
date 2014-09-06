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

function finalImg = RenderPose(options, poseTasks, withoutHead, bothPoses)

%     head = [1, 2];
%     torso = [3, 6, 9, 12];
%     leftArm = [4, 5];
%     rightArm = [7, 8];
%     leftLeg = [13, 14];
%     rightLeg = [10, 11];
    if ( withoutHead ~= 0 )
        startIdx = 2;
        partParent = options.partParent;
        partParent{2} = []; % Simple fix to stop rendering head
    else
        startIdx = 1;
        partParent = options.partParent;
    end

    if ( bothPoses == 0 )
        markers = { ...
                    'og';...
                    'og';...
                    'oy';...
                    'oc';...
                    'oc';...
                    'oy';...
                    'om';...
                    'om';...
                    'oy';...
                    'or';...
                    'or';...
                    'oy';...
                    'ob';...
                    'ob';...
                    };
    else
        markers = { ...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    'or', 'ob';...
                    };

    end
    
    lineColor{1} = [1, 0, 0];
    lineColor{2} = [0, 0, 1];
    
    h = figure(1);
    img = LoadAnyImgAsRGB(options.imgDir, poseTasks(1).img);
    h = imshow(img);
% %     set(0,'DefaultFigureVisible','off');
    
    hold on
    for k = 1:numel(poseTasks)
        poseTask = poseTasks(k);
        for i = startIdx:size(poseTask.pose, 1)
            if ( poseTask.occluded(i) == 0 )
                                
                if ( bothPoses == 0)
                    h = plot(poseTask.pose(i, 1), poseTask.pose(i, 2), markers{i, k}, 'LineWidth', 3);
                end
                parent = partParent{i};
%                 set(gcf,'renderer','opengl');
                for j = 1:length(parent)

                    if ( ~poseTask.occluded(parent(j)) )
                        X = [poseTask.pose(i, 1), poseTask.pose(parent(j), 1)];
                        Y = [poseTask.pose(i, 2), poseTask.pose(parent(j), 2)];
                        if ( bothPoses == 0 )
                            h = line(X, Y, 'LineWidth', 2, 'Color', lineColor{k});
                        else
                            xflip = [X(1:end-1) fliplr(X)];
                            yflip = [Y(1:end-1) fliplr(Y)];
                            patch(xflip, yflip, 'r', 'EdgeColor', lineColor{k}, 'EdgeAlpha', 0.35, 'LineWidth', 2);
                        end
                    end
                end
            end
        end        
    end
    hold off
%     set(h,'visible','off');
    
%     pause(.05);
    
    %% Extract the image data from the figure
    imgFrame = getframe();
    finalImg = imgFrame.cdata;
%     set(h,'visible','off');
%     set(0,'DefaultFigureVisible','on');

end