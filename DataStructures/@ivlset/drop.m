function obj = drop(obj, operator, value)
%DROP(obj, operator, value) Drop intervals meeting the operator-value
%criterion


myIvls = obj.toIvl();
durations = diff(myIvls, 1, 2);

if strcmp(operator, '>')
	toKeep = durations <= value;
elseif strcmp(operator, '<')
	toKeep = durations >= value;
else
	error('Operator not implemented yet.');
end

obj.Begin = myIvls(toKeep, 1);
obj.End = myIvls(toKeep, 2);

obj.U = p___union(obj.toIvl);