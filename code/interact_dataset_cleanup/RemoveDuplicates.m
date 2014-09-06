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

function goodIdxs = RemoveDuplicates(options, realImgNames, realLabels, whichUser, intIdxs)

% clear all; close all;

imgPath = options.folderINTERACTImgs;

computeGISTFeats      = 1;
lookAtDuplicates      = 0;
lookAtDuplicateGroups = 0;
analyzeViaHistograms  = 0;

GISTFeatSize = 512;
meanDim1 = 256;
meanDim2 = 256;
saveFilename = sprintf(options.fileFmtINTERACTGISTFeat, GISTFeatSize, meanDim1, meanDim2);

realImgNamesSubset = realImgNames(intIdxs);
numImgs = numel(realImgNamesSubset);
realIdxsSubset     = intIdxs;
realLabelsSubset   = realLabels(intIdxs);
whichUserSubset    = whichUser(intIdxs);
userLabels         = unique(whichUserSubset);

if ( computeGISTFeats ~= 0 )

    gistFeats = zeros(numImgs, GISTFeatSize);
    clear param;
    
    fprintf('Computing GIST Features...\n');
    for i = 890:numImgs;
        if ( mod(i, 100) == 0 )
            fprintf('%d\n', i);
        end
        img = LoadAnyImgAsRGB(imgPath, realImgNamesSubset{i});
        
        param.imageSize = [meanDim1, meanDim2];
        param.orientationsPerScale = [8 8 8 8];
        param.numberBlocks = 4;
        param.fc_prefilt = 4;
        
        % Computing gist requires 1) prefilter image, 2) filter image and collect
        % output energies
        [gist, param] = LMgist(img, '', param);
        
        gistFeats(i, :) = gist;
    end
    fprintf('Finished computing GIST Features.\n');
    save(saveFilename, 'gistFeats');
else
    load(saveFilename);
end

gistFeatsDists = pdist(gistFeats);
[sortedGistFeatDists, sortedIdxs] = sort(gistFeatsDists);

numImgs = length(intIdxs);
img1Idxs = [];
img2Idxs = [];
% for i = 1:750%numel(sortedIdxs)
endIdx = sum( sortedGistFeatDists == 0 );
whichSortedIdxs = [1:endIdx];
for i = whichSortedIdxs
    [img1Idx, img2Idx] = PdistIdxToIJ(sortedIdxs(i), numImgs);
    
    img1Idxs = [img1Idxs, img1Idx];
    img2Idxs = [img2Idxs, img2Idx];
    
    if ( lookAtDuplicates ~= 0 )
        fprintf('Current index number is %d with index %d.\n', i, sortedIdxs(i));
        img1File = LoadAnyImgAsRGB(imgPath, realImgNamesSubset{img1Idx});
        img2File = LoadAnyImgAsRGB(imgPath, realImgNamesSubset{img2Idx});
        clf
        figure(1)
        string = sprintf('Proposed Image Match Number %d', i);
        
        h1 = subplot(1, 2, 1);
        hold on
        title(h1, string);
        imshow(img1File)
        subplot(1, 2, 2)
        imshow(img2File)
        hold off
        
        pause();
    end
end

DG = sparse(img1Idxs, img2Idxs, true, numImgs, numImgs);

[nClusters,clusterSizes,members,idxLargestCluster] = networkComponents(DG);

[sortedSizes, sortedSizesIdx] = sort(clusterSizes, 'Descend');
sortedMembers = members(sortedSizesIdx(sortedSizes>1))';

if ( lookAtDuplicateGroups ~= 0 )
    
    for i = 1:numel(sortedMembers)
        % for i = numel(sortedMembers):-1:1
        
        members = sortedMembers{i};
        
        figure(1)
        clf
        
        numImgs = numel(members);
        numGrid = ceil(sqrt(numImgs));
        
        for j = 1:numImgs
            
            imgFile = LoadAnyImgAsRGB(imgPath, realImgNamesSubset{members(j)});
            h = subplot(numGrid, numGrid, j);
            
            imshow(imgFile);
            if ( j == 1 )
                string = sprintf('Proposed Image Match Number %d', i);
                title(h, string);
            end
        end
        
        pause(.7)
    end
    
end

duplicates = [sortedMembers{:}];
duplicatesM1 = KeepOneOfDuplicates(sortedMembers);
labelsWODuplicates = realLabelsSubset;
labelsWODuplicates(duplicates) = [];
realIdxsSubsetW0Duplicates = realIdxsSubset;
realIdxsSubsetW0Duplicates(duplicates) = [];
whichUsersWODuplicates = whichUserSubset;
whichUsersWODuplicates(duplicates) = [];
labelsWODuplicatesM1 = realLabelsSubset;
labelsWODuplicatesM1(duplicatesM1) = [];
realIdxsSubsetW0DuplicatesM1 = realIdxsSubset;
realIdxsSubsetW0DuplicatesM1(duplicatesM1) = [];
whichUsersWODuplicatesM1 = whichUserSubset;
whichUsersWODuplicatesM1(duplicatesM1) = [];

