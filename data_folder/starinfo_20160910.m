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

s.flight=[datenum(2016,9,10,7,31,25) datenum(2016,9,10,15,24,55)]; 
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
s.langley=[datenum(2016,9,10,05,26,00) datenum(2016,9,10,06,52,00)];
langley1=[datenum(2016,9,10,05,26,00) datenum(2016,9,10,06,52,00)];% langley1=[datenum(2016,9,10,05,20,00) datenum(2016,9,10,06,52,00)]; %full langley-- airmass ~15?

s.dirty = [datenum(2016,9,10,06,24,00) datenum(2016,9,10,06,28,30)];
s.clean = [datenum(2016,9,10,06,44,00) datenum(2016,9,10,06,47,00)];
 
% Ozone and other gases 
s.O3h=21; % 
s.O3col=0.300; % Michal's guess     
s.NO2col=2.0e15; % % 

% flags
s.flagfilenameCWV  = '20160910_starflag_CWV_man_created20161017_1501by_MS.mat';
s.flagfilenameO3   = '20160910_starflag_O3_man_created20161017_1502by_MS.mat';
s.flagfilenameNO2  = '20160910_starflag_NO2_man_created20161017_1506by_MS.mat';
s.flagfilenameHCOH = '20160910_starflag_HCOH_man_created20161017_1508by_MS.mat';

 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=680.25;  
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
% un-test commit michal 2016-05-08

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
toggle_out.booleanflagging = true;
toggle_out.starflag_mode = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.flagging = toggle_out.starflag_mode; % Defunct but kept for old codes
toggle_out.doflagging = true; % for running any Yohei style flagging
toggle_out.dostarflag = true; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;
toggle_out.applyforjcorr = true;
toggle_out.applystraycorr = false;
toggle_out.editstarinfo = false;
toggle_out.reduce_variable_size = true; % for changing the starsun saved variables to single precision, reducing by more than half saved file size

if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_out, toggle_in);
end

return