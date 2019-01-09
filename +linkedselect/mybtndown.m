function mybtndown(ax,~,xdata,ydata,s,h)
  % Start point
  sp = [];
  % Don't let things move while we're selecting
  ax.XLimMode = 'manual';
  ax.YLimMode = 'manual';
  %
  % 1) Create the rectangle
  r = rectangle('Parent',ax);
  %
  % 2) Figure's button motion function updates rectangle and highlight
  fig = ancestor(ax,'figure');
  fig.WindowButtonMotionFcn = @btnmotion;
  function btnmotion(~,~)
    cp = [ax.CurrentPoint(1,1:2)'];
    if isempty(sp)
        sp = cp;
    end
    % Make the rectangle go from sp to cp
    xmin = min([sp(1), cp(1)]);
    xmax = max([sp(1), cp(1)]);
    ymin = min([sp(2), cp(2)]);
    ymax = max([sp(2), cp(2)]);
    r.Position = [xmin, ymin, xmax-xmin, ymax-ymin];
    % Identify all of the data points inside the rectangle
    mask = xdata>=xmin & xdata<=xmax & ydata>=ymin & ydata<=ymax;
    % And highlight them in both charts
    for i=1:length(h)
        h(i).XData = s(i).XData(mask);
        h(i).YData = s(i).YData(mask);
    end
  end
  %
  % 3) Figure's button up function cleans up
  fig.WindowButtonUpFcn = @btnup;
  function btnup(fig,~)
    delete(r);
    ax.XLimMode = 'auto';
    ax.YLimMode = 'auto';
    fig.WindowButtonMotionFcn = '';
    fig.WindowButtonUpFcn = '';
  end
end