function h = slidebar(h_fig, sldPosition, initVal, sisterSlider, notifyMe)
	if nargin == 0 || ~(isvalid(h_fig) && ishandle(h_fig))
		error('Provide a valid handle to a Figure')
	end
	if ~exist('sldPosition', 'var') || isempty(sldPosition)
		sldPosition = [20 20 525 20];
	end
	SLD_END_SCROLL_WIDTH = 35;
	h_fig.WindowButtonUpFcn = @mouseBtnUp;
	h_fig.WindowButtonDownFcn = @sldBtnDown;
	h_fig.SizeChangedFcn = @figureSizeChange;
	numAllSliders = numel(findobj(h_fig.Children, 'flat', 'type', 'uicontrol', '-and', 'style','slider'));
	h = uicontrol(h_fig, 'Style', 'slider', 'Position', sldPosition, 'Enable', 'Inactive', 'Callback', @sldCallback, 'ButtonDownFcn', @sldBtnDown);
	myID = 1 + numAllSliders;
	h.Tag = num2str(myID);
	if exist('initVal', 'var') && ~isempty(initVal)
		h.Value = initVal;
	end
	h_fig.UserData.sliderValue(str2double(h.Tag)) = h.Value;
	if exist('sisterSlider', 'var') && isvalid(sisterSlider) && ishandle(sisterSlider)
		h.UserData.sisterSlider = sisterSlider;
		sisterSlider.UserData.sisterSlider = h;
		h_fig.UserData.sliderValue(str2double(sisterSlider.Tag)) = sisterSlider.Value;
	else
		if exist('sisterSlider', 'var')
			warning('sisterSlider provided is not a valid handle: setting sister to Null')
		end
		h.UserData.sisterSlider = [];
	end

	function sldCallback(src, callbackData)
		ensureIntervalValidity(src)
	end
	function sldBtnDown(src, callbackData)
		if ~strcmpi(src.Type, 'Figure')
			return
		end
		src.WindowButtonUpFcn = @mouseBtnUp; % this must be the first thing done
											% it can't be moved into the if
											% withinBoundary statement
											% because even if so, mouse
											% might be released before this
											% callback realizes it has been
											% clicked in the right location
											% so it can set the release
											% callback
		mousePosition = src.CurrentPoint; % relative to the Figure
		sld = findobj(src.Children, 'flat', 'type', 'uicontrol', '-and', 'style','slider');
		
		function [r, sldTag] = withinBoundary(sld, mouse)
			tags = cellfun(@str2double, {sld.Tag});
			for sldTag = tags
				buffer = findobj(sld, 'tag', num2str(sldTag)); % could do with [~, tagIdx] = sort(tags); as well
				sldPos = buffer.Position;
				if sldPos(1) <= mouse(1) && mouse(1) <= sum(sldPos([1 3])) % x good
					if sldPos(2) <= mouse(2) && mouse(2) <= sum(sldPos([2 4])) % y good
						r = true;
						break;
					end
				end
				r = false;
			end
			if ~r
				sldTag = 0;
			end
			sldTag = num2str(sldTag);
		end
		[wb, ws] = withinBoundary(sld,mousePosition);
		if wb % if within the boundary of any slider -- ws contains the tag of the clicked slider
			% DO WHAT YOU LIKE
			src.UserData.focusedSliderTag = ws;
			src.WindowButtonMotionFcn = @mouseMotion;
		end
		src.UserData.status = 'BtnDownIsDone';
	end
	function mouseMotion(src,callbackData) %#ok<*INUSD>
		sld = findobj(src.Children, 'flat', 'type', 'uicontrol', '-and', 'style','slider', '-and', 'tag', src.UserData.focusedSliderTag);
		mousePos = src.CurrentPoint;
		sldLeftEnd = sld.Position(1) + SLD_END_SCROLL_WIDTH;
		sldRightEnd = sum(sld.Position([1 3])) - SLD_END_SCROLL_WIDTH;
		if mousePos(1) < sldLeftEnd
			mousePos(1) = sldLeftEnd;
		end
		if mousePos(1) > sldRightEnd
			mousePos(1) = sldRightEnd;
		end
		sldEffectiveWidth = (sld.Position(3) - 2 * SLD_END_SCROLL_WIDTH);
		mousePosRel = (mousePos(1) - sldLeftEnd) / sldEffectiveWidth;
		oldVal = sld.Value;
		sld.Value = mousePosRel;
		ensureIntervalValidity(sld, @iif, oldVal)
	end
	function mouseBtnUp(src,callbackData)
		while ~strcmpi(src.UserData.status, 'BtnDownIsDone')
			% waiting for BtnDown to do its thing...
		end
		src.WindowButtonMotionFcn = '';
	end
	function ensureIntervalValidity(src, validityFunc, oldVal) % validityFunc and oldVal are not implemented
		if isfield(src.UserData,'sisterSlider') && ishandle(src.UserData.sisterSlider) && isvalid(src.UserData.sisterSlider)
			% make sure it doesn't go past sister's value
			if strcmpi(src.Tag, '1') % for now, I'll assume there are only two sliders, with 1 controlling begin and 2 controlling the end
				if src.Value >= src.UserData.sisterSlider.Value
					src.Value = src.UserData.sisterSlider.Value;
				end
				h_fig.UserData.sliderValue(1) = src.Value;
			elseif strcmpi(src.Tag, '2')
				if src.Value <= src.UserData.sisterSlider.Value
					src.Value = src.UserData.sisterSlider.Value;
				end
				h_fig.UserData.sliderValue(2) = src.Value;
			end
		end
		notify(notifyMe, 'Updated');
	end
	function figureSizeChange(src, ~)
		% make sure the sliders are resized as the Figure is resized
	end
end