function sessionIvl = sessionivl(pd)
%SESSIONIVL ivlset object of valid session trials
%
% sessionIvl = SESSIONIVL(pd)

fn = setdiff(fieldnames(pd.assignment), 'unassigned');

for i = 1:length(fn)
	t = pd.t(pd.assignment.(fn{i})==pd.subtrial);
	if ~isempty(t)
		Start(i) = t(1);
		End(i) = t(end);
	else
		Start(i) = 0;
		End(i) = 0;
	end
end

sessionIvl = ivlset(Start, End);