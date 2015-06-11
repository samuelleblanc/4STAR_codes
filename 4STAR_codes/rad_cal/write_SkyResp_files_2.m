%% PURPOSE:
%   Build the ascii file for the sky barrel response functions, relating
%   the raw count rates to radiance values
%
% CALLING SEQUENCE:
%   [vis_resp nir_resp]=write_SkyResp_files_2(vis,nir,archi,folder,lampstr)
%
% INPUT:
%   vis: structure with all required information (resp,fname, tint,nm, rate, radiance, optionally resperr) for vis spectrometer
%   nir: structure with all required information for nir spectrometer
%   archi: structure of radiance values from the calibrating source (use only file name and units)
%   folder: path to where to save response functions
%   lampstr: which lamp is used to build the response function: optional, if not set assumes average, and not tint is used
% 
% OUTPUT:
%  vis_resp: filename and path of the vis response function file
%  nir_resp: filename and path of the nir response function file
%  - ascii files of response functions (one for vis, and one for nir)
%
% DEPENDENCIES:
%  - version_set.m : for version control of this file
%
% NEEDED FILES:
%  - sounding file
%  - standard atmosphere file
%  - 4STAR star.mat file for that day
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: 4STAR team member
% Modified (v2.0): by Samuel LeBlanc, NASA Ames, Oct 13th, 2014
%          - added version control of this file via version_set
%          - ported over to use as function within other radiance
%          calibration programs
% Modified (v2.1): by Samuel LeBlanc, NASA Ames, Oct 15th, 2014
%          - made the lampstr value not necessary, and adjusted notes in
%          header to reflect that multiple lamps were used          
%          - checks the input structures (vis and nir) if resperr is
%          present, if it is, prints it to file
%
% -------------------------------------------------------------------------

%% Start of function
function [vis_resp nir_resp]=write_SkyResp_files_2(vis,nir,archi,folder,lampstr);
version_set('2.1');

vis_Pix=0:1043;
nir_Pix=length(nir.nm)-1:-1:0;

% For vis 
vis_header = {};
vis_header(1) = {['% Radiance calibration [Resp in cts/ms / ',archi.units,...
    '] for 4STAR VIS spectrometer (',sprintf('%-d',length(vis.nm)),...
    ' channels) derived from ',vis.fname,' on ', datestr(now,'yyyy-mm-dd HH:MM:SS'),'.']};
if nargin < 5;
    vis_header(end+1) = {['% Calibration used data from the average of the lamps and integration time from the measurement day of:' datestr(vis.time(1),'yyyymmdd')]};
else;
    vis_header(end+1) = {['% Calibration used only data with ',lampstr,' and ',sprintf('%-d',vis.tint),' ms (vis), ',sprintf('%-d',nir.tint),' ms (nir).']};
end;
vis_header(end+1) = {['% Also requires calibrated radiance from ',archi.fname,'.']};
if ~exist('vis.resperr','var')
  vis_header(end+1) = {['Pix  Wavelength     resp       rate        rad']};
  isviserr=false;
else
  vis_header(end+1) = {['Pix  Wavelength     resp       rate        rad        resperr']};
  isviserr=true;
end;
  %%
[~,dname,~] = fileparts(vis.fname);
[~,aname,~] = fileparts(archi.fname);
vis_resp = [folder,filesep,datestr(vis.time(1), 'yyyymmdd'),'_VIS_SKY_Resp_from_',dname, '_with_',aname,'.dat'];
disp(['Making file: ' vis_resp])
vid = fopen(vis_resp,'w');
for hd = 1:length(vis_header)
    fprintf(vid,'%s \n', vis_header{hd});
end
if isviserr;
  fprintf(vid,'%-4.0f %-4.2f  %-1.8e %-1.8e %-1.8e %-1.8e \n', ...
      [vis_Pix; vis.nm; vis.resp; vis.rate; vis.rad vis.resperr]);  
else
  fprintf(vid,'%-4.0f %-4.2f  %-1.8e %-1.8e %-1.8e \n', ...
      [vis_Pix; vis.nm; vis.resp; vis.rate; vis.rad]);
end;
fclose(vid);
[pn,mname,ext] = fileparts(vis_resp);pn = [pn, filesep];
[SUCCESS,MESSAGE,MESSAGEID] = copyfile(vis_resp, [pn,mname,'.',datestr(now,'yyyymmdd_HHMMSS'),ext],'f');
%%


% For nir
nir_header = {};
nir_header(1) = {['% Radiance calibration [Resp in cts/ms / ',archi.units,...
    '] for 4STAR NIR spectrometer (',sprintf('%-d',length(nir.nm)),...
    ' channels) derived from ',nir.fname,' on ', datestr(now,'yyyy-mm-dd HH:MM:SS'),'.']};
if nargin < 5;
    nir_header(end+1) = {['% Calibration used data from the average of the lamps and integration time from the measurement day of:' datestr(nir.time(1),'yyyymmdd')]};
else;
    nir_header(end+1) = {['% Calibration used only data with ',lampstr,' and ',sprintf('%-d',vis.tint),' ms (vis), ',sprintf('%-d',nir.tint),' ms (nir).']};
end;
nir_header(end+1) = {['% Also requires calibrated radiance from ',archi.fname,'.']};
if ~exist('nir.resperr','var')
  nir_header(end+1) = {['Pix  Wavelength     resp       rate        rad']};
  isnirerr=false;
else
  nir_header(end+1) = {['Pix  Wavelength     resp       rate        rad        resperr']};
  isnirerr=true;
end;
%%
[~,dname,~] = fileparts(nir.fname);
[~,aname,~] = fileparts(archi.fname);
nir_resp = [folder,filesep,datestr(nir.time(1), 'yyyymmdd'),'_NIR_SKY_Resp_from_',dname, '_with_',aname,'.dat'];
disp(['Making file: ' nir_resp])
nid = fopen(nir_resp,'w');
for hd = 1:length(nir_header)
    fprintf(nid,'%s \n', nir_header{hd});
end
if isnirerr
  fprintf(nid,'%-4.0f %-4.2f  %-1.8e %-1.8e %-1.8e %-1.8e \n', ...
      [nir_Pix; nir.nm; nir.resp; nir.rate; nir.rad nir.resperr]);
else;
  fprintf(nid,'%-4.0f %-4.2f  %-1.8e %-1.8e %-1.8e \n', ...
      [nir_Pix; nir.nm; nir.resp; nir.rate; nir.rad]);
end;
fclose(nid);
[pn,mname,ext] = fileparts(nir_resp);pn = [pn, filesep];
copyfile(nir_resp, [pn,mname,'.',datestr(now,'yyyymmdd_HHMMSS'),ext],'f');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return