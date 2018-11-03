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

 

%             s.flight=[datenum(2017,8,31,07,59,14) datenum(2017,8,31,15,52,10)]; 
            s.langley1 = [datenum(2017,9,18,12,29,42) datenum(2017,9,18,15,18,24)];
             s.sd_aero_crit=0.01;  %Connor asked to add this line on 8/2/2017
            % Ozone and other gases 
            s.O3h=21; %  
            s.O3col=0.300; % guess from OMI daily average over the region (35-55N, 35-55W), as estimated from Giovanni     
            s.NO2col=3.7e15; % guess from OMI daily average over the region (35-55N, 35-55W), as estimated from Giovanni     

%             % flags
%             s.flagfilename     = '20170903_starflag_man_created20180512_1503by_KP.mat'; 

 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=1013; % this is for Ames 
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

