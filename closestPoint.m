function [s, s2] = closestPoint(timeStamps, sampledSignal, t, t2)
%CLOSESTPOINT  Return the signal value closest to t in time.
%   S = CLOSESTPOINT(timeStamps, sampledSignal, t) returns s an entry of
%   sampledSignal whose corresponding entry in timeStamps is closest to t.
%
%   It is assumed that timeStamps is sorted in ascending order and is in
%   the same unit as t. Furthermore, if t is outside the range of
%   timeStamps the first or last entry of sampledSignal is returned
%   depending on whether t is to the left or right of timeStamps
%   respectively.
%
%	EXAMPLES:
%      use idx = closestPoint(X, 1:length(X), t) to get the index list of
%      entries of X closest to entries of t
%
%	   use idx = closestPoint(X, X, t) to get the actual entries
%	   corresponding to entries of t (closest ones)
%	   (Snap (t) To Grid (X))
%
%	   use idx = closestPoint(X, Y, t) to get Y(t) for the function Y
%	   defined on support set X. If t(i)\not\in X, then for i\in
%	   1:length(t), Y(t(i)+eps(i)) will be returned where eps(i) is the
%	   smallest positive value for which t(i)+eps(i)\in X.

s = t;
idx1 = t;

if length(timeStamps) == 1 % avoid singleton errors
	s = sampledSignal;
	if nargin == 4
		s2 = sampledSignal;
	end
	return
end

%%%%%%%%% THIS PIECE OF CODE RUNS IN THETA(N*LOG2(N))
for i = 1:length(t)
	i_low = 1;
	i_high = length(timeStamps);
	i_middle = floor((i_high+i_low)/2);
	T = t(i);
	while true
		if i_middle == i_low
			if T-timeStamps(i_middle) < timeStamps(i_middle+1) - T
				s(i) = sampledSignal(i_middle);
				idx1(i) = i_middle;
			else
				s(i) = sampledSignal(i_middle+1);
				idx1(i) = i_middle+1;
			end
			break;
		end
		if T==timeStamps(i_middle)
			s(i) = sampledSignal(i_middle);
			idx1(i) = i_middle;
			break;
		elseif T<timeStamps(i_middle)
			i_high = i_middle;
			i_middle = floor((i_high+i_low)/2);
			continue;
		else
			i_low = i_middle;
			i_middle = floor((i_high+i_low)/2);
			continue;
		end
	end
	
%%%%%%% IF YOU WANT THE CODE TO RUN IN OMEGA(N^2) go ahead and uncomment
%%%%%%% this part (HOW DARE YOU):
% 	T = t(i);
% 	if T<=timeStamps(1)
% 		s(i) = sampledSignal(1);
% 		idx1(i) = 1;
% 		continue;
% 	elseif T>=timeStamps(end)
% 		s(i) = sampledSignal(end);
% 		idx1(i) = length(timeStamps);
% 		continue;
% 	end
% 
% 	if ~isempty(find(timeStamps==T, 1, 'first'))
% 		idx1(i) = find(timeStamps==T, 1, 'first');
% 		s(i) = sampledSignal(idx1(i));
% 		continue;
% 	end
% 	closestLeft = find(timeStamps<T, 1, 'last');
% 	closestRight = find(timeStamps>T, 1, 'first');
% 	closestIdx = double((T-timeStamps(closestLeft))>(timeStamps(closestRight)-T))*closestRight + double((T-timeStamps(closestLeft))<(timeStamps(closestRight)-T))*closestLeft;
% 	s(i) = sampledSignal(closestIdx);
% 	idx1(i) = closestIdx;
end

if nargin>3 && nargout>1
	s2 = s;
	idx2 = idx1;
	%%%%%%%%% THIS PIECE OF CODE RUNS IN THETA(N*LOG2(N))
	for i = 1:length(t2)
		i_low = 1;
		i_high = length(timeStamps);
		i_middle = floor((i_high+i_low)/2);
		T = t2(i);
		while true
			if i_middle == i_low
				if T-timeStamps(i_middle) < timeStamps(i_middle+1) - T
					idx2(i) = i_middle;
					s2(i) = mean(sampledSignal(idx1(i):i_middle));
				else
					idx2(i) = i_middle+1;
					s2(i) = mean(sampledSignal(idx1(i):i_middle+1));
				end
				break;
			end
			if T==timeStamps(i_middle)
				idx2(i) = i_middle;
				s2(i) = mean(sampledSignal(idx1(i):i_middle));
				break;
			elseif T<timeStamps(i_middle)
				i_high = i_middle;
				i_middle = floor((i_high+i_low)/2);
				continue;
			else
				i_low = i_middle;
				i_middle = floor((i_high+i_low)/2);
				continue;
			end
		end
		
%%%%%%% IF YOU WANT THE CODE TO RUN IN OMEGA(N^2) go ahead and uncomment
%%%%%%% this part:
% 		T = t2(i);
% 		if T<=timeStamps(1)
% 			idx2(i) = 1;
% 			s2(i) = mean(sampledSignal(idx1(i):idx2(i)));
% 			continue;
% 		elseif T>=timeStamps(end)
% 			idx2(i) = length(timeStamps);
% 			s2(i) = mean(sampledSignal(idx1(i):idx2(i)));
% 			continue;
% 		end
% 
% 		if ~isempty(find(timeStamps==T, 1, 'first'))
% 			idx2(i) = find(timeStamps==T, 1, 'first');
% 			s2(i) = mean(sampledSignal(idx1(i):idx2(i)));
% 			continue;
% 		end
% 		closestLeft = find(timeStamps<T, 1, 'last');
% 		closestRight = find(timeStamps>T, 1, 'first');
% 		closestIdx = double((T-timeStamps(closestLeft))>(timeStamps(closestRight)-T))*closestRight + double((T-timeStamps(closestLeft))<(timeStamps(closestRight)-T))*closestLeft;
% 		idx2(i) = closestIdx;
% 		s2(i) = mean(sampledSignal(idx1(i):idx2(i)));
	end
end