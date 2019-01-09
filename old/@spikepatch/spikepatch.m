classdef spikepatch < handle
	properties
		h_spikes
		h_path
	end
	properties (SetAccess=private)
		x
		y
		t
		s
		sx
		sy
	end
	properties(SetAccess=private, GetAccess=public)
		clh % continuous listener handle for slider 1
		mlh % motion listener handle for slider 2
	end
	methods
		function obj = spikepatch(x,y,t,s,plotpath)
			if plotpath
				obj.h_path = plot(x,y);
			end
			obj.x = x;
			obj.y = y;
			obj.t = t;
			obj.s = s;
			
			x = x(spike2ind(s, t));
			y = y(spike2ind(s, t));
			obj.sx = x;
			obj.sy = y;

			obj.h_spikes = p___spikepatch(x,y, 2, [], 'circle');
		end
		
		modifypatch(h, modification)
		addsliders(obj)
		linksliders(obj,hs1, hs2)
		update(obj)
	end
	events
		Updated
	end
end