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

function tasks = ProcessUserScenes(options, taskStruct, resHeaders, resData)

    globals = options.clipartInterfaceGlobals;

    headersWithSents = strfind( resHeaders, 'sent');
    sentsIdxs = find(not(cellfun('isempty', headersWithSents)));
    headersWithPoses = strfind( resHeaders, 'poses');
    posesIdxs = find(not(cellfun('isempty', headersWithPoses)));
    
    inputs = extractfield(taskStruct, 'annotation');

    counter = 1;
    tasks = taskStruct;

    for idxStruct = 1:size(resData, 1)
        tasks(idxStruct).scenes = [];
        inputParts = strsplit(inputs{idxStruct}, '+');
        newScene = struct();
        for idxData = 1:length(posesIdxs);
            dataPosesParts = strsplit(resData{idxStruct, posesIdxs(idxData)}, ',');
            sentence = inputParts{idxData};

            % All below adheres to the answer string provided by the AMT
            % interface HTML file.
            newScene.sent = sentence;
            % r1 is relative rotations, r is in global frame
            newScene.pARD = zeros(numel(globals.renderOrder), 1); % Person A r1 default
            newScene.pASP = zeros(numel(globals.renderOrder), 1); % Person A r1 final
            newScene.pAPose = zeros(numel(globals.renderOrder), 3); % x, y, r

            for k = 2:2:(numel(dataPosesParts)-1)
                vName = dataPosesParts{k};
                numFromFirstStr = str2double(vName(5:end))+1;
                numFromSecondStr = str2double(dataPosesParts{k+1});
                
                    if regexp(vName,'PAgendDef','start')
                    newScene.pAGendDef = numFromSecondStr;
                elseif regexp(vName,'PAgendChange','start')
                    newScene.pAGendChange = numFromSecondStr;
                elseif regexp(vName,'PAgend','start')
                    newScene.pAGend = numFromSecondStr;
                elseif regexp(vName,'PAflipDef','start')
                    newScene.pAFlipDef = numFromSecondStr;
                elseif regexp(vName,'PAflipChange','start')
                    newScene.pAFlipChange = numFromSecondStr;
                elseif regexp(vName,'PAflip','start')
                    newScene.pAFlip = numFromSecondStr;
                elseif regexp(vName,'PAexpDef','start')
                    newScene.pAExpDef = numFromSecondStr+1; %1 Index 
                elseif regexp(vName,'PAexpChange','start')
                    newScene.pAExpChange = numFromSecondStr;
                elseif regexp(vName,'PAexp','start')
                    newScene.pAExp = numFromSecondStr+1; %1 Index    
                elseif regexp(vName,'PArD','start')
                    newScene.pARD(numFromFirstStr,1) = numFromSecondStr;
                elseif regexp(vName,'PAsP','start')
                    newScene.pASP(numFromFirstStr,1) = numFromSecondStr;
                elseif regexp(vName,'PArP','start')
                    newScene.pAPose(numFromFirstStr,3) = numFromSecondStr;
                elseif regexp(vName,'PAx00D','start')
                    newScene.pAx00D = numFromSecondStr;
                elseif regexp(vName,'PAy00D','start')
                    newScene.pAy00D = numFromSecondStr;
                elseif regexp(vName,'PAxP','start')
                    newScene.pAPose(numFromFirstStr,1) = numFromSecondStr;
                elseif regexp(vName,'PAyP','start')
                    newScene.pAPose(numFromFirstStr,2) = numFromSecondStr;
                elseif regexp(vName,'PArP','start')
                    newScene.pAPose(numFromFirstStr,3) = numFromSecondStr;
                else
                    disp('ERROR: datatype not understood');
                    disp(vName);
                end
            end
            tasks(idxStruct).scenes = [tasks(idxStruct).scenes; newScene];
            counter = counter+1;
        end
    end
end