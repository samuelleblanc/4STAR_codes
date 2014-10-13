function [cross_sections, tau_O3, tau_NO2, tau_O4 , tau_CO2_CH4_N2O, tau_O3_err, tau_NO2_err, tau_O4_err, tau_CO2_CH4_N2O_abserr]=taugases(t, datatype, Alt, Lat, O3col, NO2col)

% development
% NO2, O3 concentrations should be input.
% cross section should be updated every time wavelengths and FWHM are
% updated. Keep track of the past records with t (input).

% load cross section data
% all options are commented since new cross section version is unified
%----------------------------------------------------------------------

if t>=datenum([2012 7 3 0 0 0]);
    cross_sections=load(fullfile(starpaths, 'cross_sections_uv_vis_swir_all.mat')); % load newest cross section vesion (October 15th 2012) MS
    fn=fieldnames(cross_sections);
    for ff=1:length(fn);
        orig=cross_sections.(fn{ff});
        cross_sections.(fn{ff})=transpose(orig(:));
        if isequal(lower(datatype(1:3)), 'vis'); % return the first 1044 columns
            cross_sections.(fn{ff})=cross_sections.(fn{ff})(:,1:1044);
        elseif isequal(lower(datatype(1:3)), 'nir'); % return the last 512 columns
            cross_sections.(fn{ff})=cross_sections.(fn{ff})(:,(1:512)+1044);
        end;
    end;
else; % legacy cross sections that were separate between VIS and NIR; record keeping.
    if isequal(lower(datatype(1:3)), 'vis') || isequal(lower(datatype(1:3)), 'sun');
        visw=starwavelengths(t);
        if t>=datenum([2012 7 3 0 0 0]); % new VIS spectrometer since July 3, 2012
            cross_sections=load(fullfile(starpaths, 'cross_sections_visnew.mat'));
            cross_sections.wln=cross_sections.wln';
            cross_sections.no2=cross_sections.no2';
            visw0=Lambda_MCS_fit3(1:1044)/1000;
            cross_sections.h2oa=interp1(visw0(180:end), cross_sections.h2oa, visw); % until the H2O data are given for the new wavelengths
            cross_sections.h2ob=interp1(visw0(180:end), cross_sections.h2ob, visw); % until the H2O data are given for the new wavelengths
        else
            cross_sections=load(fullfile(starpaths, 'cross_sections_vis.mat'));
            [c,ia,ib]=intersect(visw,cross_sections.wln/1000);
            fn=fieldnames(cross_sections);
            for ff=1:length(fn);
                eval(['orig=cross_sections.' fn{ff} ';']);
                eval(['cross_sections.' fn{ff} '=NaN(1,length(visw));']);
                eval(['cross_sections.' fn{ff} '(ia)=transpose(orig(:))']);
            end;
            clear orig;
        end;
    elseif isequal(lower(datatype(1:3)), 'nir');
        cross_sections=load(fullfile(starpaths, 'cross_sections_nir.mat'));
        cross_sections.no2=zeros(size(cross_sections.wln));
        cross_sections.o3=zeros(size(cross_sections.wln));
        cross_sections.o2=zeros(size(cross_sections.wln));
    else;
        error('Spectrometer?');
    end;
    if isequal(lower(datatype(1:3)), 'sun'); % VIS+NIR
        cross_sections_nir=load(fullfile(starpaths, 'cross_sections_nir.mat'));
        cross_sections_nir.no2=zeros(size(cross_sections_nir.wln));
        cross_sections_nir.o3=zeros(size(cross_sections_nir.wln));
        cross_sections_nir.o2=zeros(size(cross_sections_nir.wln));
        cross_sections.wln=[cross_sections.wln cross_sections_nir.wln];
        cross_sections.o3=[cross_sections.o3 cross_sections_nir.o3];
        cross_sections.o2=[cross_sections.o2 cross_sections_nir.o2];
        cross_sections.o4=[cross_sections.o4 cross_sections_nir.o4];
        cross_sections.no2=[cross_sections.no2 cross_sections_nir.no2];
    end;
end;

% get NO2 optical depth
Loschmidt=2.686763e19; %molecules/cm2
if nargin<6 || isempty(NO2col);
    NO2col=2.0e15; % atm-cm
end;
tau_NO2=NO2col/Loschmidt*cross_sections.no2;

% get O4 optical depths
[O2_vercol,O4_vercol]=O2_VCYMSez(Alt, t, Lat);
if isfield(cross_sections,'o4all'); % Yohei, 2013/01/16, for the legacy July 3, 2012 cross sections
    tau_O4=O4_vercol*cross_sections.o4all;
else
    tau_O4=O4_vercol*cross_sections.o4;
end;
tau_O2=zeros(size(cross_sections.wln)); % don't subtract O2 % O2_vercol*cross_sections.o2;
tau_CO2_CH4_N2O=zeros(size(cross_sections.wln)); % legacy from AATS's 14th channel, not covered by 4STAR VIS.

% compute ozone optical depth
%following added by Livingston 12/19/2002 to account for altitude in columnar ozone correction
%use previously calculated (Livingston program ozonemdlcalc.m) 5th order polynomial fit to ozone model
%to calculate fraction of total column ozone above each altitude
coeff_polyfit_tauO3model=[8.60377e-007  -3.26194e-005   3.54396e-004  -1.30386e-003  -5.67021e-003   9.99948e-001];
frac_tauO3 = polyval(coeff_polyfit_tauO3model,Alt/1000); % Livingston used GPS_Alt
% if strcmp(flag_adj_ozone_foraltitude,'no') frac_tauO3=1*ones(1,n(1)); end
flag_interpOMIozone='no';%'yes';  'no' for MLO   %FOR COAST WILL EVENTUALLY SET = 'yes' after downloading OMI O3
if strcmp(flag_interpOMIozone,'yes')
    imoda_OMI=100*month+day;
    if strcmp(flag_OMI_substitute,'yes')
        imoda_OMI=imoda_OMI_substitute;
    end
    [OMIozone_interp,filename_OMIO3] = readinterp_OMIozone(imoda_OMI,geog_lat,geog_long);
    ozone=(frac_tauO3.*OMIozone_interp)';
    tau_O3=(ozone*cross_sections.o3')';
else
    filename_OMIO3=[];
    ozone=(frac_tauO3*O3col)';
    tau_O3=O3col*cross_sections.o3;
    tau_O3=frac_tauO3*tau_O3;
end

% give uncertainties - inherited from the AATS code. From Schmid et al.
% (1996)?
    tau_O3_err=0.05;       %relative error
    tau_NO2_err=0.27;      %relative error
    tau_O4_err=0.12;       %relative error
%     tau_H2O_err=0.15;      %relative error
%     a_H2O_err=0.02;        %relative error
%     b_H2O_err=0.02;        %relative error
    tau_CO2_CH4_N2O_abserr=zeros(size(tau_CO2_CH4_N2O));
    tau_CO2_CH4_N2O_abserr(tau_CO2_CH4_N2O>0)=1.0e-04;  %absolute error


