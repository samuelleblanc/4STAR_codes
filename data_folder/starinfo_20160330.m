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

ground =[datenum('18:57:00') datenum('26:00')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);   
%langley=[datenum('17:18:00') datenum('20:44')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);  
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
 
% Ozone and other gases  
s.O3h=21;  
s.O3col=0.290;    % guess at Ames roof 
s.NO2col=2.64e15; % guess at Ames roof  
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013;%MLO 
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

toggle_out.subsetting_Tint = false;
toggle_out.pca_filter = false;
toggle_out.verbose=false;
toggle_out.saveadditionalvariables=true;
toggle_out.savefigure=false;
toggle_out.computeerror=false;
toggle_out.inspectresults=false;
toggle_out.applynonlinearcorr=true;
toggle_out.applytempcorr=false;% true is for SEAC4RS data
toggle_out.gassubtract = false;
toggle_out.booleanflagging = false;
toggle_out.flagging = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.doflagging = false; % for running any Yohei style flagging
toggle_out.dostarflag = false; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;
toggle_out.applyforjcorr = false;
toggle_out.applystraycorr = false;

if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_in, toggle_out);
end

return

