function rotxticklabel(cfh, xticks, labels)
set(cfh,'XTick',xticks,'XTickLabel','')
hx = get(cfh,'XLabel');  % Handle to xlabel 
set(hx,'Units','data');
pos = get(hx,'Position');
y = pos(2);

% Place the new labels 
for i = 1:size(labels,1)
    t(i) = text(xticks(i),y,labels(i,:));
end

set(t,'Rotation',90,'HorizontalAlignment','right')  
