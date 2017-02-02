function these = scale_marker( these,sf)
% This function accepts handles to plotted symbols and scales their size

if ~exist('sf','var')||isempty(sf)|(sf<0)
    sf = 0.5;
end
for i = 1:length(these)
   ms = get(these(i),'markersize'); 
   set(these(i),'markersize',get(these(i),'markersize').*sf)   
end

return

