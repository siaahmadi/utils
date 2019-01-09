function [fr, duration] = firingrate1session(pd,sp)

t = structfun(@(trial) pd.t(pd.subtrial==trial), rmfield(pd.assignment, 'unassigned'), 'un', 0);
duration = structfun(@range, t, 'un', 0);

fr = arrayfun(@(neuron) structnfun(@(sp,d) length(sp) / d, rmfield(neuron, 'id'), duration, 'un', 0), sp.Spikes, 'un', 0);
fr = cat(1, fr{:});
id = {sp.Spikes.id};
[fr.id] = id{:};