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

s.flight=[datenum(2016,5,12,22,58,13) datenum(2016,5,13,3,29,11)];  
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
s.dirty = [datenum(2016,5,14,2,22,00) datenum(2016,5,14,2,33,00)];
s.clean = [datenum(2016,5,14,2,54,30) datenum(2016,5,14,2,57,00)];  


s.flagfilename = '20160512_starflag_man_created20160513_0604by_MS.mat'; 
% gases flags
s.flagfilenameCWV   = '20160512_starflag_CWV_man_created20170109_0521by_MS.mat';
s.flagfilenameO3    = '20160512_starflag_O3_man_created20170109_0523by_MS.mat';
s.flagfilenameNO2   = '20160512_starflag_NO2_man_created20170109_0525by_MS.mat';
s.flagfilenameHCOH  = '20160512_starflag_HCOH_man_created20170109_0531by_MS.mat';


% Ozone and other gases 
s.O3h=21; % guess 
% s.O3col=0.300; % guess     
% s.NO2col=2.0e15; % guess  
s.O3col=0.330;    % default
s.NO2col=3e15;  % default
 
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