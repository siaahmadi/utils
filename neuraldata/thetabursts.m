function b = thetabursts(d,ph,opt)
%THETABURSTS Find bursts of spikes over theta cycles
% 
% b = THETABURSTS(d,ph,opt) Takes the distance and theta phase of spikes and
% returns a burst grouping in |b|
%
%
% Logic:
% This algorithm tries to group spikes (indices in d, ph (must be matched
% in size)) into progressively increasing theta phase subject to the
% following two conditions:
%	- The slope of the hypothetical line connecting two successive spikes
%	must be within a given range (given by SL_THRESH)
%	- The slope must not vary outside a given range (STEP_TOLERANCE) for 
%	successive pairs of spikes (this is to separate positive slopes that
%	are separated enough in space/time to form their own burst groups).
%	
% The algorithm starts each group by adding the spike under consideration
% (give by index i) to a new group. From that point on each spike is either
%	- added to the existing (last) group, if it meets the criteria
%	- starts its own, new group, if it doesn meet the criteria
%
% Since the algorithm decides on whether or not a spike should be added to
% the last group only based on the current spike's relationship with the
% previous ones, it is possible that the current spike will be better
% suited to be in a future (i.e. next) spike's group. Therefore, a look
% back mechanism examines this possibility whenever a new group has been
% formed without regard to the STEP_TOLERANCE factor (this happens when a
% negative slope is encountered in a previous step leading to the new
% group).
%
% At the outset, a dummy spike (outside the range) is added to the input to
% avoid having to explicitly handle degenerate edge cases. The dummies are
% removed at the very end.
%
% Tip:
% There are two example real data test cases provided as an internal
% function. The algorithm can be visualized step by step by plotting the
% scatter of input with the current labels every time |b| is updated. Make
% sure to provide the colors by writing scatter(d,ph,[],b).

% Siavash Ahmadi
% 11/02/2017

% For debugging/development:
% [testcase1, testcase2] = testcases();
% ph = testcase2.ph;
% d = testcase2.d;

% add two dummy spikes for indexing purposes
ph = [2*pi; 2*pi; ph];
d = [-200; -100; d];

% ph = unwrap(ph); % doesn't work well with the test cases; unwrapping
% seems to be a bad idea since it distorts the natural structure of the
% data (it eliminates certain "drops" of phase that would otherwise
% naturally lead to the creation of a new group)


SL_THRESH = deg2rad(80); % min burst rate (cycles/run)
STEP_TOLERANCE = deg2rad([-5, 5]);
MAX_GROUP_SPAN = 2*pi;
transcycle = true;
debugmode = false;
if exist('opt', 'var')
	if isfield(opt, 'SL_THRESH')
		SL_THRESH = opt.SL_THRESH;
	end
	if isfield(opt, 'STEP_TOLERANCE')
		STEP_TOLERANCE = opt.STEP_TOLERANCE;
	end
	if isfield(opt, 'MAX_GROUP_SPAN')
		MAX_GROUP_SPAN = opt.MAX_GROUP_SPAN;
	end
	if isfield(opt, 'transcycle')
		transcycle = opt.transcycle;
	end
	if isfield(opt, 'debugmode')
		debugmode = opt.debugmode;
	end
end

b = ones(length(d), 1);
angles = cellfun(@(d,ph) computeAngle(d,ph,transcycle), ...
	row2cell([d(1:end-1), ph(1:end-1)]), ...
	row2cell([d(2:end), ph(2:end)]));
steps = diff(angles);

if angles(1) < SL_THRESH
	b(2) = 2;
