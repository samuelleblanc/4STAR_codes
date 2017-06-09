function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

if isfield(s, 'toggle')
    s.toggle = update_toggle(s.toggle);
else
    s.toggle = update_toggle;
end

s.flight=[datenum(2016,5,11,23,03,06) datenum(2016,5,12,7,3,42)];  
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
s.dirty = [datenum(2016,5,12,7,33,20) datenum(2016,5,12,7,36,30)];
s.clean = [datenum(2016,5,12,8,04,30) datenum(2016,5,12,8,07,00)];

s.flagfilename = '20160511_starflag_man_created20160513_0415by_MS.mat'; 
% gases flags
s.flagfilenameCWV   = '20160511_starflag_CWV_man_created20170109_0459by_MS.mat';
s.flagfilenameO3    = '20160511_starflag_O3_man_created20170111_1342by_MS.mat';%'20160511_starflag_O3_man_created20170109_0501by_MS.mat';
s.flagfilenameNO2   = '20160511_starflag_NO2_man_created20170111_1346by_MS.mat';%'20160511_starflag_NO2_man_created20170109_0512by_MS.mat';
s.flagfilenameHCOH  = '20160511_starflag_HCOH_man_created20170109_0518by_MS.mat';

% extra uncertainty based on Connor's analysis
% from 2017-01-26: I  might be inclined to flag the entire flight as having AOD uncertain to 0.1 at 452 nm, mayb2e half that at 865 nm or 1 um, and perhaps 0.03 at 1.6 um.  But it is really just an educated guess.  
s.AODuncert_constant_extra = [0.1140    0.1000    0.0915    0.0884    0.0865    0.0838    0.0758    0.0740    0.0673    0.0566    0.0500    0.0414      0.0405    0.0396    0.0350    0.0309    0.0300];

%s.flag = starflags_20160511_CWV_MS_marks_ALL_20160523_0126;% runs a function.
% Ozone and other gases 
s.O3h=21; % guess 
% s.O3col=0.279; % omi  
% s.NO2col=2.0e15; % no omi data 
s.O3col=0.333;    % OMI O3 average along the track, Qin
s.NO2col=3.11e15;  % OMI NO2 average along the track 
 
s.sd_aero_crit=0.01;  
 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013.25;  
end; 
if isfield(s, 'Lon') & isfield(s, 'Lat'); 
    s.Lon(s.Lon==0 & s.Lat==0)=NaN; 
    s.Lat(s.Lon==0 & s.Lat==0)=NaN; 
end; 
if isfield(s, 'AZstep') & isfield(s, 'AZ_deg'); 
    s.AZ_deg=s.AZstep/(-50); 
end; 
 
% notes 
if isfield(s, 'note'); 
    s.note(end+1,1) = {['See ' mfilename '.m for additional info. ']}; 
end; 

%push variable to caller
% Bad coding practice to blind-push variables to the caller.  
% Creates potential for clobbering and makes collaborative coding more
% difficult because fields appear in caller memory space undeclared.

varNames=who();
for i=1:length(varNames)
    if ~strcmp(varNames{i},'s')
        assignin('caller',varNames{i},eval(varNames{i}));
    end
end;

return

function toggle_out = update_toggle(toggle_in)
% toggle_out = update_toggle(toggle_in)
% Merge the optional "toggle_in" with user-supplied values in toggle_out
% Frequently this instance will be shadowed by the internal function
% of the same name defined beneath starinfo files.

toggle_out.subsetting_Tint = true;
toggle_out.pca_filter = false;
toggle_out.verbose=true;
toggle_out.saveadditionalvariables=true;
toggle_out.savefigure=false;
toggle_out.computeerror=false;
toggle_out.inspectresults=false;
toggle_out.applynonlinearcorr=true;
toggle_out.applytempcorr=false;% true is for SEAC4RS data
toggle_out.gassubtract = true;
toggle_out.booleanflagging = false;
toggle_out.flagging = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.doflagging = false; % for running any Yohei style flagging
toggle_out.dostarflag = false; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = true;
toggle_out.applyforjcorr = false;
toggle_out.applystraycorr = false;

if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_in, toggle_out);
end

return