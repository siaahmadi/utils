function genericLinkedSelectCallback(ax,evnt,h)
SELECTION_COLOR = ones(1, 3) * .6;

	if interactivemode % don't want to override the function of interactive modes
		return
	end
% 	if evnt.Button == 2 % ignore middle clicks
% 		return
% 	end
	
	global plotidxSelectionGlobal
% 	persistent fineSel
% 	persistent currSel % TODO: persistent var's are shared among function calls, so this has to be embedded in |h|, otherwise if I have more than one figure everything will get messed up
% 	persistent pointsUnderRectangle
% 	persistent fineSelSet
% 	persistent dATM
	
	

	dATM = 'clickInitiated';
	if ~isfield(ax.UserData, 'stockX') % stocks haven't been initialized
		ax.UserData.stockX = [];
		ax.UserData.stockY = [];
	end
	if numel(h) > size(ax.UserData.stockX, 1)
		xdata = arrayfun(@(x) x.XData, h, 'UniformOutput', false); % this will give an error if both left and right mouse buttons are down. The behavior for this situation is currently undefined @date 9/10/15 4:02PM
		ydata = arrayfun(@(x) x.YData, h, 'UniformOutput', false);
	end
% 	h = ax.Children; %%%%%%%%%%%%%%%
% 	stockCData = arrayfun(@auxFunc_pullGObjectColor, h, 'UniformOutput', false);
% 	stockLW = arrayfun(@(x) x.LineWidth, h, 'UniformOutput', false);
	
	currSel = arrayfun(@(x) isfield(x.UserData, 'originalColor'), h);
	initSel = currSel;
	fineSel = arrayfun(@auxFunc_loadFineSel, h, 'UniformOutput', false); % read fine selection data
	if evnt.Button == 1 % reset |fineSel| with left mouse click
		auxFunc_resetFineSel(num2cell(h), fineSel);
	end
	if evnt.Button == 2 % for right-click, don't reset selection
		initFineSel = cellfun(@auxFunc_maskFineSel, num2cell(currSel), fineSel, 'UniformOutput', false);
	end
    % Start point
    sp = [];
    % Don't let things move while we're selecting
    ax.XLimMode = 'manual';
    ax.YLimMode = 'manual';
	if exist('r', 'var') && r.isvalid, delete(r), end;
    r = rectangle('Parent',ax, 'Position', [ax.CurrentPoint(1,1) ax.CurrentPoint(1,2) 0 0]);
    fig = ancestor(ax,'figure');
    fig.WindowButtonMotionFcn = @btnmotion;
    fig.WindowButtonUpFcn = @btnup;

	
    function btnmotion(~,~) % Figure's button motion function updates rectangle and highlight
		dATM = 'mouseMotion';
        cp = [ax.CurrentPoint(1,1), ...
              ax.CurrentPoint(1,2)];
        
		if isempty(sp) % new click has been initiated (as a deterministic automaton (dATM), this would correspond to prev. state being a click. In other words, the system has arrived in the current state not from a loop to this state).
            sp = cp;
		end
		
		% at any moment (i.e. dATM state) calculate what the
		% rectangle coordinates and size should be and set it:
        xmin = min([sp(1), cp(1)]);
        xmax = max([sp(1), cp(1)]);
        ymin = min([sp(2), cp(2)]);
        ymax = max([sp(2), cp(2)]);
        r.Position = [xmin, ymin, xmax-xmin, ymax-ymin];
		
		% first identify which individual points have been selected.
		pointsUnderRectangle = cellfun(@(x,y) xmin<=x & x<=xmax & ymin<=y & y<=ymax, xdata, ydata, 'UniformOutput', false);
		

		if evnt.Button == 2
			currSelSetsMidClick_Masked = currSel & cellfun(@any, pointsUnderRectangle);
			fineSel_ThisRectMasked = cellfun(@auxFunc_maskFineSel, num2cell(currSelSetsMidClick_Masked), pointsUnderRectangle, 'UniformOutput', false);
			fineSel = cellfun(@xor, initFineSel, fineSel_ThisRectMasked, 'UniformOutput', false);
			fineSelSet = cellfun(@any, fineSel);
			hh = num2cell(h);
			auxFunc_applySelectionColorGroupwise(h, currSel);
			cellfun(@(x, y) auxFunc_hiliteColor(x, x.CData, y), hh(fineSelSet), fineSel(fineSelSet));
