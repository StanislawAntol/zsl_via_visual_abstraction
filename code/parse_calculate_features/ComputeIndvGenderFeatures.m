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

function ComputeIndvGenderFeatures(options, avgPoseTasksGender)

    genderList = options.gendList;
    numGenders = numel(genderList);
        
    genderFeat1 = zeros(numel(avgPoseTasksGender), numGenders);
    
    for i = 1:numel(avgPoseTasksGender)
        
        avgPoseTask = avgPoseTasksGender(i);

        genders = avgPoseTask.gender;

        genderBinary1 = genders == genderList;
        
        genderFeat1(i, :) = genderBinary1;
        
    end

    dlmwrite(options.filePARSEImgGendDataGT1, genderFeat1, ';');

end