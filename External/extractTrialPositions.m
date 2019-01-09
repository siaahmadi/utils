function trialData = extractTrialPositions(x,y,t,delimeter,method,thresh)

switch lower(method)
    case 'train'
        tSp = delimeter;
        spBnds = continuousRunsOfTrue(diff(tSp)'<=thresh);
        spBnds(:,2)=spBnds(:,2)+1;
        tBnds = [tSp(spBnds(:,1)) tSp(spBnds(:,2))];
        inTrial = false(1,length(t));
        for tb = 1:size(tBnds,1)
            inTrial = inTrial | in(t',tBnds(tb,:),[],1);
        end
        trBnds = continuousRunsOfTrue(inTrial);
        trBnds(:,1) =trBnds(:,1);
        trBnds(:,2) =trBnds(:,2);
    case 'field'
        boundary = delimeter;
        inField = inpolygon(x,y,boundary(1,:),boundary(2,:));
        trBnds = continuousRunsOfTrue(inField');
    case 'gt'
        trBnds = continuousRunsOfTrue(delimeter>thresh);
    case 'gte'
        trBnds = continuousRunsOfTrue(delimeter>=thresh);
    case 'lt'
        trBnds = continuousRunsOfTrue(delimeter<thresh);
    case 'lte'
        trBnds = continuousRunsOfTrue(delimeter<=thresh);
    case 'openint'
        trBnds = continuousRunsOfTrue(in(delimeter,thresh,[],0));
    case 'closedint'
        trBnds = continuousRunsOfTrue(in(delimeter,thresh,[],1));
    case 'openout'
        trBnds = continuousRunsOfTrue(~in(delimeter,thresh,[],1));
    case 'closedout'
        trBnds = continuousRunsOfTrue(~in(delimeter,thresh,[],0));
end

nTrials = size(trBnds,1);
trialData = struct([]);
for tr = 1:nTrials
   iTr = trBnds(tr,1):trBnds(tr,2);
   trialData(tr).x = x(iTr);
   trialData(tr).y = y(iTr);
   trialData(tr).t = t(iTr);
end