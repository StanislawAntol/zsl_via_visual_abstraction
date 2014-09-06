% Code taken from the PASCAL VOC 2012 code dataset

function [AP, baseline] = AveragePrecisionVOC2012(scores, gt)

    [~, si]=sort(-scores);
    
    tp = gt(si) > 0;
    fp = gt(si) == 0;

    fp = cumsum(fp);
    tp = cumsum(tp);
    rec = tp/sum(gt>0);
    prec = tp./(fp+tp);

    % function ap = VOCap(rec,prec)
    mrec = [0; rec; 1];
    mpre = [0; prec; 0];
    for i = numel(mpre)-1:-1:1
        mpre(i) = max(mpre(i),mpre(i+1));
    end
    i = find(mrec(2:end)~=mrec(1:end-1))+1;
    AP = sum((mrec(i)-mrec(i-1)).*mpre(i));
    
    baseline = sum(gt==1)/length(gt);

end