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

function pose = GetSkeletonPose(box, parent)

    pose = zeros(14, 2);
    % Maps from Y&R "child" number
    % to Stickman pose array index
    % for (x2,y2) variables. Use special case
    % to get top of head.
    poseChildIdxs = [...
        2,  2; ...
        3,  6; ...
        5,  7; ...
        7,  8; ...
        10,  9; ...
        12, 10; ...
        14, 11; ...
        15,  3; ...
        17,  4; ...
        19,  5; ...
        22, 12; ...
        24, 13; ...
        26, 14;
        ];

    if ~isempty(box)
        numparts = length(parent);
        box = box(:,1:4*numparts);
        xy = reshape(box,size(box,1),4,numparts);
        xy = permute(xy,[1 3 2]);
        for n = 1:size(xy,1)
            x1 = xy(n,:,1); y1 = xy(n,:,2); x2 = xy(n,:,3); y2 = xy(n,:,4);
            x = (x1+x2)/2; y = (y1+y2)/2;
            for child = 2:numparts

                x1 = x(parent(child));
                y1 = y(parent(child));
                x2 = x(child);
                y2 = y(child);

                convertIdx = find ( child == poseChildIdxs(:, 1) );
                if ( ~isempty(convertIdx) )
                    poseIdx = poseChildIdxs(convertIdx, 2);

                    if (poseIdx == 2) % neck
                        pose(1, :) = [x1, y1]; % grab head info
                    end
                    pose(poseIdx, :) = [x2, y2];
                end
            end
        end
    end
end
