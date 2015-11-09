function s = starinfo20130805(s)
%get variables from caller
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

% s=evalin('caller','s');
daystr=evalin('caller','daystr');

% No good time periods ([start end]) and memo for all pixels
%  flag: 1 for unknown or others, 2 for before and after measurements, 10 for unspecified type of clouds, 90 for cirrus, 100 for unspecified instrument trouble, 200 for instrument tests, 300 for frost.
s.ng=[];
s.flight=[datenum('18:00:00') datenum('23:17:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! A rough timing, to be updated.
s.groundcomparison=[datenum('14:20:50') datenum('18:00:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! A rough timing, to be updated. No good post-flight comparison, as dirt may have deposited during the flight.
s.horilegs=[datenum('20:48:25') datenum('20:58:00')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
!!! horileg to be updated.
% daystr=mfilename;
% daystr=daystr(end-7:end);
% s.ng(:,1:2)=s.ng(:,1:2)-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% No good time periods ([start end]) for specific pixels

% STD-based cloud screening for direct Sun measurements
s.sd_aero_crit=0.015;
s.sd_aero_crit=0.01;
% Ozone and other gases
s.O3h=21;
s.O3col=0.300;  % Yohei's guess, to be updated
s.NO2col=5e15; % Yohei's guess, to be updated

% other tweaks
s.Pst(find(s.Pst<10))=1013; 

% Corrections 
s.note=['See ' mfilename '.m for additional info. ' s.note];

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