% 			cellfun(@auxFunc_hiliteColor, hh(fineSelSet), stockCData(fineSelSet), fineSel_ThisRectMasked(fineSelSet));

			arrayfun(@auxFunc_saveLW, h(fineSelSet));
			arrayfun(@auxFunc_setallLW, h, fineSelSet);
			
			cellfun(@auxFunc_saveFineSel, hh, fineSel);
			return;
		end
		
		
		% now determine which parent data set they belong to
		currSel = cellfun(@any, pointsUnderRectangle);% data set under selection rectangle -- must be calculated before |if| block
		if evnt.Button == 3 && ~isempty(initSel) % "toggle" logic
			toBeTurnedOn = or(currSel, and(initSel, ~currSel)); % the ones that were selected to begin with, plus those selected that were previously unselected
			toBeTurnedOff = or(and(currSel, initSel), and(~initSel, ~toBeTurnedOn)); % this is not equivalent to |~toBeTurnedOn| because |toBeTurnedOn| is a naive variable--it doesn't assume the "toggle" logic just yet
			currSel = and(toBeTurnedOn, ~toBeTurnedOff); % this is where the "toggle" logic comes alive
		end
		
		% now it's only a matter of drawing the selection
		if any(evnt.Button == [1, 3]) % Only respond to left, middle and right clicks		
			auxFunc_applySelectionColorGroupwise(h, currSel);
			
% 			arrayfun(@auxFunc_saveLW, h(currSel & currSelMidClick & ~selSet));
% 			auxFunc_setallLW(h, currSel); % reset unselected groups' LW's
		end
	end

	function btnup(fig,~) % Figure's button up function cleans up
		dATM = 'clickTerminated';
		if any(~r.Position(3:4)) % dATM model: directly from BtnDown state (no MouseMotion)
			if evnt.Button ~= 2
				currSel(:) = false;
			end
			arrayfun(@auxFunc_restoreColor, h(~currSel));
			arrayfun(@auxFunc_setallLW, h, false(size(h))); % reset LW's
		end
        delete(r);
		
		xl = xlim; yl = ylim;
        ax.XLimMode = 'auto';
        ax.YLimMode = 'auto';
		xlim(xl); ylim(yl);
		
        fig.WindowButtonMotionFcn = ''; % don't call me again, unless reassigned (in this case, reassignment takes place at next ButtonDown)
        fig.WindowButtonUpFcn = '';		% don't call me again, unless reassigned (in this case, reassignment takes place at next ButtonDown)
		
		plotidxSelectionGlobal = currSel;
    end
end

function auxFunc_paleColor(h, c)
	c = auxFunc_desat(auxFunc_br(c));
	auxFunc_pushGObjectColor(h, c);
end

function auxFunc_applySelectionColorGroupwise(h, currSel)
	arrayfun(@auxFunc_saveColor, h(currSel));
	arrayfun(@(x) auxFunc_paleColor(x, x.UserData.originalColor), h(currSel));
	arrayfun(@auxFunc_restoreColor, h(~currSel));
end

function auxFunc_hiliteColor(h, c, idx)
	if ~exist('idx', 'var')
		idx = 1;
	end
	cc = zeros(size(h.CData));
	try
		cc(idx, :) = auxFunc_desat(brighten(c(idx, :), -0.65), 10);
		cc(~idx, :) = c(~idx, :);
	catch
		1;
	end
	auxFunc_pushGObjectColor(h, cc);
end

function y = auxFunc_maskFineSel(x, y)
	if ~x
		y(:) = false;
	end
end

function auxFunc_saveLW(h)
	if ~isfield(h.UserData, 'originalLW')
		h.UserData.originalLW = h.LineWidth; % different for Scatter, Line, etc?
	end
