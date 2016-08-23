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
%22:57:01 07:15:24
% flight=[datenum(2016,6,1,22,57,01) datenum(2016,6,2,07,15,24)]; 
% spirals=[datenum(2016,4,21,21,45,50) datenum(2016,4,21,21,56,55) 
% datenum(2016,4,21,21,57,50) datenum(2016,4,21,22,12,00)]; 
% langley1=[datenum(2016,07,02,16,13,00) datenum(2016,07,02,18,24,00)]; %morning Langley 1.8-12 NB: instrument error (I think?) means we lost between ~14 and ~11 airmass here; 16:10 actually starts around 16:13, and airmass 11 (rayleigh)
langley1=[datenum(2016,07,02,16,13,00) datenum(2016,07,02,18,08,00)]; %morning Langley 2-12 NB: instrument error (I think?) means we lost between ~14 and ~11 airmass here; 16:10 actually starts around 16:13, and airmass 11 (rayleigh)
langley2=[datenum(2016,07,03,03,00,00) datenum(2016,07,03,05,00,00)]; %evening Langley airmass ~2.2 to 12 (all we had for that one)

% langley1=[datenum(2016,07,02,16,10,00) datenum(2016,07,02,18,25,00)]; %morning Langley FULL
%cut out am=2.1-2.3...
% langley2=[datenum(2016,07,02,16,10,00) datenum(2016,07,02,17,45,00)]; %morning Langley part 1
% langley3=[datenum(2016,07,02,18,05,00) datenum(2016,07,02,21,45,00)]; %morning Langley part 2
% langley4=[datenum(2016,07,03,03,00,00) datenum(2016,07,03,05,00,00)]; %evening Langley
% langley=[datenum(2016,07,02,21,50,00) datenum(2016,07,02,22,30,00); datenum(2016,07,03,03,00,00) datenum(2016,07,03,05,00,00)]; %evening Langley v2 (incorporating some solar noon
 
% Ozone and other gases 
s.O3h=21; % Yohei's guess 
s.O3col=0.268; % we think it was this yesterday?
s.NO2col=2.0e15; % Yohei's guess  
 
% other tweaks 
if isfield(s, 'Pst'); 
    s.Pst(find(s.Pst<10))=680; %MLO  
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
toggle_out.gassubtract = false;
toggle_out.booleanflagging = false;
toggle_out.flagging = 1; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.doflagging = false; % for running any Yohei style flagging
toggle_out.dostarflag = false; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;
toggle_out.applyforjcorr = true;
toggle_out.applystraycorr = false;

if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_in, toggle_out);
end

return

