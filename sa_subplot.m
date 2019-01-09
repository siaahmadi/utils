function [hSub, subplotCoords] = sa_subplot(layout, sizes, targetplot)
% layout could also be named "relative" or "within-subplot" size

margins.left = 0.1;
margins.right = .1;
margins.top = 0.1;
margins.bottom = .1;
margins.mid = 0.05;

subplotCoords = getsubplotCoords(layout, sizes, targetplot, margins);
hSub = subplot('Position', subplotCoords);


function subplotCoords = getsubplotCoords(layout, sizes, targetplot, margins)

% layout and sizes must have the exact same nested shape

if isempty(targetplot) % equivalently, if isempty(sizes{2})
	totalHeight = 1 - margins.top - margins.bottom;
	totalWidth = 1 - margins.left - margins.right;
	
	if isequal(sizes{1}, [1, 1])
		subplotCoords = [margins.left margins.bottom totalHeight totalWidth];
	else
		subplotCoords = [0 0 totalHeight+margins.bottom totalWidth+margins.left];
	end
else
	if length(targetplot) > 1
		newSizes =sizes{sub2ind(size(sizes), targetplot{1}(1), targetplot{1}(2))};
		newLayout = layout(2:end);
		subplotCoords = getsubplotCoords(newLayout, newSizes,targetplot(2:end), margins);

		% add margins and convert width and height to new values
		currLayout = layout{1}; currTarget = targetplot{1};
		returnSubplotScale = currLayout{sub2ind(size(currLayout), currTarget(1), currTarget(2))};
		subplotCoords(3:4) = returnSubplotScale.*subplotCoords(3:4);

		bottomBlockNum = size(sizes, 1) - targetplot{1}(1); % cuz matlab counts from bottom of figure
		leftBlockNum = targetplot{1}(2) - 1;
		bottomBlockHeight = sum(cellfun(@elem, layout{1}(targetplot{1}(1)+1:end), rempat({1}, layout{1}(targetplot{1}(1)+1:end))));
		leftBlockWidth = sum(cellfun(@elem, layout{1}(1:leftBlockNum-1), rempat({2}, size(layout{1}(1:leftBlockNum-1)))));
		x = leftBlockWidth + leftBlockNum*margins.mid;
		y = bottomBlockHeight + bottomBlockNum*margins.mid;

		subplotCoords(1) = x;
		subplotCoords(2) = y;
	else
		layout = layout{1}; targetplot = targetplot{1};
		bottomBlockHeight = sum(cellfun(@elem, layout(targetplot(1)+1:end, targetplot(2)), repmat({1}, size(layout(targetplot(1)+1:end, targetplot(2))))));
		leftBlockWidth = sum(cellfun(@elem, layout(targetplot(1), 1:targetplot(2)-1), repmat({2}, size(layout(targetplot(1), 1:targetplot(2)-1)))));

		subplotSize = layout(targetplot(1), targetplot(2)); subplotSize = subplotSize{1};
		if targetplot(1) == size(layout, 1)
			y = bottomBlockHeight; % which would be zero
		else % TODO: add mid margins based on the number of subplots
			y = margins.mid*(size(layout,1)-targetplot(1)) + bottomBlockHeight;
		end
		if targetplot(2) == 1
			x = leftBlockWidth; % which would be zero
		else % TODO: add mid margins based on the number of subplots
			x = margins.mid*(targetplot(2)-1) + leftBlockWidth;
		end
		
		subplotCoords = [x y subplotSize(1)-margins.mid subplotSize(2)-margins.mid];
	end
end