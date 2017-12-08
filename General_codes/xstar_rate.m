function cts =xstar_rate(cts, time, shutter, tint)
% rate =xstar_rate(cts, time, shutter, tint)
% Compute dark-subtracted rate in cts/ms.  
% Dark counts are determined for each integration timek, linearly intepolated between 
% measurements, and 'nearest neighbor' applied outside bracketed darks.
% This routine is independent of spectrometer.
if exist('tint','var') tint = round(tint);end
tints = unique(tint); dints = unique(tint(shutter==0));
if length(dints)<length(tints)
   warning('xstar_rate expects darks at each integration time!')
end
fig = figure_; 
for ti = length(tints):-1:1
   these = plot([1:size(cts,2)],cts(shutter==0&tint==tints(ti),:),'-'); 
   if length(these)>1 recolor(these,find(shutter==0&tint==tints(ti)));end
   title(['Dark counts for Tint=',sprintf('%g ms',tints(ti))]);
%    close(gcf);
%    pause(.1)
   %    ok = menu('Continue...','Go');
   dark.t = time(shutter==0&tint==tints(ti)); dark.cts = cts(shutter==0&tint==tints(ti),:);
   % Linearly interpolate between darks.
   if length(these)>1
      darks = interp1(dark.t, dark.cts, time(shutter~=0&tint==tints(ti)),'linear');
      lights_ii = find(shutter~=0 & tint==tints(ti));
      ool = interp1(dark.t, ones(size(dark.t)), time(lights_ii),'nearest'); ool = isNaN(ool);
      if any(ool)
         darks(ool,:) = interp1(dark.t, dark.cts, time(lights_ii(ool)),'nearest','extrap');
      end
      % subtract the darks for this integration time
      cts(shutter~=0&tint==tints(ti),:) = cts(shutter~=0&tint==tints(ti),:) - darks;
      
   elseif length(these)==1
      darks = ones(size(time(shutter~=0&tint==tints(ti))))*dark.cts;
      % subtract the darks for this integration time
      cts(shutter~=0&tint==tints(ti),:) = cts(shutter~=0&tint==tints(ti),:) - darks;
   end
   % Then identify records outside of limits (ool) and use nearest
   end
% divide dark-subtracted values by integration time to get rate
cts = cts ./ (tint*ones([1,size(cts,2)]));
figure_(fig);
close(fig);
return