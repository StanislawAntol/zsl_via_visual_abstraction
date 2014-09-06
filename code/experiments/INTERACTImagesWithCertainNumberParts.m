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

function imgsWithEnoughParts = INTERACTImagesWithCertainNumberParts(options, parameters)

    posesFile = options.fileINTERACTImgPoseDataGT1;
    
    poses = load(posesFile);
    numImgs = size(poses, 1);
    
    posesP1 = poses(:, 1:2:end/2);
    posesP2 = poses(:, end/2+1:2:end);
    
   numPartsP1 = sum(posesP1 ~= -1, 2);
   numPartsP2 = sum(posesP2 ~= -1, 2);    
   
   imgsWithEnoughParts = zeros( numImgs, options.numParts);
   
   for partThresh = 1:options.numParts
       imgsWithEnoughParts(:, partThresh) = (numPartsP1 >= partThresh) & (numPartsP2 >= partThresh);
   end
   
   numImgsPerThresh = sum(imgsWithEnoughParts, 1)';
   percentagePerThresh = 100*numImgsPerThresh/numImgs;
   
   fprintf('Both people have at least this many parts visible.\n');
   fprintf('# Parts'); fprintf('%5d,', 1:options.numParts); fprintf('\n');
   fprintf('# Imgs  '); fprintf('%5d,', numImgsPerThresh); fprintf('\n');
   fprintf('%% Imgs  '); fprintf('%5.1f,', percentagePerThresh'); fprintf('\n');

%    fprintf('\n');
% 
%    for i = 1:options.numParts
%        fprintf('%d & %d & %5.1f\\\\ \\cline{1-3} \n', i, numImgsPerThresh(i), percentagePerThresh(i));
%    end
   
end