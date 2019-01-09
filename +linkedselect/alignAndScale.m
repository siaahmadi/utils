forceAlignToPeak = false;
useFirstOneOrLongestStringOfNonNaNs = 'firstone'; % |firstone| or |nonnans|
ratNo = 678;
criteria.thresh_INT_rate = 5; % Hz
criteria.thresh_INT_rate_secondary = 20; % Hz
criteria.thresh_INT_width = 0.25; % ms
criteria.thresh_INT_ratio = 1.5; % peak-to-trough
criteria.thresh_badCell_peakToTroughHeightPrctil = 5; % percentile
criteria.thresh_badCell_peakToTroughHeight = 100; % uV

[WVs, widths3, ratios, nSpikes] = waveforms.waveformStatsLE(...
	{['Y:\Sia\PhD Projects\Analyses\LinearTrackABBA\spikeWaveforms\rat' num2str(ratNo) 'inFile.txt']},...
	{'.clusters'});

if ~any(std(cellfun(@length, WVs))) % then rows of WVs are the trials
	WVs = WVs';
end

alignedSpikes = zeros(size(WVs, 1), 32);
peakInd = 8;
if strcmpi(useFirstOneOrLongestStringOfNonNaNs, 'nonnans')
	[~,goodWvIdx]=max(cellfun(@(x) sum(~isnan(x)), WVs), [], 2);
else
	goodWvIdx = firstone(cellfun(@(x) any(~isnan(x)), WVs));
end
wv = WVs(sub2ind(size(WVs), (1:size(WVs, 1))', goodWvIdx));
[~, I] = cellfun(@max,wv);

for i = 1:size(alignedSpikes, 1)
	beginInd = I(i)-peakInd+1;
	endInd = beginInd + size(alignedSpikes, 2) - 1;
	if beginInd < 1 || endInd > length(wv{i})
		if length(wv{i}) < 32
			alignedSpikes(i, peakInd:peakInd+length(wv{i})-I(i)) = wv{i}(I(i):end); % post-peak, incl. peak
			alignedSpikes(i, peakInd-I(i)+1:peakInd-1) = wv{i}(1:I(i)-1); % pre-peak
		else
			if forceAlignToPeak
				alignedSpikes(i, peakInd:peakInd+length(wv{i})-I(i)) = wv{i}(I(i):end); % post-peak, incl. peak
				alignedSpikes(i, (I(i)-peakInd+1:I(i)-1)+peakInd-I(i)) = wv{i}(I(i)-peakInd+1:I(i)-1); % pre-peak
			else
				alignedSpikes(i, :) = wv{i}(1:32);
			end
		end
	else
		alignedSpikes(i, :) = wv{i}(beginInd:endInd);
	end
end

alignedAndScaledSpikes = alignedSpikes ./ repmat(max(alignedSpikes,[], 2),1,size(alignedSpikes,2));

spikeHeight = (max(alignedSpikes,[],2)-min(alignedSpikes,[],2))';

%% Do Plotting
figure;plot(alignedSpikes')
figure;plot(alignedAndScaledSpikes')

lineartrackABBA.analyses.PerPassPfRateVelocity.run;
trialDurations = cellfun(@(x) x.duration, testSession.getTrials());
perCellDur = repmat(trialDurations, 1, size(nSpikes,2));

badCellIdx = widths3{1}<0 | spikeHeight < min(prctile(spikeHeight, criteria.thresh_badCell_peakToTroughHeightPrctil), criteria.thresh_badCell_peakToTroughHeight);
INTidx = sum(arrayfun(@(x,y)x/y>criteria.thresh_INT_rate,nSpikes,perCellDur))>0;
INTidx = INTidx & widths3{1} < criteria.thresh_INT_width & ratios{1} < criteria.thresh_INT_ratio & ~badCellIdx;
INTidx = INTidx | sum(arrayfun(@(x,y)x/y>criteria.thresh_INT_rate_secondary,nSpikes,perCellDur))>0;
pyrCellIdx = ~(badCellIdx | INTidx);

figure;
for i = 1:9
	subplot(3,3,i)
	scatter3(ratios{1}, nSpikes(i,:)./perCellDur(i,:), widths3{1});
	hold on;
	scatter3(ratios{1}(~pyrCellIdx), nSpikes(i,~pyrCellIdx)./perCellDur(i,~pyrCellIdx), widths3{1}(~pyrCellIdx),[],'r');
	xlabel('Peak-to-Trough Ratio')
	ylabel('Rate (Hz)')
	zlabel('Spike Width (ms)')
	axis square
	set(gca,'FontName','Arial')
end

save(['rat' num2str(ratNo) 'wv.mat'], 'WVs', 'widths3', 'ratios', 'nSpikes', 'pyrCellIdx', 'badCellIdx', 'INTidx', 'criteria', 'perCellDur')