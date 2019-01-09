function [h_line, h_text] = placeSignificanceStars(h, pval)
% Works for two as of right now

c = 'k';
numStars = abs(ceil(log10(pval+eps)));
if numStars > 4
	numStars = 4;
	c = 'r';
end

y = h.YData;
x = h.XData;
if all(y >= 0)
	[tp, I] = max(y + h.UData);

	h_line = plot([x(1) x(1) x(2) x(2)], [1.1*abs(tp) 1.2*abs(tp) 1.2*abs(tp) 1.1*abs(tp)]-circshift([0 0 abs(diff(y)) abs(diff(y))],(I-1)*2,2), 'k', 'LineWidth', 1);
	if pval < 0.05 % is significant
		h_text = text(mean(x), 1.2*abs(tp)-abs(diff(y))/2, repmat('*', 1,numStars), 'VerticalAlignment', 'Bottom', 'FontSize', 18, 'Color', c, 'HorizontalAlignment', 'center');
	else
		h_text = text(mean(x), 1.2*abs(tp)-abs(diff(y))/2, 'n.s.', 'VerticalAlignment', 'Bottom', 'FontSize', 18, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
	end
elseif any(y >= 0) && any(y < 0)
	 y = abs(y);
	 u = h.UData;
	 l = h.LData;
	 b = max([l(:); u(:)]);
	[tp, I] = max(y + b);

	h_line = plot([x(1) x(1) x(2) x(2)], [1.1*abs(tp) 1.2*abs(tp) 1.2*abs(tp) 1.1*abs(tp)]-circshift([0 0 abs(diff(y)) abs(diff(y))],(I-1)*2,2), 'k', 'LineWidth', 1);
	if pval < 0.05 % is significant
		h_text = text(mean(x), 1.2*abs(tp)-abs(diff(y))/2, repmat('*', 1,numStars), 'VerticalAlignment', 'Bottom', 'FontSize', 18, 'Color', c, 'HorizontalAlignment', 'center');
	else
		h_text = text(mean(x), 1.2*abs(tp)-abs(diff(y))/2, 'n.s.', 'VerticalAlignment', 'Bottom', 'FontSize', 18, 'FontName', 'Arial');
	end
elseif all(y < 0)
	[tp, I] = min(y - h.LData);

	h_line = plot([x(1) x(1) x(2) x(2)], -[1.1*abs(tp) 1.2*abs(tp) 1.2*abs(tp) 1.1*abs(tp)]-circshift([0 0 abs(diff(y)) abs(diff(y))],(2-I)*2,2), 'k', 'LineWidth', 1);
	if pval < 0.05 % is significant
		h_text = text(mean(x), (-1.2*abs(tp)-abs(diff(y))/2), repmat('*', 1,numStars), 'VerticalAlignment', 'Bottom', 'FontSize', 18, 'Color', c, 'HorizontalAlignment', 'center');
	else
		h_text = text(mean(x), (-1.2*abs(tp)-abs(diff(y))/2), 'n.s.', 'VerticalAlignment', 'Top', 'FontSize', 18, 'FontName', 'Arial', 'HorizontalAlignment', 'center');
	end
end
