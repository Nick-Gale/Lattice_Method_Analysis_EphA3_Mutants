function set_axis_props(s)
% SET_AXIS_PROPS - Set default axis properties.
%   The input argument s is either  params.field or
%   params.coll. 
%   
% See also  getparams, plot_figure3, plot_figure5

% Set axis properties
set(gca, 'XTick', s.XTick, ...
         'YTick', s.YTick, ...
         'XTickLabel', s.XTickLabel, ...
         'YTickLabel', s.YTickLabel)
if (s.FlipY)
    axis ij
else
    axis xy
end
set(gca,'PlotBoxAspectRatio',[1 1 1])
axis([s.XLim s.YLim]);

% Local Variables:
% matlab-indent-level: 4
% End:
