function spc = rd_spc_TCAP_v1(infile);
% spc = rd_spc_F4_v2(infile);
%
% Calls spc.raw = rd_spc_raw_F4_v2(infile) to load an existing raw F3 spec
% file or accepts a structure of preloaded file.
% This function would typically return "spc" into "vis" or "nir"
% containers.
% This version attempts to clean up column labels, accepting either
% consistent or inconsisten labels and yielding consistent
% 
if ~exist('infile','var')||~exist(infile,'file')
    infile = getfullname_('*NIR*;*VIS*','4STAR_F2','Select spectrometer file (NIR or VIS)');
end

spc.raw = rd_spc_raw_tcap_v2(infile);
spc = cleanup_raw_flds(spc);
%%
if isfield(spc.raw,'RHprecon')
    spc.t.RHprecon = 100.*spc.raw.RHprecon./5;
end
if isfield(spc.raw,'Tprecon')
%     figure; plot(serial2doy(spc.time), 23.*spc.Tprecon-30,'.')
    spc.t.Tprecon = 23.*spc.raw.Tprecon-30;
end
if isfield(spc.t,'Tprecon')&&isfield(spc.t,'RHprecon')
spc.t.T_dp = dp_from_rh(273.15+spc.t.Tprecon,spc.t.RHprecon./100);
spc.t.RH_CCD = 100.*rh_from_dp(273.15*ones(size(spc.t.T_dp)),spc.t.T_dp);
end

 %%
% figure(201);
% May need logic to distinuish incoming infile as filename or struct
%%
% dark  = spc.t_.dark;
% if sum(dark)>0&&sum(~dark)>0
%     %%
%     s(1) = subplot(2,1,1);
%     these = plot(spc.nm, spc.spectra(~dark,:)-ones([sum(~dark),1])*mean(spc.spectra(dark,:)),'-');
%     title({'mean after dark subtraction';spc.fname},'interp','none');
%     legend(['t_ms = ',num2str(mean(spc.t.t_ms)), ' , N=',num2str(sum(~dark))]);
%     s(2) = subplot(2,1,2);
%     plot(spc.nm, mean(spc.spectra(dark,:)),'k-');
%     hold('on');
%     lines = plot(spc.nm, spc.spectra(dark,:)-ones([sum(dark),1])*mean(spc.spectra(dark,:)),'-');
%     lines = recolor(lines, serial2Hh(spc.time(dark)'));
%     hold('off');
%     title('shutter closed');
%     legend('mean','dev from mean');    
% else
%     s(1) = subplot(2,1,1);
%     plot(spc.nm, mean(spc.spectra),'.-');
%     title('mean of all spectra');
%     s(2) = subplot(2,1,2);
%     lines = plot(spc.nm, spc.spectra - ones(size(spc.t.shutter))*mean(spc.spectra), '-');
%     if length(lines)>1
%     lines = recolor(lines,serial2Hh(spc.time)');
%     end
%     title('mean subtracted');
% end
% Convert T1-T4 into Temperatures
% Convert P1-P4 into Pressure
% Convert Tvnir into Temp
% Convert Tnir into Temp: 
% A = 1.2891e-3; B= 2.356e-4; C= 9.4272e-8;
% R = spc.Tvnir./10e-5; logR = log(R);
% T_K = 1./(A + B.*logR + C.*(logR).^3);
% spc.Tvnir = T_K;
  
return %rd_spc_F4

function spc = cleanup_raw_flds(spc);

raw = spc.raw;
% Copy static and base-level fields
fld = {'pname'	     , 'pname'
'fname'	     , 'fname'	 
'time'	     , 'time'	 
'spectra'    , 'spectra' 
'nm'	     , 'nm'};
for f = 1:length(fld)
    spc.(fld{f,2}) = raw.(fld{f,1});
    raw = rmfield(raw, fld{f,1});
end
% Copy time series to .t 
fld = {'Str'	     , 'shutter'	 
'Md'	     , 'mode'	 
'Zn'	     , 'sky_zone'	 
'AVG'	     , 'N_avg'	 
'Tint'	     , 't_ms'	 
'Tbox'	     , 'T_box'	 
'El_deg'     , 'El_deg'  
'ELcorr'     , 'El_corr'  
'AZcorr'     , 'Az_corr'  
'QdVtb'	     , 'QdV_TB'	 
'QdVlr'	     , 'QdV_LR'	 
'QdVtot'     , 'QdV_tot'  
'Lat'	     , 'Lat'	 
'Lon'	     , 'Lon'	 
'Alt'	     , 'Alt_AGL'	 
'pitch'	     , 'pitch'	 
'roll'	     , 'roll'	 
'Headng'     , 'heading'  
'Tst'	     , 'T_static'
'Pst'	     , 'P_static'	 
'RH'	     , 'RH_outside'
'RHprecon'   , 'RHprecon'
'Tprecon'    , 'Tprecon'
'run_id'     , 'run_id'
'shutter'    , 'shutter'	 
'mode'	     , 'mode'	 
'sky_zone'	 , 'sky_zone'	 
'N_avg'	     , 'N_avg'	 
'tint'	     , 't_ms'	 
't_ms'	     , 't_ms'	 
'T_box'	     , 'T_box'	 
'El_deg'     , 'El_deg'  
'AZ_deg'     , 'AZ_deg'
'Az_deg'     , 'Az_deg'  
'El_corr'    , 'El_corr'  
'Az_corr'    , 'Az_corr'  
'QdV_TB'	 , 'QdV_TB'	 
'QdV_LR'	 , 'QdV_LR'	 
'QdV_tot'    , 'QdV_tot'  
'Lat'	     , 'Lat'	 
'Lon'	     , 'Lon'	 
'Alt_AGL'	 , 'Alt_AGL'	 
'pitch'	     , 'pitch'	 
'roll'	     , 'roll'	 
'heading'    , 'heading'  
'OAT_static' , 'T_static'
'pres_static', 'P_static'	 
'RH_outside' , 'RH_outside'	 
'run_id'     , 'run_id' };
for f = 1:length(fld)
    if isfield(raw,fld{f,1})
    spc.t.(fld{f,2}) = raw.(fld{f,1});
    raw = rmfield(raw, fld{f,1});
    end
end
spc.t_.dark = spc.t.shutter==0;
spc.t_.sun = spc.t.shutter==1;
spc.t_.sky = spc.t.shutter==2;
spc.t_.parked = spc.t.mode==0;
spc.t_.tracking = spc.t.mode==1;
spc.t_.seeking = spc.t.mode==7;
spc.t_.FOV = spc.t.mode==2|spc.t.mode==3;
spc.t_.scan = spc.t.mode==4|spc.t.mode==5;

% Strip out a few unwanted fields
if isfield(raw,'Elstep')
raw = rmfield(raw,'Elstep');
end
if isfield(raw,'AZstep')
raw = rmfield(raw,'AZstep');
end
if isfield(raw,'header')
raw = rmfield(raw,'header');
end
if isfield(raw,'row_labels')
raw = rmfield(raw,'row_labels');
end
if isfield(raw,'is_vis')
raw = rmfield(raw,'is_vis');
end

% Catch remainder in case we have some adhoc additions
fld = fieldnames(raw);
for f = 1:length(fld)
    spc.(fld{f,1}) = raw.(fld{f,1});
    raw = rmfield(raw, fld{f,1});
end

return