end

function auxFunc_setallLW(h, sel)
	if ~sel && isfield(h.UserData, 'originalLW') % these were selected but now have fallen out of selection rectangle
			h.LineWidth = h.UserData.originalLW; % different for Scatter, Line, etc?
			h.UserData = rmfield(h.UserData, 'originalLW');
	elseif sel % these are newly selected
		f = @(x) (1./sqrt(x+.5) + x).^1.5;
		h.LineWidth = f(h.UserData.originalLW); % different for Scatter, Line, etc?
	end	
end

function auxFunc_saveColor(h)
	if ~isfield(h.UserData, 'originalColor')
		h.UserData.originalColor = auxFunc_pullGObjectColor(h);
	end
end

function auxFunc_restoreColor(h)
	if isfield(h.UserData, 'originalColor')
		auxFunc_pushGObjectColor(h, h.UserData.originalColor);
		h.UserData = rmfield(h.UserData, 'originalColor'); % only selected objects should carry this field
	end
end

function x = auxFunc_br(x)
	x = brighten(x, .5);
end

function x = auxFunc_desat(x, ds)
	if ~exist('ds', 'var')
		ds = 0.25;
	end
	try
		iv = rgb2hsv(x);
	catch
		1;
	end
	if ds>1
		iv2 = atan(iv(:, 2) * ds)*2/pi;
	else
		iv2 = iv(:, 2) * ds;
	end
	iv(:, 2) = iv2;
	x = hsv2rgb(iv);
end

function c = auxFunc_pullGObjectColor(gobj)
	cfield = auxFunc_getGObjectColorField(gobj);
	
	c = eval(['gobj.' cfield]);
	
	if strcmp(cfield, 'CData')
		if isempty(c)
			if isa(gobj, 'matlab.graphics.chart.primitive.Scatter')
				c = gobj.MarkerEdgeColor;
			elseif isa(gobj, 'matlab.graphics.primitive.Patch')
				c = gobj.EdgeColor;
			end
		end
		if isnumeric(c)
			if numel(gobj.XData) ~= size(c, 1) % c is 1x3 while XData is bigger
				c = repmat(c(1,:), numel(gobj.XData), 1); % I don't think |c| can be other than a row vector at this point, but just in case
			end
		end
	end
end

function gobj = auxFunc_pushGObjectColor(gobj, c) %#ok<INUSD>
	cfield = auxFunc_getGObjectColorField(gobj);
	
	eval(['gobj.' cfield ' = c;']);
end

function str = auxFunc_getGObjectColorField(gobj)
	switch class(gobj)
		case 'matlab.graphics.chart.primitive.Scatter'
			str = 'CData';
		case 'matlab.graphics.primitive.Patch'
			str = 'CData';
		case 'matlab.graphics.chart.primitive.Histogram'
			str = 'EdgeColor';
		case 'matlab.graphics.chart.primitive.Area'
			str = 'EdgeColor';
		case 'matlab.graphics.chart.primitive.Bar'
			str = 'EdgeColor';
		case 'matlab.graphics.chart.primitive.Line'
			str = 'Color';
		otherwise
			error('color field name not identified for this particular object')
	end
end

function [c_new, idx] = auxFunc_toPaleInfo(x, currSelPoints)
	
end

function auxFunc_saveFineSel(h, sel)
	if any(sel)
		h.UserData.fineSel = sel;
	elseif isfield(h.UserData, 'fineSel')
		h.UserData = rmfield(h.UserData, 'fineSel');
	end
end

function fs = auxFunc_loadFineSel(h)
	if isfield(h.UserData, 'fineSel')
		fs = h.UserData.fineSel;
	else
		fs = false(size(h.XData));
	end
end

function auxFunc_resetFineSel(h, fineSel)
	fineSel = cellfun(@(x) auxFunc_maskFineSel(false(size(x)), x), fineSel, 'UniformOutput', false);
	cellfun(@auxFunc_saveFineSel, h, fineSel);
end