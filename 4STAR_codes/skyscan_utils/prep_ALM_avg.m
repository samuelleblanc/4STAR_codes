function [s_] = prep_ALM_avg(s);
% [s_] = prep_ALM_avg(s);
% Produce an "average" of the two Almucantar legs.
% This isn't perfectly defined in the case of 4STAR since the legs may
% vary due to aircraft motion etc.
% For the points closest matched in SA we report:
% s_ averaged for most quantities including time, SA, El, and radiances
% Az is not averaged but is instead the Az from alm_A shifted by dAz to
% correspond to the mean SA.
% Connor, 2021-04-09: modified to support aod values in "extras"

suns_ii = find(s.Str==1&s.Zn==0); sun_ii = [];
if ~isempty(suns_ii)
    sun_ii = suns_ii(1);
end
sun = false(size(s.t)); sun(sun_ii) = true;
almA_ii = find(sun|(s.good_almA&~any(isNaN(s.skyrad(:,s.aeronetcols)),2)& s.SA>=3.5)); 
almB_ii = find(sun|(s.good_almB&~any(isNaN(s.skyrad(:,s.aeronetcols)),2)& s.SA>=3.5));
if ~isempty(almA_ii)&&~isempty(almB_ii)
[inA, inB] = nearest(s.SA(almA_ii), s.SA(almB_ii),2); 
inA_ii = almA_ii(inA);
inB_ii = almB_ii(inB);

s_ = s;
flds = fieldnames(s);
for f = 1:length(flds)
   ss = sprintf('%s',[flds{f}]);
   if size(s.(flds{f}),1)==size(s.t,1) && size(s.(flds{f}),2)==1 % if single-dimensioned against time
      s_.(flds{f}) = mean([s.(flds{f})(inA_ii),s.(flds{f})(inB_ii)],2); 
   elseif size(s.(flds{f}),1)==1 && size(s.(flds{f}),2)==size(s.w,2) % if single-dimensioned against w
      s_.(flds{f}) = s.(flds{f});
   elseif length(size(s.(flds{f})))==2 && all(size(s.(flds{f}))==size(s.aeronetcols)) % if dimensioned for aeronetcols
      s_.(flds{f}) = s.(flds{f});
   elseif size(s.(flds{f}),1)==size(s.t,1) && size(s.(flds{f}),2)==size(s.w,2) % if time x w
      if islogical(s.(flds{f}))
         s_.(flds{f}) = s.(flds{f})(inA_ii,:)|s.(flds{f})(inB_ii,:);
         ss = [ss,sprintf('%s',' (logical OR t x w)')];
      else
         s_.(flds{f}) = (s.(flds{f})(inA_ii,:)+s.(flds{f})(inB_ii,:))./2;
         ss = [ss,sprintf('%s',' mean(t x w)')];
      end
   elseif size(s.(flds{f}),1)==size(s.t,1) && size(s.(flds{f}),2)==size(s.wl_ii,2) % if time x wl_ii
      if islogical(s.(flds{f}))
         s_.(flds{f}) = s.(flds{f})(inA_ii,:)|s.(flds{f})(inB_ii,:);
         ss = [ss,sprintf('%s',' (logical OR t x w)')];
      else
         s_.(flds{f}) = (s.(flds{f})(inA_ii,:)+s.(flds{f})(inB_ii,:))./2;
         ss = [ss,sprintf('%s',' mean(t x w)')];
      end
   elseif numel(s.(flds{f}))==1  % if unary
      s_.(flds{f}) = s.(flds{f});      
   else
      ss = [ss,sprintf('%s',': not handled')];
   end
%    if s.toggle.verbose; disp(ss); end
end
s_.filename = s.filename;
s_.instrumentname = s.instrumentname;
s_.w_isubset_for_polyfit = s.w_isubset_for_polyfit; 
s_.tau_aero_polynomial= s.tau_aero_polynomial;

s_.SA = real(s.SA(inA_ii) + s.SA(almB_ii(inB)))./2;
dSA = (s.SA(inA_ii) - s.SA(almB_ii(inB)))./2;
dAz = dSA./mean(cosd(s.sunel(inA_ii)));
s_.Az_gnd = s.Az_gnd(inA_ii)-dAz;
else
    s_ = [];
end

return
