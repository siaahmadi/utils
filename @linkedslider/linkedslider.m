classdef linkedslider < handle
	properties
		slider				% isa UIControl
		sisterslider = [];	% isa linkedslider
		myID				% = slider.Tag
		satelliteData		% = slider.UserData
		parent
	end
	properties (SetAccess=private)
		lhFigResize
		lkdSliderMinDiff = .003;
		lh = {}				% listener handles
	end
	properties (Constant)
		SLD_END_SCROLL_WIDTH = 35;
		DFLT_SLIDER_POSITION = [20 20 525 20];
	end
	methods
		function obj = linkedslider(h_fig, sisterSlider, notifyMe, sldPosition, initVal)
			[myslider, sister] = obj.slidebar(h_fig, sldPosition, initVal, sisterSlider, notifyMe);
			obj.slider = myslider;
			obj.sisterslider = sister;
			h_fig.UserData.linkedSliders{obj.myID} = obj;
			obj.lhFigResize = addlistener(h_fig, 'SizeChanged', @(src, evnt) windowResizeCallback(obj,src));
		end
		
		function pushLH(obj, lh)
			obj.lh{end+1} = lh;
		end
		function update(obj, lowVal, hiVal)
			if nargin == 2 && length(lowVal) == 2 && issorted(lowVal)
				if obj.myID < obj.sisterslider.myID
					obj.slider.Value = lowVal(1);
					obj.sisterslider.slider.Value = lowVal(2);
				else
					obj.slider.Value = lowVal(2);
					obj.sisterslider.Value = lowVal(1);
				end
			elseif nargin == 3 && hiVal > lowVal
				if obj.myID < obj.sisterslider.myID
					obj.slider.Value = lowVal;
					obj.sisterslider.Value = hiVal;
				else
					obj.slider.Value = hiVal;
					obj.sisterslider.Value = lowVal;					
				end
			else
				error('check |lowVal| and |hiVal|')
			end
			obj.parent.update(); % notify didn't work! |notify(obj.parent, 'Updated')|
		end
		[slider, sister] = slidebar(obj,h_fig, sldPosition, initVal, sisterSlider, notifyMe)
	end
	events
		Updated
	end
end