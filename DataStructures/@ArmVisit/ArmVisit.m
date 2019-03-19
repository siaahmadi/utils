classdef ArmVisit
	properties
		t_ = struct('start', 0, 'end', 0, 'reward_site_start', 0, 'reward_site_end', 0);
		t = [];
		x = [];
		y = [];
		trial = '';
		arm = 0;
		rank = 0;
		reward = 0; % 0 if no reward, 1 small, 2 opposite, 3 main
	end
	methods
		function obj = ArmVisit(t, x, y, t_reward, trial, arm, rank, reward)
			obj.t = t;
			obj.x = x;
			obj.y = y;
			obj.t_.start = t(1);
			obj.t_.end = t(end);
			obj.t_.reward_site_start = t_reward(1);
			obj.t_.reward_site_end = t_reward(2);
			obj.trial = trial;
			obj.arm = arm;
			obj.rank = rank;
			obj.reward = reward;
		end
		function [x, y] = getPath(obj, rewardOnly)
			% return (x, y) path data of arm visit, or reward site
			if ~exist('rewardOnly', 'var')
				rewardOnly = false;
			end
			if rewardOnly
				ivl_reward = ivlset(obj.t_.reward_site_start, obj.t_.reward_site_end);
				idx_reward = ivl_reward.restrict(obj.t, true);
				idx_reward = idx_reward{1};
				x = obj.x(idx_reward);
				y = obj.y(idx_reward);
			else
				x = obj.x;
				y = obj.y;
			end
		end
	end
	methods(Static)
		function [visit, i] = findReward(arm_visits, i_th, reward_type)
			% returns the rank of entry into the reward arm from a list of
			% ArmVisit objects
			r = cat(1, arm_visits.reward);
			i = find(r==reward_type, i_th);
			if isempty(i)
				i = 0;
				visit = [];
			else % this returns the last visit, regardless of if number of visits to that reward <= rank_of_entry_to_reward or not
				i = i(end);
				visit = arm_visits(i);
			end
		end
		function [t, x, y] = pathBefore(arm_visits, i_th, reward_type)
			% Cumulative path data from list of ArmVisit objects up to but
			% not including entry into a reward arm
			%
			% If reward_type arm never visited, will return everything
			
			t = [];
			x = [];
			y = [];
			[~, i] = ArmVisit.findReward(arm_visits, i_th, reward_type);
			if i > 0
				arm_visits = arm_visits(1:i-1);
			end
			if ~isempty(arm_visits)
				t = cat(1, arm_visits.t);
				x = cat(1, arm_visits.x);
				y = cat(1, arm_visits.y);
			end
		end
		function [t, x, y] = pathBefore_Incl(arm_visits, i_th, reward_type)
			% Cumulative path data from list of ArmVisit objects up and
			% including entry into a reward arm
			[~, i] = ArmVisit.findReward(arm_visits, i_th, reward_type);
			arm_visits = arm_visits(1:i);
			t = cat(1, arm_visits.t);
			x = cat(1, arm_visits.x);
			y = cat(1, arm_visits.y);
		end
		function [t, x, y] = pathAfter(arm_visits, i_th, reward_type)
			% Cumulative path data from list of ArmVisit objects after
			% exiting a reward arm
			%
			% Will return empty if reward_type arm never visited
			
			t = [];
			x = [];
			y = [];
			[~, i] = ArmVisit.findReward(arm_visits, i_th, reward_type);
			if i > 0
				arm_visits = arm_visits(i+1:end);
			end
			if ~isempty(arm_visits) && i > 0
				t = cat(1, arm_visits.t);
				x = cat(1, arm_visits.x);
				y = cat(1, arm_visits.y);
			end
		end
		function [t, x, y] = pathAfter_Incl(arm_visits, i_th, reward_type)
			% Cumulative path data from list of ArmVisit objects on reward
			% and everything after
			%
			% Will return empty if reward_type arm never visited
			
			t = [];
			x = [];
			y = [];
			[~, i] = ArmVisit.findReward(arm_visits, i_th, reward_type);
			if i > 0
				arm_visits = arm_visits(i:end);
			end
			if ~isempty(arm_visits) && i > 0
				t = cat(1, arm_visits.t);
				x = cat(1, arm_visits.x);
				y = cat(1, arm_visits.y);
			end
		end
		function l = listVisits(arm_visits)
			% return array of arm numbers from a list of ArmVisit objects
			l = cat(1, arm_visits.arm);
		end
		function r = rankOfReward(arm_visits, reward_type)
			r = find(ArmVisit.listVisits(arm_visits) == reward_type);
			if isempty(r)
				r = 0;
			end
		end
		function visits = TrialVisits(arm_visits, trials)
			[visits, tr] = ArmVisit.groupTrials(arm_visits);
			idx = ismember(tr, trials);
			if iscell(trials)
				visits = visits(idx);
			else
				visits = visits{idx};
			end
		end
		function [trial_visits, trials] = groupTrials(arm_visits)
			all_trials = {arm_visits.trial};
			trials = unique(all_trials);
			trials = trials(:);
			trial_visits = cell(length(trials), 1);
			for i = 1:length(trial_visits)
				idx = ismember(all_trials, trials{i});
				trial_visits{i} = arm_visits(idx);
			end
		end
		function t = Target(arm_visits)
			%t = ArmVisit.Target(arm_visits)
			% Returns arm number of first reward==3 visit from arm_visits
			t = ArmVisit.findReward(arm_visits, 1, 3);
			t = t.arm;
		end
		function [visit, i] = findEventArm(arm_visits, t0)
			%[visit, i] = ArmVisit.findEventArm(arm_visits, t0)
			% Return visit where even at `t0` occurred
			%
			% Event could be SWR, reward, replay, etc
			
			t_ = {arm_visits.t_}';
			t_ = cellfun(@(x) [x.start, x.end], t_,'un', 0);
			t_ = cat(1, t_{:});
			ivls = ivlset(t_);
			i = ivls.index(t0);
			if i == 0 % not found
				visit = [];
			else
				visit = arm_visits(i);
			end
		end
	end
end