goodIdxs = false(numImgs, 1);
goodIdxs(realIdxsSubsetW0DuplicatesM1) = true(1);

set(0,'defaulttextinterpreter','none')
set(0,'defaulttextfontsize', 16);
set(0,'defaultaxesfontsize', 14)

if ( analyzeViaHistograms ~= 0 )
    figure(1)
    % subplot(1, 2, 1)
    clf;
    hold on
    hist(realLabelsSubset, realLabels)
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    
    
    hold off
    
    figure(2)
    % subplot(1, 2, 2)
    clf;
    hold on
    histWODuplicates = hist(labelsWODuplicates, realLabels);
    hist(labelsWODuplicates, realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([min(histWODuplicates)-2, numVerbs+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed.eps duplicates_removed.png');
    system(eps2pngStr);
    
    figure(3)
    % subplot(1, 2, 2)
    clf;
    hold on
    histWODuplicatesM1 = hist(labelsWODuplicatesM1, realLabels);
    hist(labelsWODuplicatesM1, realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([min(histWODuplicates)-2, numVerbs+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After Duplicates Removed Keeping One');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removedM1.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removedM1.eps duplicates_removedM1.png');
    system(eps2pngStr);
    
    verbHistU1 = hist(labelsWODuplicates( whichUsersWODuplicates == 1 ), realLabels);
    verbHistU2 = hist(labelsWODuplicates( whichUsersWODuplicates == 2 ), realLabels);
    verbHistU3 = hist(labelsWODuplicates( whichUsersWODuplicates == 3 ), realLabels);
    fewestImgsFromAllUsers = min(min([verbHistU1; verbHistU2; verbHistU3]))
    
    figure(4)
    hist(labelsWODuplicates( whichUsersWODuplicates == 1 ), realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([fewestImgsFromAllUsers-2, numVerbs/3+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After All Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed_U1.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed_U1.eps duplicates_removed_U1.png');
    system(eps2pngStr);
    
    figure(5)
    hist(labelsWODuplicates( whichUsersWODuplicates == 2 ), realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([fewestImgsFromAllUsers-2, numVerbs/3+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After All Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed_U2.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed_U2.eps duplicates_removed_U2.png');
    system(eps2pngStr);
    
    figure(6)
    hist(labelsWODuplicates( whichUsersWODuplicates == 3 ), realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([fewestImgsFromAllUsers-2, numVerbs/3+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After All Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed_U3.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed_U3.eps duplicates_removed_U3.png');
    system(eps2pngStr);
    
    verbHistU1M1 = hist(labelsWODuplicatesM1( whichUsersWODuplicatesM1 == 1 ), realLabels);
    verbHistU2M1 = hist(labelsWODuplicatesM1( whichUsersWODuplicatesM1 == 2 ), realLabels);
    verbHistU3M1 = hist(labelsWODuplicatesM1( whichUsersWODuplicatesM1 == 3 ), realLabels);
    fewestImgsFromAllUsersM1 = min(min([verbHistU1M1; verbHistU2M1; verbHistU3M1]))
    
    figure(7)
    hist(labelsWODuplicatesM1( whichUsersWODuplicatesM1 == 1 ), realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([fewestImgsFromAllUsers-2, numVerbs/3+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After All But One Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed_U1_M1.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed_U1_M1.eps duplicates_removed_U1_M1.png');
    system(eps2pngStr);
    
    figure(8)
    hist(labelsWODuplicatesM1( whichUsersWODuplicatesM1 == 2 ), realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([fewestImgsFromAllUsers-2, numVerbs/3+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After All But One Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed_U2_M1.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed_U2_M1.eps duplicates_removed_U2_M1.png');
    system(eps2pngStr);
    
    figure(9)
    hist(labelsWODuplicatesM1( whichUsersWODuplicatesM1 == 3 ), realLabels);
    set(get(gca,'child'),'FaceColor','b','EdgeColor','k', 'LineWidth', 3);
    xlim([0, numVerbs+1])
    ylim([fewestImgsFromAllUsers-2, numVerbs/3+1])
    set(gca, 'XTick', realLabels)
    xticklabel_rotate(realLabels, 90, realVerbs)
    ylabel('Number of Images');
    title('Number of Images After All But One Duplicates Removed');
    set(gca, 'LineWidth', 2);
    % Make full screen
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    set(gcf, 'PaperPositionMode', 'auto')
    hold off
    
    print(gcf, '-depsc2', sprintf('duplicates_removed_U3_M1.eps'));
    % Convert eps to png
    eps2pngStr = sprintf('export LD_LIBRARY_PATH=""; convert -colorspace RGB duplicates_removed_U3_M1.eps duplicates_removed_U3_M1.png');
    system(eps2pngStr);
    
    
    
end