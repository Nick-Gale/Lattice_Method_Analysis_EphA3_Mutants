function draw_scalebar(s, varargin)
% DRAW_SCALEBAR - Add scalebar to plot
%   The input argument s is either  params.field or
%   params.coll. The properties 'XLim', 'YLim', 'scale' and
%   'colour' can be overridden by setting properties.
%   
% See also  getparams, plot_figure3, plot_figure5
%

if (nargin >= 2) 
    p = validateInput(varargin, {'XLim', 'YLim', 'scale', ...
                        'colour'});
else
    p = struct();
end
xlim = s.XLim;
ylim = s.YLim;
scale = s.scale;
colour = 'k';
if (isfield(p, 'XLim')) 
    xlim = p.XLim;
end
if (isfield(p, 'YLim')) 
    ylim = p.YLim;
end
if (isfield(p, 'scale')) 
    scale = p.scale;
end
if (isfield(p, 'colour')) 
    colour = p.colour;
end

% Draw scalebar
xmin = xlim(1);
xmax = xlim(2);
ymin = ylim(1);
ymax = ylim(2);
yfrac = 0.05;
if s.FlipY
    yfrac = 0.95;
end
if (s.scalebar > 0) 
    plot(xmin + 0.05*(xmax - xmin) + ...
         [0 s.scalebar/scale], ...
         (ymin + yfrac*(ymax - ymin))*ones(1, 2), ...
         colour, 'LineWidth', 3) %scale bar
end

% Local Variables:
% matlab-indent-level: 4
% End:
