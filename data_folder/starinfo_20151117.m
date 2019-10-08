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

horilegs=[datenum('10:28:55') datenum('14:41:05'); ... 
datenum('14:58:24') datenum('15:28:33'); ... 
datenum('15:32:36') datenum('15:40:10'); ... 
datenum('16:20:58') datenum('18:26:49'); ... 
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
vertprofs=[datenum('10:13:45') datenum('10:28:55'); ... 
datenum('14:41:05') datenum('14:58:24'); ... 
datenum('15:28:33') datenum('15:32:36'); ... 
datenum('15:40:10') datenum('15:48:46'); ... 
datenum('15:40:10') datenum('16:05:06'); ... 
datenum('16:05:06') datenum('16:20:58'); ... 
datenum('18:26:49') datenum('18:43:22'); ... 
]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
flight=[datenum('10:08:28') datenum('18:43:23')] -datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
% manual masking 
s.ng=[datenum('10:13:45') datenum('10:30:00') 1  % bogus calculated airmass, before sunrise 
datenum('14:30:00') datenum('14:31:00') 10  % "The sky looks hazy from the side window. Shortwave radiances from clouds below make it difficult to tell if what�s above is thin clouds or aerosols." 
datenum('14:43:30') datenum('14:53:15') 90 % "1442 Thin clouds above. 1445 Increasing amount of clouds above us, as we descend. " 
datenum('15:43:00') datenum('15:55:00') 90 % the plane was above the boundary layer clouds but saw high clouds above, sometimes 4STAR tracking through them 
datenum('16:08:00') datenum('16:20:00') 90  
datenum('16:20:00') datenum('16:26:00') 10 % the flight notes are mixed: "some thin clouds" , "no visible clouds"   
datenum('16:33:00') datenum('16:36:00') 10]; 
s.ng(:,1:2) = s.ng(:,1:2) - datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]); 
 
try
% or load flags from file as follows:
% 1. Call the function by name as in:
s.ng_new = starflags_20151117_CF_marks_ALL_20160217_0302;
% 2. Call the function by handle (better for running on compiler)
marks_fnt  = str2func('starflags_20151117_CF_marks_ALL_20160217_0302'); 
s.ng_newer = marks_fnt();
% 3. Load the mat file and convert to 'ng'
% s.ng_mat = cnvt_flags2ng(load(['E:\data\4STAR\yohei\mat\20151117_starflag_man_created20160212_1438by_CF.mat']));
catch
   disp('*** marks flags file not loaded') 
end
% STD-based cloud screening for direct Sun measurements 
s.sd_aero_crit=0.01; 
 
% Ozone and other gases 
s.O3h=21; 
% s.O3col=0.300;  % Yohei's guess, to be updated 
% s.NO2col=5e15; % Yohei's guess, to be updated 
s.O3col=0.2657; %OMI mean 
 
s.NO2col=2.52e+15; %OMI mean 
 
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
toggle_out.computeerror=true;
toggle_out.inspectresults=false;
toggle_out.applynonlinearcorr=true;
toggle_out.applytempcorr=false;% true is for SEAC4RS data
toggle_out.gassubtract = false;
toggle_out.booleanflagging = true;
toggle_out.flagging = 2; % for starflag, mode=1 for automatic, mode=2 for in-depth 'manual'
toggle_out.doflagging = true; % for running any Yohei style flagging
toggle_out.dostarflag = true; 
toggle_out.lampcalib  = false; 
toggle_out.runwatervapor = false;
toggle_out.applyforjcorr = false;

if exist('toggle_in', 'var')
   toggle_out = catstruct(toggle_in, toggle_out);
end

return
