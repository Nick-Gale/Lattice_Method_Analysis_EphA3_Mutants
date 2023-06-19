function draw_crosshairs(s) 
    % Draw crosshairs, given structure s, which can be params.field or params.coll. 
       xmin = s.XLim(1);
       xmax = s.XLim(2);
       ymin = s.YLim(1);
       ymax = s.YLim(2);
       xmean=mean([xmin xmax]);
       ymean=mean([ymin ymax]);
   
       plot([xmean xmean], [ymin ymax], 'Color', [0.7 0.7 0.7], 'Linewidth', 1);
       hold on
       plot([xmin xmax], [ymean ymean], 'Color', [0.7 0.7 0.7], 'Linewidth', 1);
end