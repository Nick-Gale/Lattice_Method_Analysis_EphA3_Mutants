function plot_orientation(h1, h2, field_coords, coll_coords, dv);

    
for i=1:3
   ccolour(1, :)=[1 0.5 0];
   ccolour(2, :)=[0 1 1];
   ccolour(3, :)=[0.45 0.225 0];
   
   I=find(field_coords(:, 2) > dv(i) - 0.1 & field_coords(:, 2) < dv(i) + 0.1);
   % disp(size(I))
   min_fieldnt = min(field_coords(I, 1));
   max_fieldnt = max(field_coords(I, 1));
   % find best linear fit to projection from retina

   if length(I) > 0
      F = polyfit(coll_coords(I, 1), coll_coords(I, 2), 1);
      min_collrc = min(coll_coords(I, 1));
      max_collrc = max(coll_coords(I, 1));	
      min_collml = F(1) * min_collrc + F(2);
      max_collml = F(1) * max_collrc + F(2);
      subplot(h2);
      hold on
      line([min_fieldnt max_fieldnt], [dv(i) dv(i)], 'LineWidth', 2, 'Color', ccolour(i, :));
      line([max_fieldnt max_fieldnt], [dv(i) dv(i)], 'Marker', '<' ,'Color', 'k');
      subplot(h1)
      hold on
      line([min_collrc max_collrc], [min_collml max_collml],'LineWidth',2,'Color',ccolour(i, :));
      line([min_collrc min_collrc + 0.01], [min_collml min_collml], 'Marker', '<', 'Color', 'k');
   else
      disp("Warning: too few points for line estimation")
   end
end		 
