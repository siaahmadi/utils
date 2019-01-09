% some code from older version remains in here in case I wanted to revert
% to that version or rewview the algorithm
% @date 9/10/15 1:17PM

function genericLinkedSelectCallback(ax,evnt,h)
SELECTION_COLOR = ones(1, 3) * .6;

	if interactivemode % don't want to override the function of interactive modes
		return
	end
	if evnt.Button == 2 % ignore middle clicks
		return
	end
	
	global plotidxSelectionGlobal
	persistent currSel % TODO: this has to be embedded in |h|, otherwise if I have more than one figure everything will get messed up

	if ~isfield(ax.UserData, 'stockX') % stocks haven't been initialized
		ax.UserData.stockX = [];
		ax.UserData.stockY = [];
	end
	if numel(h) > size(ax.UserData.stockX, 1)
		xdata = arrayfun(@(x) x.XData, h, 'UniformOutput', false);
		ydata = arrayfun(@(x) x.YData, h, 'UniformOutput', false);
		ax.UserData.stockX = [ax.UserData.stockX; xdata];
		ax.UserData.stockY = [ax.UserData.stockY; ydata];
	end
	% TODO: gotta rewrite the whole thing. The following works only if all
	% objects have the same number of points, which need not be the case in
	% general.
	xdata = ax.UserData.stockX; % recall most up-to-date data and format xdata
	ydata = ax.UserData.stockY; % recall most up-to-date data and format ydata
	
	
	initSel = currSel;
	initUnsel = setdiff(1:size(ydata,1), initSel);
    % Start point
    sp = [];
    % Don't let things move while we're selecting
    ax.XLimMode = 'manual';
    ax.YLimMode = 'manual';
    r = rectangle('Parent',ax, 'Position', [ax.CurrentPoint(1,1) ax.CurrentPoint(1,2) 0 0]);
    fig = ancestor(ax,'figure');
    fig.WindowButtonMotionFcn = @btnmotion;
    fig.WindowButtonUpFcn = @btnup;
    %
    % 1) Figure's button motion function updates rectangle and highlight
    function btnmotion(~,~)
        cp = [ax.CurrentPoint(1,1), ...
              ax.CurrentPoint(1,2)];
        
		if isempty(sp) % new click has been initiated (in analogy to a Markov chain model, this would correspond to prev. state being a click. In other words, the system has arrived in the current state not from a loop to this state).
            sp = cp;
		end
		
		% at any moment (i.e. Markov chain state) calculate what the
		% rectangle coordinates and size should be and set it:
        xmin = min([sp(1), cp(1)]);
        xmax = max([sp(1), cp(1)]);
        ymin = min([sp(2), cp(2)]);
        ymax = max([sp(2), cp(2)]);
        r.Position = [xmin, ymin, xmax-xmin, ymax-ymin];
		
		%%%% This block needs to be changed for this function to be
		%%%% generic. The future logic is as follows: here, we first
		%%%% identify which individual points have been selected. Next, it
		%%%% is determined which parent data set they belong to (this could
		%%%% be a matrix column, Line, Scatter, etc, object). Then the rest
		%%%% of the code is processed with that information.
		% find out which data set is under selection rectangle
		currSelPoints = cellfun(@(x,y) xmin<=x & x<=xmax & ymin<=y & y<=ymax, xdata, ydata, 'UniformOutput', false);
		currSel = (cellfun(@any, currSelPoints));
		
		%%%%
		
		if evnt.Button == 3 && ~isempty(initSel)
			toBeTurnedOn = union(currSel, setdiff(initSel, currSel));
			toBeTurnedOff = union(intersect(currSel, initSel), setdiff(initUnsel,toBeTurnedOn));
			currSel = setdiff(toBeTurnedOn, toBeTurnedOff);
			if ~isempty(toBeTurnedOn)
				j = 0;
				for i = toBeTurnedOn
					j = j + 1;
					try %#ok<TRYNC>
						h(i).YData = ydata(:, toBeTurnedOn(j));
					end
				end
			end
			if ~isempty(toBeTurnedOff)
				for i = toBeTurnedOff
					try %#ok<TRYNC>
						h(i).YData = nan(1,size(ydata, 1));
					end
				end
			end
		elseif evnt.Button == 1 || (isempty(initSel) && evnt.Button==3) % for an unknown reason this used to be "evnt.Button~=2" | changed on 9/9/15 @8:42PM
			arrayfun(@auxFunc_saveColor, h(currSel));
			arrayfun(@(x) auxFunc_assignColor(x, SELECTION_COLOR), h(currSel));
			arrayfun(@auxFunc_recallColor, h(~currSel));

% 			j = 0;
% 			for i = currSel
% 				j = j + 1;
% 				try %#ok<TRYNC>
% 					h(i).YData = ydata(:, currSel(j));
% 				end
% 			end
% 			for i =  % un-highlight graphs that aren't currently in rectangle
% 				h(i).YData = nan(1,size(ydata, 1));
% 			end
		end
	end
    %
    % 2) Figure's button up function cleans up
    function btnup(fig,~)
		if any(~r.Position(3:4)) % Markov chain model: directly from BtnDown state (no MouseMotion)
			currSel(:) = false;
			arrayfun(@auxFunc_recallColor, h(~currSel));
% 			for i = 1:length(h)
% 				h(i).YData = nan(1,size(ydata, 1));
% 			end
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

function auxFunc_assignColor(x, y)
	x.Color = y;
end

function auxFunc_saveColor(h)
	if ~isfield(h.UserData, 'originalColor')
		h.UserData.originalColor = h.Color;
	end
end

function auxFunc_recallColor(h)
	if isfield(h.UserData, 'originalColor')
		h.Color = h.UserData.originalColor;
	end
end