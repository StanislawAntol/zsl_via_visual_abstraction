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

% This function tweaks the data to fix a mistake.
% The mistake is from the code that processes the original clipart AMT
% data.
% For two HITs (i.e., the two assignmentids below), somehow the users
% submitted more than 3 entries (i.e., it seems like they realized they
% wanted to fix previous scenes), so they re-did them. Thus, during my
% original processing, I did not take the newest 3 scenes from them, which
% caused us to have 99 and 101 images for two pairs of verbs.
% Thus, the images that human agreement workers saw were not always the
% correct ones. Here, the new ones that human agreement workers didn't see
% are replaced by 'no guess'.
function newChoices = CleanupClipartMistakes(urls, choices)

    errorImgs{1, 1} = '2C21QP6AUC260PJDWWO310FPK0S81A_01.png'; % old '2C21QP6AUC260PJDWWO310FPK0S81A_03.png'
    errorImgs{2, 1} = '2C21QP6AUC260PJDWWO310FPK0S81A_02.png'; % no human agreement
    errorImgs{3, 1} = '2C21QP6AUC260PJDWWO310FPK0S81A_03.png'; % no human agreemnet

    errorImgs{4, 1} = '22C9RJ85OZIZ1QZGTKDOUQ5JGG48WI_01.png'; % old '22C9RJ85OZIZ1QZGTKDOUQ5JGG48WI_02.png'
    errorImgs{5, 1} = '22C9RJ85OZIZ1QZGTKDOUQ5JGG48WI_02.png'; % old '22C9RJ85OZIZ1QZGTKDOUQ5JGG48WI_03.png'
    errorImgs{6, 1} = '22C9RJ85OZIZ1QZGTKDOUQ5JGG48WI_03.png'; % no human agreement

    idxMapping = [3; 0; 0; 5; 6; 0];

    newChoices = choices;

    for i = 1:size(errorImgs, 1)

        [idxRows, idxCols] = find( strcmp( urls, errorImgs{i, 1} ) );
        errorImgs{i, 2} = idxCols(1);
        errorImgs{i, 3} = idxRows;

    end

    for i = 1:size(errorImgs, 1)
        oldIdx = idxMapping(i);
        idxsCurRow = errorImgs{i, 3};
        if ( oldIdx ~= 0 )
            idxsCol = errorImgs{oldIdx, 2};
            idxsOldRow = errorImgs{oldIdx, 3};
            newChoices(idxsCurRow, idxsCol) = choices(idxsOldRow, idxsCol);
        else
            idxsCol = errorImgs{i, 2};
            newChoices(idxsCurRow, idxsCol) = cell(length(idxsCurRow), 1);
        end
    end

end