end
newGroup = false;
watch = false;
groupStarter = 2;
groupSpan = 0;
for i = 3:length(b)
	if angleAdmissible(angles(i-1),SL_THRESH,transcycle) && (newGroup || within(steps(i-2), STEP_TOLERANCE))
		newGroup = false;
		if watch
			j = i - 2;
			while within(steps(j), STEP_TOLERANCE)
				% correct previous steps
				b(j) = b(j+1);
				groupStarter = j;
				if debugmode
					scatter(d(3:end),ph(3:end),[],b(3:end),'filled');
				end
				j = j - 1;
			end
			if ~angleAdmissible(angles(i-1),SL_THRESH,false)
				groupSpan = ph(i)+2*pi+sum(mod(diff(ph(groupStarter:i-1))+2*pi,2*pi));
			else
				groupSpan = sum(mod(diff(ph(groupStarter:i))+2*pi,2*pi));
			end
			watch = false;
		end
		if transcycle
			wouldbeSpan = groupSpan + mod(2*pi+ph(i)-ph(i-1), 2*pi);
		else
			wouldbeSpan = ph(i) - ph(groupStarter);
		end
		if wouldbeSpan >= MAX_GROUP_SPAN % if adding the new spike will increase group span too much, break the group at the largest gap
			[~, I] = max(diff(ph(groupStarter:i)));
			groupStarter = I + groupStarter;
			b(groupStarter:i-1) = b(groupStarter:i-1) + 1;
			if i == groupStarter
				b(i) = b(i-1) + 1; % starting a new group
				newGroup = true;
				groupSpan = 0;
			else
				b(i) = b(i-1); % breakpoint before the current point (i.e. a group already exists that the current points should belong to)
				groupSpan = sum(mod(diff(ph(groupStarter:i))+2*pi,2*pi));
			end
		else
			b(i) = b(i-1);
			groupSpan = groupSpan + mod(2*pi+ph(i)-ph(i-1), 2*pi);
		end
		if debugmode
			scatter(d(3:end),ph(3:end),[],b(3:end),'filled');
		end
	elseif angleAdmissible(angles(i-1),SL_THRESH,transcycle) && ~within(steps(i-2), STEP_TOLERANCE) % if only the step condition wasn't met
		% look back: was the previous angle positive or negative? if
		% positive add new point to previous group provisionally but keep a watch,
		% otherwise proceed
		b(i) = b(i-1) + 1;
		if debugmode
			scatter(d(3:end),ph(3:end),[],b(3:end),'filled');
		end
		newGroup = true;
		groupStarter = i;
		groupSpan = 0;
		if angles(i-2) > 0 && angles(i-3) <= 0 % previous angle positive and the one before that negative
			watch = true;
		else
			watch = false;
		end
	else % if the angle condition wasn't met
		b(i) = b(i-1) + 1;
		if debugmode
			scatter(d(3:end),ph(3:end),[],b(3:end),'filled');
		end
		newGroup = true;
		groupStarter = i;
		groupSpan = 0;
		watch = false;
	end
end

b = b(3:end) - b(3) + 1; % remove the dummies


function I = within(value, tolerance)
I = tolerance(1) <= value && value <= tolerance(2);

function I = angleAdmissible(angles,SL_THRESH,transcycle)
if transcycle
	I = angles+2*pi >= SL_THRESH;
else
	I = angles >= SL_THRESH;
end

function ang = computeAngle(s1,s2,transcycle)
ang = atan((s2(2)-s1(2))/(s2(1)-s1(1))/2/pi);
if transcycle
	if ang < deg2rad(-87.5)
		ang = atan((s2(2)+2*pi-s1(2))/(s2(1)-s1(1))/2/pi);
	end
end



function [testcase1, testcase2] = testcases() %#ok<DEFNU> % for debugging

testcase1.ph = [
    3.3650
    3.9593
    4.1331
    4.2573
    3.1399
	2.2500 %%% I added
    4.5593
    4.9008
    5.0711
    6.2751
    1.3003
    3.3471
    5.2889
    5.2932
    1.4381
    0.1724];
testcase1.d = [
    0.0243
    0.0484
    0.0550
    0.0603
    0.2242
	0.4350 %%% I added
    0.4482
    0.4574
    0.4616
    0.4968
    0.5383
    0.5994
    0.6551
    0.8172
    0.8756
    0.9964];


testcase2.ph = [
    4.2284
    0.0049
    0.5637
    2.8359
    4.8732
    5.2229
    5.3636
    0.8349
    3.0711
    0.0636
    5.8160];
testcase2.d = [
    0.0289
    0.4878
    0.5013
    0.5613
    0.6214
    0.6311
    0.6350
    0.6825
    0.7467
    0.8444
    0.9906];
