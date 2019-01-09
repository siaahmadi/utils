function update(obj)

t = obj.t;
x = obj.x;
y = obj.y;
sld1 = findobj(ancestor(obj.h_path, 'Figure'), 'style', 'slider', 'tag', '1');
sld2 = findobj(ancestor(obj.h_path, 'Figure'), 'style', 'slider', 'tag', '2');

ind1 = closestPoint(t, 1:length(t), t(1)+(t(end)-t(1))*sld1.Value);
ind2 = closestPoint(t, 1:length(t), t(1)+(t(end)-t(1))*sld2.Value);
obj.h_path.XData = x(ind1:ind2);
obj.h_path.YData = y(ind1:ind2);