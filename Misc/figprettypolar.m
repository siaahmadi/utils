ax = gca;
ax_fig = ancestor(ax, 'figure');

ax.FontName = 'Arial';
ax.FontSize = 16;
ax.Box = 'off';
ax.TickDir = 'out';
ax.YTick = [min(ax.YLim), min(ax.YLim) + range(ax.YLim) / 2, max(ax.YLim)];

%%
h_alltext = findall(ax_fig,'type','text', '-and', 'Parent', ax);
set(h_alltext, 'FontSize', 11);
unnecessary_text = findall(h_alltext, '-not', {'String', '0', '-or', 'String', '90', '-or', 'String', '180', '-or', 'String', '270'}, '-and', 'Parent', ax, '-and', {'-not', 'tag', 'keep'});
delete(unnecessary_text)
good_text = findall(setdiff(h_alltext, unnecessary_text), 'Parent', ax);
text_0 = findall(good_text, 'String', '0');
text_90 = findall(good_text, 'String', '90');
text_180 = findall(good_text, 'String', '180');
text_270 = findall(good_text, 'String', '270');

set(text_0, 'HorizontalAlignment', 'left');
set(text_0, 'VerticalAlignment', 'baseline');
set(text_90, 'VerticalAlignment', 'baseline');
set(text_180, 'HorizontalAlignment', 'right');
set(text_180, 'VerticalAlignment', 'cap');
set(text_270, 'VerticalAlignment', 'cap');