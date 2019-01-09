function linked_scatter(t)
    ncol = size(t,2) / 2;
    a = gobjects(1,ncol);
    s = gobjects(1,ncol);
    h = gobjects(1,ncol);
    % For each 2 columns of data ...
    for i=1:ncol
        a(i) = subplot(1,ncol,i);
        % ... create a scatter chart ...
        s(i) = scatter(nan,nan,'filled');
        s(i).PickableParts = 'none';
        s(i).MarkerFaceColor = a(i).ColorOrder(1,:);
        % ... and add a second scatter chart for highlightin.
        hold(a(i),'on');
        h(i) = scatter(nan,nan,'filled');
        h(i).PickableParts = 'none';
        h(i).SizeData = 50;
        h(i).MarkerFaceColor = a(i).ColorOrder(2,:);
    end
    % Go back and add data and a Hit event listener to each.
    for i=1:ncol
        c1 = 2*i-1;
        c2 = 2*i;
        xdata = table2array(t(:,c1));
        ydata = table2array(t(:,c2));
        s(i).XData = xdata;
        s(i).YData = ydata;
        if length(t.Properties.VariableNames) >= c2
            xlabel(a(i),t.Properties.VariableNames{c1});
            ylabel(a(i),t.Properties.VariableNames{c2});
        end
        addlistener(a(i),'Hit',@(~,evd)mybtndown(a(i),evd,xdata,ydata,s,h));
    end
end

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
        cp = [ax.CurrentPoint(1,1), ...
              ax.CurrentPoint(1,2)];
        if isempty(sp)
            sp = cp;
        end
        xmin = min([sp(1), cp(1)]);
        xmax = max([sp(1), cp(1)]);
        ymin = min([sp(2), cp(2)]);
        ymax = max([sp(2), cp(2)]);
        r.Position = [xmin, ymin, xmax-xmin, ymax-ymin];
        mask = xdata>=xmin & xdata<=xmax & ydata>=ymin & ydata<=ymax;
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

