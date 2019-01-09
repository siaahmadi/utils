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
		
		scale = 2;
		color = [1 0 0];
		shape = 'circle';
		transparency = 0.1;
		px
		py
		displayIdx
		
		sx
		sy
		
		
		lkdSliders
		ax		
		
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
			obj.displayIdx = true(1,length(x));
			
			x = x(spike2ind(s, t));
			y = y(spike2ind(s, t));
			obj.sx = x;
			obj.sy = y;

			obj.h_spikes = p___spikepatch(x,y, obj.scale, obj.color, obj.shape);
			obj.ax = ancestor(obj.h_spikes, 'Axes');
			obj.ax.XLim = [-100 100];
			obj.ax.YLim = [10 50];
			obj.ax.DataAspectRatio = [18 20 1];
			obj.ax.XLimMode = 'manual';
			obj.ax.YLimMode = 'manual';
		end
		
		modifypatch(obj, modification)
		addsliders(obj)
		linksliders(obj,hs1, hs2)
		update(obj)
	end
	events
		Updated
	end
end