function  [vis_resp, nir_resp] = write_SkyResp_files(vis,nir);
% Defunct as of 2014_02_13

vis_id = fopen('D:\2013_07_14_email_from_Yohei\20130708_VIS_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x_averagethru20130712.dat');
tmp = [];i = 0;

while isempty(tmp)||strcmp(tmp(1),'%')
tmp = fgetl(vis_id);
end
labels = textscan(tmp,'%s');labels = labels{1};
format_str = repmat('%f ',size(labels'));
data = textscan(vis_id, format_str);
fclose(vis_id);
for xx = 1:length(labels)
    visCo.(char(labels(xx)))=data{xx};
end

nir_id = fopen('D:\2013_07_14_email_from_Yohei\20130708_NIR_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x_averagethru20130712.dat');
tmp = [];i = 0;

while isempty(tmp)||strcmp(tmp(1),'%')
tmp = fgetl(nir_id);
end
labels = textscan(tmp,'%s');labels = labels{1};
format_str = repmat('%f ',size(labels'));
data = textscan(nir_id, format_str);
fclose(nir_id);
for xx = 1:length(labels)
    nirCo.(char(labels(xx)))=data{xx};
end

%%
% [visc0, nirc0, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(vis.time(1));
% %%
% figure; plot(nirCo.Wavelength, nirCo.C0- nirc0','r.')
% 
% Confirmed format of Yohei's Co files.
% Now confirm that this matches my wavelength scales 
%figure; plot(vis.nm, vis.nm - visCo.Wavelength','o')
% discrepancy outside the useful range of spectrometer.  
% Matching mine to Yohei's...
vis_SkyRadiance.Pix = visCo.Pix;
vis_SkyRadiance.Wavelength = visCo.Wavelength;
vis_SkyRadiance.lamps = 9;
vis_SkyRadiance.ms = 6;
vis_SkyRadiance.rate = vis.rate_9ms_9lamps';
vis_SkyRadiance.rad = vis.rad_9lamps';
vis_SkyRadiance.resp = vis.resp_6ms_9lamps';

%%
[matfolder, figurefolder, askforsourcefolder]=starpaths;
% 20120722_VIS_C0_refined_Langley_on_G1_second_flight_screened_2x_averagedwith20120707.dat
vis_header = {};
vis_header(1) = {['% Radiance calibration [Resp in cts/ms / ',archi.units,...
    '] for 4STAR VIS spectrometer (',sprintf('%-d',length(vis.nm)),...
    ' channels) derived from ',vis.fname,' on ', datestr(now,'yyyy-mm-dd HH:MM:SS'),'.']};
vis_header(end+1) = {('% Calibration used only data with 9-lamps and 6 ms (vis), 30 ms (nir).')};
vis_header(end+1) = {['% Also requires calibrated radiance from ',archi.fname,'.']};
vis_header(end+1) = {['Pix  Wavelength     resp       rate        rad']};
%%
[~,dname,~] = fileparts(vis.fname);
[~,aname,~] = fileparts(archi.fname);
vis_resp = [matfolder,datestr(vis.time(1), 'yyyymmdd'),'_VIS_SKY_Resp_from_',dname, '_with_',aname,'.dat'];
vid = fopen(vis_resp,'w');
for hd = 1:length(vis_header)
    fprintf(vid,'%s \n', vis_header{hd});
end
fprintf(vid,'%-4.0f %-4.2f  %-1.8e %-1.8e %-1.8e \n', ...
    [vis_SkyRadiance.Pix, vis_SkyRadiance.Wavelength, vis_SkyRadiance.resp, vis_SkyRadiance.rate, vis_SkyRadiance.rad]');
fclose(vid);
[pn,mname,ext] = fileparts(vis_resp);pn = [pn, filesep];
[SUCCESS,MESSAGE,MESSAGEID] = copyfile(vis_resp, [pn,mname,'.',datestr(now,'yyyymmdd_HHMMSS'),ext],'f');
%%

nir_SkyRadiance.Pix = nirCo.Pix;
nir_SkyRadiance.Wavelength = nirCo.Wavelength;
nir_SkyRadiance.lamps = 9;
nir_SkyRadiance.ms = 30;
nir_SkyRadiance.rate = nir.rate_30ms_9lamps';
nir_SkyRadiance.rad = nir.rad_9lamps';
nir_SkyRadiance.resp = nir.resp_30ms_9lamps';  

nir_header = {};
nir_header(1) = {['% Radiance calibration [Resp in cts/ms / ',archi.units,...
    '] for 4STAR NIR spectrometer (',sprintf('%-d',length(nir.nm)),...
    ' channels) derived from ',nir.fname,' on ', datestr(now,'yyyy-mm-dd HH:MM:SS'),'.']};
nir_header(end+1) = {('% Calibration used only data with 9-lamps and 6 ms (vis), 30 ms (nir).')};
nir_header(end+1) = {['% Also requires calibrated radiance from ',archi.fname,'.']};
nir_header(end+1) = {['Pix  Wavelength     resp       rate        rad']};
%%
[~,dname,~] = fileparts(nir.fname);
[~,aname,~] = fileparts(archi.fname);
nir_resp = [matfolder,datestr(nir.time(1), 'yyyymmdd'),'_NIR_SKY_Resp_from_',dname, '_with_',aname,'.dat'];
nid = fopen(nir_resp,'w');
for hd = 1:length(nir_header)
    fprintf(nid,'%s \n', nir_header{hd});
end
fprintf(nid,'%-4.0f %-4.2f  %-1.8e %-1.8e %-1.8e \n', ...
    [nir_SkyRadiance.Pix, nir_SkyRadiance.Wavelength, nir_SkyRadiance.resp, nir_SkyRadiance.rate, nir_SkyRadiance.rad]');
fclose(nid);
[pn,mname,ext] = fileparts(nir_resp);pn = [pn, filesep];
copyfile(nir_resp, [pn,mname,'.',datestr(now,'yyyymmdd_HHMMSS'),ext],'f');
%%
%%

return