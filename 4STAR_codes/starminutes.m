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
% Modified (v1.2): by Samuel LeBlanc, NASA Ames, Santa Cruz, CA, 2016-09-28
%                  - added reading in of the starinfo files to get only the
%                  values in between the flight times and that are not
%                  parked with the correct file name
% -------------------------------------------------------------------------

%% Start of function
function starminutes(varargin);

if nargin==1;   
    day = varargin{1};
    dir=starpaths(day);
    fnn=[dir filesep day 'star.mat'];
elseif nargin==2;
    day = varargin{1};
    fnn = varargin{2};
else;
    [fname,pname]=uigetfile2(['*star.mat']);
    fnn=[pname fname];
end;

s=load(fnn);
version_set('1.1');
uu=fieldnames(s);
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

[ff,pp]=fileparts(fnn);
[daystr, filen, datatype, instrumentname]=starfilenames2daystr({fnn});
s.instrumentname = instrumentname;
disp(['Doing for day: ' daystr])
infofile_ = ['starinfo_' daystr '.m'];
infofile = fullfile(starpaths, ['starinfo' daystr '.m']);
if exist(infofile_)==2;
    infofnt = str2func(infofile_(1:end-2)); % Use function handle instead of eval for compiler compatibility
    try
        s = infofnt(s);
    catch
        eval([infofile_(1:end-2),'(s)']);
    end
else
    try;
        run(infofile);
    catch;
        disp('-------- Minutes represent entire file --------')
    return;
    end;
end;

try;
    ff = s.flight(1);
    disp(['flight time:' datestr(s.flight(1)) ', ' datestr(s.flight(2))])
catch;
    disp('-------- Minutes represent entire file --------')
    return;
end;

disp('*** Now for the minutes in flight ***')
t_park = 0.0;
for u=1:length(uu);
nn=findstr(uu{u},'vis');
    if nn; 
        kk=size(s.(uu{u}));
        [md,sh] = get_mode_val(uu{u});
        if kk(2)==1;
            if sh<0;
                t_sub = (s.(uu{u}).t>s.flight(1) & s.(uu{u}).t<s.flight(2) & s.(uu{u}).Md==md & (s.(uu{u}).Str==1|s.(uu{u}).Str==2));
            else;
                t_sub = (s.(uu{u}).t>s.flight(1) & s.(uu{u}).t<s.flight(2) & s.(uu{u}).Md==md & s.(uu{u}).Str==sh );
            end;
            if sum(t_sub)>0;
                t=calc_mins(s.(uu{u}).t(t_sub));
            end;
            tsubp = (s.(uu{u}).t>s.flight(1) & s.(uu{u}).t<s.flight(2) & s.(uu{u}).Str==0);
            if sum(tsubp)>0;
                t_park = t_park +calc_mins(s.(uu{u}).t(tsubp));
            end
            disp(['Minutes in ' uu{u} ': ' num2str(t) ' number:' num2str(kk(2))])
        else;
            t=0.0;
            for i=1:kk(2);
                if sh<0;
                    t_sub = (s.(uu{u})(i).t>s.flight(1) & s.(uu{u})(i).t<s.flight(2) & s.(uu{u})(i).Md==md & (s.(uu{u})(i).Str==1|s.(uu{u})(i).Str==2));
                else;
                    t_sub = (s.(uu{u})(i).t>s.flight(1) & s.(uu{u})(i).t<s.flight(2) & s.(uu{u})(i).Md==md & s.(uu{u})(i).Str==sh);
                end;
                if sum(t_sub)>0;
                    t=t+calc_mins(s.(uu{u})(i).t(t_sub));
                end;
                tsubp = (s.(uu{u})(i).t>s.flight(1) & s.(uu{u})(i).t<s.flight(2) & s.(uu{u})(i).Str==0);
                if sum(tsubp)>0;
                    t_park = t_park +calc_mins(s.(uu{u})(i).t(tsubp));
                end
            end;
            disp(['Minutes in ' uu{u} ': ' num2str(t) ' number:' num2str(kk(2))])
        end;
    end;
end;
disp(['Total Minutes parked: ' num2str(t_park)])

return;