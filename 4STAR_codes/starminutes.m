%% PURPOSE:
%   Generates the amount of minutes spanning the measurement period
%   loads one starmat file, and output all the times from the different
%   methods
%
% CALLING SEQUENCE:
%   starminutes(day)
%
% INPUT:
%  - day: yyyymmdd used in starload
% 
% OUTPUT:
%  - printed values of minutes per starmat, per variable
%
% DEPENDENCIES:
%  t2utch.m : to transfer t to Hours of utc
%  calc_mins.m : to obtain the amount of minutes for one t
%  version_set.m : to have version control of this m-script
%
% NEEDED FILES:
%  - yyyymmddstar.mat: 
%
% EXAMPLE:
%  starminutes
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, Fairbanks, Alaska, Sep-16, 2014
% Modified (v1.0): by Samuel LeBlanc, NASA Ames, October 13th, 2014
%                  - added version control of this m-script using version_set
% -------------------------------------------------------------------------

%% Start of function
function starminutes(day);

if nargin < 1;
  [fname,pname]=uigetfile(['*star.mat'])
  fnn=[pname fname];
else;
  dir=starpaths(day);
  fnn=[dir filesep day 'star.mat'];
end;

s=load(fnn);
version_set('1.0');
uu=fieldnames(s)
for u=1:length(uu);
nn=findstr(uu{u},'vis');
    if nn; 
        kk=size(s.(uu{u}));
        if kk(2)==1;
          t=calc_mins(s.(uu{u}).t);
          disp(['Minutes in ' uu{u} ': ' num2str(t) ' number:' num2str(kk(2))])
        else;
          t=0.0;  
          for i=1:kk(2);
              t=t+calc_mins(s.(uu{u})(i).t);
          end;
          disp(['Minutes in ' uu{u} ': ' num2str(t) ' number:' num2str(kk(2))])
        end;
    end;
end;

return;