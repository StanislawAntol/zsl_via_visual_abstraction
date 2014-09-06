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

function ComputeGenderFeatures(options, avgPoseTasksGender)
    
    genderList = options.gendList;
    numGenders = numel(genderList);
        
    genderFeat1 = zeros(numel(avgPoseTasksGender), 2*numGenders);
    genderFeat2 = zeros(numel(avgPoseTasksGender), 2*numGenders);
    
    for i = 1:numel(avgPoseTasksGender)
        
        avgPoseTask = avgPoseTasksGender(i);

        genders = avgPoseTask.gender;

        genderBinary1 = genders(1) == genderList;
        genderBinary2 = genders(2) == genderList;
        
        genderFeat1(i, :) = [genderBinary1, genderBinary2];
        genderFeat2(i, :) = [genderBinary2, genderBinary1];
        
    end

    dlmwrite(options.fileINTERACTImgGendDataGT1, genderFeat1, ';');
    dlmwrite(options.fileINTERACTImgGendDataGT2, genderFeat2, ';');

end