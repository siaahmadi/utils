function mugui(h_fig, sldPosition)
	if nargin == 0 || ~isvalid(h_fig)
		error('Provide a valid handle to a Figure')
	end
	if ~exist('sldPosition', 'var')
		sldPosition = [200 20 320 20];
	end
	SLD_END_SCROLL_WIDTH = 35;
	h_fig.WindowButtonUpFcn = @mouseBtnUp;
	h_fig.WindowButtonDownFcn = @sldBtnDown;
	h_sld = uicontrol(h_fig, 'Style', 'slider', 'Position', sldPosition);
	lh = addlistener(h_sld, 'ContinuousValueChange', @(src,evt) sldCallback(src,evt));

	function sldCallback(src, callbackData)
		display('ye')
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
		
		function r = withinBoundary(sld, mouse)
			sldPos = sld.Position;
			if sldPos(1) <= mouse(1) && mouse(1) <= sum(sldPos([1 3])) % x good
				if sldPos(2) <= mouse(2) && mouse(2) <= sum(sldPos([2 4])) % y good
					r = true;
					return
				end
			end
			r = false;
		end
		if withinBoundary(sld,mousePosition)
			% DO WHAT YOU LIKE
			src.WindowButtonMotionFcn = @mouseMotion;
		end
		src.UserData = 'BtnDownIsDone';
	end
	function mouseMotion(src,callbackData) %#ok<*INUSD>
		sld = findobj(src.Children, 'flat', 'type', 'uicontrol', '-and', 'style','slider');
		mousePos = src.CurrentPoint;
		sldLeftEnd = sld.Position(1) + SLD_END_SCROLL_WIDTH;
		sldRightEnd = sum(sld.Position([1 3])) - SLD_END_SCROLL_WIDTH;
		if mousePos(1) < sldLeftEnd
			mousePos(1) = sldLeftEnd;
		end
		if mousePos(1) > sldRightEnd
			mousePos(1) = sldRightEnd;
		end
		sld.Value = sld.Max;
		sldEffectiveWidth = (sld.Position(3) - 2 * SLD_END_SCROLL_WIDTH);
		mousePosRel = (mousePos(1) - sldLeftEnd) / sldEffectiveWidth;
		sld.Value = mousePosRel;
	end
	function mouseBtnUp(src,callbackData)
		while ~strcmpi(src.UserData, 'BtnDownIsDone')
			% wait for BtnDown to do its thing
		end
		src.WindowButtonMotionFcn = '';
	end
end