%% PURPOSE:
%   Generates the amount of minutes spanning the measurement period
%   For accounting purposes
%
% CALLING SEQUENCE:
%   mins=calc_mins(t)
%
% INPUT:
%   - t: in matlab time format
% 
% OUTPUT:
%  - mins: scalar of amount of minutes
%
% DEPENDENCIES:
%  t2utch.m : to transfer t to Hours of utc
%  version_set.m: for version control
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  mins=calc_mins(vis_sun.t)
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, Fairbanks, Alaska, Sep-16, 2014
% Modified (v1.0): By Samuel LeBlanc, NASA Ames, Oct-13, 2014
%                  - added version control of this m-script via version_set
%
% -------------------------------------------------------------------------

%% Start of function
function mins=calc_mins(t);
version_set('1.0');

utc=t2utch(sort(t));
mm=(utc-utc(1))*60.;
dt=diff(mm);

ii=find(dt>2.0);
if length(ii)>=1
  tt=mm(ii(1))-mm(1);
  if length(ii)>1
    for i=1:length(ii)-1
      tt=tt+mm(ii(i+1))-mm(ii(i)+1);
    end; i=i+1;
  else; i=1; end;
  tt=tt+mm(end)-mm(ii(i)+1);
else; tt=mm(end)-mm(1); end;
mins=tt;
return;
