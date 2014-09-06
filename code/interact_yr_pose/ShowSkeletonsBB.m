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

% Modified from the original showskeletons.m file from the YR detector
function ShowSkeletonsBB(img, boxes, partcolor, parent, minIdxs, maxIdxs)

xIdxs = minIdxs(1):maxIdxs(1);
yIdxs = minIdxs(2):maxIdxs(2);
    
imshow(img); axis image; axis off; hold on;

rectangle('position', ...
          [minIdxs(1), minIdxs(2), (maxIdxs(1)-minIdxs(1)), (maxIdxs(2)-minIdxs(2))], ...
          'LineWidth', 3, 'EdgeColor', 'r')

if ~isempty(boxes)
  numparts = length(partcolor);
  box = boxes(:,1:4*numparts);
  xy = reshape(box,size(box,1),4,numparts);
  xy = permute(xy,[1 3 2]);
  for n = 1:size(xy,1)
    x1 = xy(n,:,1) + minIdxs(1); y1 = xy(n,:,2) + minIdxs(2);
    x2 = xy(n,:,3) + minIdxs(1); y2 = xy(n,:,4) + minIdxs(2);
    x = (x1+x2)/2; y = (y1+y2)/2;
    for child = 2:numparts
      x1 = x(parent(child));
      y1 = y(parent(child));
      x2 = x(child);
      y2 = y(child);
      line([x1 x2],[y1 y2],'color',partcolor{child},'linewidth',4);
    end
  end
end

end