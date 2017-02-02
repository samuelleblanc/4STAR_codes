function these = lighten( these,sf)
% This function accepts handles to plotted symbols or lines and "lightens"
% them by decreasing their saturation value

if ~exist('sf','var')||isempty(sf)|(sf<0)
    sf = 0.25;
end
for i = 1:length(these)
   mc = get(these(i),'color'); 
   mc = rgb2hsv(mc); 
   mc(2) = sf.*mc(2);
   mc = hsv2rgb(mc);
   set(these(i),'color',mc);
end

return

