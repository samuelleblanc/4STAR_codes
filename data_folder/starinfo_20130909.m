function s = starinfo(s)
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t)
   daystr = datestr(s.t(1),'yyyymmdd');
else
   daystr=evalin('caller','daystr');
end

toggle = update_toggle;
if isfield(s, 'toggle')
   toggle = catstruct(s.toggle, toggle);
end
s.toggle = toggle;

%get variables from caller 
if exist('s','var')&&isfield(s,'t')&&~isempty(s.t) 
   daystr = datestr(s.t(1),'yyyymmdd'); 
else 
end 
 
toggle.verbose=true; 
toggle.saveadditionalvariables=true; 
toggle.savefigure=false; 
toggle.computeerror=true; 
toggle.inspectresults=false; 
toggle.applynonlinearcorr=false; 
toggle.applytempcorr=false;% true is for SEAC4RS data 
toggle.gassubtract = false; 
toggle.booleanflagging = true; 
toggle.flagging = 2; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual' 
toggle.doflagging = true; % for running any Yohei style flagging 
toggle.dostarflag = true;  
toggle.lampcalib  = false;  
toggle.runwatervapor = false; 
 
if isfield(s, 'toggle') 
   s.toggle = catstruct(s.toggle, toggle); 
   toggle = s.toggle; 
else 
   s.toggle = toggle; 
end 
 
flight=[datenum('18:57:25') datenum('25:41:08')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
horilegs=[datenum('19:09:50') datenum('20:11:21');... 
    datenum('20:26:50') datenum('20:52:36');... 
    datenum('20:59:24') datenum('21:07:13');... 
    datenum('21:09:25') datenum('21:22:45');... 
    datenum('21:29:47') datenum('21:44:50');... 
    datenum('21:45:44') datenum('22:02:01');... 
    datenum('22:14:25') datenum('22:16:05');... 
    datenum('22:21:47') datenum('22:27:33');... 
    datenum('22:42:41') datenum('22:50:38');... 
    datenum('22:57:48') datenum('23:07:01');... 
    datenum('23:09:21') datenum('23:17:41');... 
    datenum('23:29:32') datenum('23:36:13');... 
    datenum('23:37:59') datenum('23:46:41');... 
    datenum('23:48:15') datenum('24:05:29');... 
    datenum('24:10:05') datenum('24:13:06');... 
    datenum('24:14:22') datenum('24:18:51');... 
    datenum('24:21:16') datenum('24:47:07');... 
    datenum('24:57:45') datenum('25:27:31');... 
    datenum('25:41:08') datenum('25:42:50');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
vertprofs=[datenum('18:57:27') datenum('19:09:50');... 
    datenum('20:12:48') datenum('20:26:50');... 
    datenum('20:52:37') datenum('20:59:23');... 
    datenum('21:07:13') datenum('21:29:42');... 
    datenum('22:07:17') datenum('22:21:46');... 
    datenum('22:27:33') datenum('22:42:39');... 
    datenum('22:52:17') datenum('22:57:28');... 
    datenum('23:07:05') datenum('23:09:20');... 
    datenum('23:17:42') datenum('23:20:05');... 
    datenum('23:20:17') datenum('23:27:02');... 
    datenum('23:27:03') datenum('23:28:35');... 
    datenum('23:46:43') datenum('23:48:14');... 
    datenum('24:05:29') datenum('24:08:45');... 
    datenum('24:08:45') datenum('24:14:21');... 
    datenum('24:18:52') datenum('24:20:51');... 
    datenum('24:47:08') datenum('24:49:41');... 
    datenum('24:49:41') datenum('24:57:44');... 
    datenum('25:27:32') datenum('25:41:08');... 
    ]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.010; 
 
% Ozone and other gases 
s.O3h=21; 
s.O3col=0.300;  % Yohei's guess, to be updated 
s.NO2col=5e15; % Yohei's guess, to be updated 
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013; 
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
end 
 

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

