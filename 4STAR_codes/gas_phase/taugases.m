function [cross_sections, tau_O3, tau_NO2, tau_O4 , tau_CO2_CH4_N2O, tau_O3_err, tau_NO2_err, tau_O4_err, tau_CO2_CH4_N2O_abserr]=taugases(t, datatype, Alt, Pst, Lat, Lon, O3col, NO2col,instrumentname)

% development
% NO2, O3 concentrations should be input from starinfo or OMI gridded file
% cross section should be updated every time wavelengths and FWHM are
% updated. Keep track of the past records with t (input).

% load cross section data
% all options are commented since new cross section version is unified
% MS, modified, 2015-11-30, added an option to read OMI data and use
%                           seperate value for each t, unlike O3col
%                           and NO2col from starinfo, which is constant
%                           separated functionallity whether called
%                           from starc0 or starwrapper
%                           now has 7 nargin
% MS, modified, 2016-01-09  fixed bug in tau_NO2 final dimensions
% MS, modified, 2016-05-03  adjusted o3 vertical correction for omi
% MS, modified, 2016-05-06  chnaged default flag_interpOMIno2='yes' to
%                           'no' for KORUS-AQ
% SL, modified, 2017-05-28  Modified codes to add multi-instrument
%                           functionality via the instrumentname variable
% MS, modified, 2018-10-01  Added 4STARB cross section functionality
% SL, modified, 2022-07-12 v2.1, Added the newest cross sections for 4STARB
%                           Added returns of CH4 and CO2 tau using
%                           cross-sections, and calculated expected trace
%                           gas column (new CO2_CH4_VCYMSez)
%----------------------------------------------------------------------
version_set('v2.1')
Loschmidt=2.686763e19; %molecules/cm3xatm%molecules/cm3xatm
% set functionallity
if ~exist('instrumentname'); % no instrumentname defaults to 4STAR
    instrumentname = '4STAR'; 
end;

if length(Lat)==1
     % this is being called from starc0
     flag_interpOMIno2  = 'no';% use default
     flag_interpOMIo3   = 'no';% use default
     % default value; might want to adjust
     coeff_polyfit_tauO3model=[8.60377e-007  -3.26194e-005   3.54396e-004  -1.30386e-003  -5.67021e-003   9.99948e-001];
     frac_tauO3 = polyval(coeff_polyfit_tauO3model,Alt/1000);
     
elseif strcmp(datestr(t(1),'yyyymmdd'),'20160426')
    % check if this is Langley; don't apply
    flag_interpOMIno2  = 'no';% use default
    flag_interpOMIo3   = 'no';% use default
    
    % apply appropriate o3 scaling polynomial
    % this is for April, Lat bin 45
    coeff_polyfit_tauO3model = [2.0744e-06 -7.3077e-05 7.9684e-04 -0.0029 -0.0092 0.9995];
    
else
     % all other cases - yes, KORUS-AQ, 'no' OMI seems to be over-clouded
     flag_interpOMIno2  = 'yes';% this is new no2 interpolation, from L2 gridded product
     flag_interpOMIo3   = 'yes';% this is new o3 interpolation, from L2 gridded product
     
     % mid-lat July
     % coeff_polyfit_tauO3model=[8.60377e-007  -3.26194e-005   3.54396e-004  -1.30386e-003  -5.67021e-003   9.99948e-001];
     % this is for April, Lat bin 45
     coeff_polyfit_tauO3model = [2.0744e-06 -7.3077e-05 7.9684e-04 -0.0029 -0.0092 0.9995];
end

if t(1)>=datenum([2016 1 1 0 0 0]);
    if strcmp(instrumentname,'4STAR')
        cross_sections=load(which( 'cross_sections_uv_vis_swir_all.mat')); % load old cross section vesion (October 15th 2012) MS
    elseif strcmp(instrumentname,'4STARB')
        cross_sections=load(which( 'cross_sections_4starb_20220708.mat')); % load corssections based on convolution with new fwhm for 4STARB (July 2022 - SL)
        cross_sections.o4 = cross_sections.o4/Loschmidt/Loschmidt;
        cross_sections.co2 = cross_sections.co2/Loschmidt;
        cross_sections.ch4 = cross_sections.ch4/Loschmidt;
        cross_sections.o3 = cross_sections.o3/10.0; %unit conversion error
    end
    fn=fieldnames(cross_sections);
    for ff=1:length(fn);
        if regexp(fn{ff},'_notes')>0, continue, end
        orig=cross_sections.(fn{ff});
        cross_sections.(fn{ff})=transpose(orig(:));
        if isequal(lower(datatype(1:3)), 'vis'); % return the first 1044 columns
            cross_sections.(fn{ff})=cross_sections.(fn{ff})(:,1:1044);
        elseif isequal(lower(datatype(1:3)), 'nir'); % return the last 512 columns
            cross_sections.(fn{ff})=cross_sections.(fn{ff})(:,(1:512)+1044);
        end;
    end;
elseif t(1)>=datenum([2012 7 3 0 0 0]);
    if strcmp(instrumentname,'4STAR')
        cross_sections=load(which( 'cross_sections_uv_vis_swir_all.mat')); % load newest cross section vesion (October 15th 2012) MS
    elseif strcmp(instrumentname,'4STARB')
        cross_sections=load(which( 'cross_sections_4starb.mat'));
        % adjusting field names according to haritage
        cross_sections.wln = cross_sections.wln_4starb;
        cross_sections.o3  = cross_sections.o3_vis_223K_interp;
        cross_sections.no2 = cross_sections.no2_vis_254K_interp;
        cross_sections.o2  = cross_sections.o2_vis_1013mbar_interp;
        cross_sections.o4  = cross_sections.o4all;
        cross_sections.co2 = cross_sections.co2_nir_1013mbar_interp;
        cross_sections.ch4 = cross_sections.ch4_nir_1013mbar_interp;
        cross_sections.h2o = cross_sections.h2o_vis_1013mbar_294K_interp;
    end
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
            cross_sections=load(which( 'cross_sections_visnew.mat'));
            cross_sections.wln=cross_sections.wln';
            cross_sections.no2=cross_sections.no2';
            visw0=Lambda_MCS_fit3(1:1044)/1000;
            cross_sections.h2oa=interp1(visw0(180:end), cross_sections.h2oa, visw); % until the H2O data are given for the new wavelengths
            cross_sections.h2ob=interp1(visw0(180:end), cross_sections.h2ob, visw); % until the H2O data are given for the new wavelengths
        else
            cross_sections=load(which( 'cross_sections_vis.mat'));
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
        cross_sections=load(which( 'cross_sections_nir.mat'));
        cross_sections.no2=zeros(size(cross_sections.wln));
        cross_sections.o3=zeros(size(cross_sections.wln));
        cross_sections.o2=zeros(size(cross_sections.wln));
    else;
        error('Spectrometer?');
    end;
    if isequal(lower(datatype(1:3)), 'sun'); % VIS+NIR
        cross_sections_nir=load(which( 'cross_sections_nir.mat'));
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

switch instrumentname; % defaults to use 4STAR, here you put special code to modify 4STAR
    case {'4STARB'}
        %warning('Cross sections for 4STARB are convolved using 4STAR-A FWHM values')
        nwl = size(cross_sections.wln);
    case {'2STAR'}
        warning('Gas phase cross sections for 2STAR not yet defined, using 4STAR and then convolving')
        fn=fieldnames(cross_sections);
        visw_4s = cross_sections.wln;
        visw_2s = starwavelengths(t,'2STAR').*1000.0;
        %if length(visw_4s)>1044; visw_4s = visw_4s(1:1044); end;
        ig = find(isfinite(visw_4s));
        for ff=1:length(fn);
            if strcmp(fn{ff},'wln'); continue;  end; % skip over the wavelengths
            ccs = cross_sections.(fn{ff})(ig);
            cross_sections.(fn{ff})=interp1(visw_4s(ig),ccs,visw_2s,'linear',0.0);
        end;
        nwl = size(visw_2s);
    case {'4STAR'}
        nwl = size(cross_sections.wln);
end; %switch instrumentname

%% get NO2 optical depth

% Loschmidt=2.686763e19; %molecules/cm3xatm
if nargin<8 || isempty(NO2col);
    NO2col=2.0e15; % molec/cm2
    O3col =0.300;  % atm x cm
end

% calculate from OMI or from default value
if strcmp(flag_interpOMIno2,'yes')
    try
        daystr = datestr(t(1),'yyyymmdd');
        g = processOMIdata(Lat,Lon,daystr,'NO2');
        
        tau_NO2 =(g.omi/Loschmidt)*cross_sections.no2;
        tau_NO2s=(g.omino2S/Loschmidt)*cross_sections.no2;
        tau_NO2t=(g.omino2T/Loschmidt)*cross_sections.no2;
        tau_NO2d=(repmat(2.0e15,length(g.omi),1)/Loschmidt)*cross_sections.no2;% d is for default
        nanid = find(isnan(tau_NO2(:,1)));
        % assign tau_NO2 according to aircraft altitude
        tau_NO2(Alt> 3000,:)  = tau_NO2s(Alt> 3000,:);
        % assign constant no2 at missing values
        tau_NO2(nanid,:)      = tau_NO2d(nanid,:);
        
    catch
        tau_NO2=(NO2col/Loschmidt)*cross_sections.no2;
        % adjust struct size
        tau_NO2=repmat(tau_NO2,length(t),1);
    end
else
    tau_NO2=(NO2col/Loschmidt)*cross_sections.no2;
    % adjust struct size
    tau_NO2=repmat(tau_NO2,length(t),1);
end

%% get O4 optical depths
[O2_vercol,O4_vercol]=O2_VCYMSez(Alt, t, Lat);
if isfield(cross_sections,'o4all'); % Yohei, 2013/01/16, for the legacy July 3, 2012 cross sections
    tau_O4=O4_vercol*cross_sections.o4all;
else
    tau_O4=O4_vercol*cross_sections.o4;
end;
tau_O2=zeros(nwl); % don't subtract O2 % O2_vercol*cross_sections.o2;

%% get CO2 and CH4 optical depths
%tau_CO2_CH4_N2O=zeros(size(cross_sections.wln)); % legacy from AATS's 14th channel, not covered by 4STAR VIS.
try
    [CO2_vercol,CH4_vercol]=CO2_CH4_VCYMSez(Alt,t,Lat);
    tau_CO2 = CO2_vercol*cross_sections.co2;
    tau_CH4 = CH4_vercol*cross_sections.ch4;
    tau_CO2_CH4_N2O = tau_CO2 + tau_CH4;
catch
    disp('**Error on getting cross sections and tau for  CO2 and CH4, setting to 0. (Does not affect vis regardless)')
    tau_CO2_CH4_N2O=zeros(nwl); % legacy from AATS's 14th channel, not covered by 4STAR VIS.
end

%% get O3 optical depths

%following added by Livingston 12/19/2002 to account for altitude in columnar ozone correction
%use previously calculated (Livingston program ozonemdlcalc.m) 5th order polynomial fit to ozone model
%to calculate fraction of total column ozone above each altitude
% coeff_polyfit_tauO3model=[8.60377e-007  -3.26194e-005   3.54396e-004  -1.30386e-003  -5.67021e-003   9.99948e-001];
% frac_tauO3 = polyval(coeff_polyfit_tauO3model,Alt/1000); % Livingston used GPS_Alt
% if strcmp(flag_adj_ozone_foraltitude,'no') frac_tauO3=1*ones(1,n(1)); end

% correction is based on zstar altitude so calculate
if length(Lat)>1
    zstar = 16*log10(1013./Pst);
    frac_tauO3 = polyval(coeff_polyfit_tauO3model,zstar);
end

flag_interpOMIozone='no';%'yes';  'no' for MLO; this is John's heritage code

if strcmp(flag_interpOMIozone,'yes')
    
    % John heritage omi adjustment
    imoda_OMI=100*month+day;
    if strcmp(flag_OMI_substitute,'yes')
        imoda_OMI=imoda_OMI_substitute;
    end
    [OMIozone_interp,filename_OMIO3] = readinterp_OMIozone(imoda_OMI,geog_lat,geog_long);
    ozone=(frac_tauO3.*OMIozone_interp)';
    tau_O3=(ozone*cross_sections.o3')';
    
elseif strcmp(flag_interpOMIo3,'yes')
    
    try
        
        % interpolated o3 fields from OMI L2G product
        daystr = datestr(t(1),'yyyymmdd');
        % go3 = processOMIdataO3(Lat,Lon,daystr);
        g = processOMIdata(Lat,Lon,daystr,'O3');
        
        % calculate o3OD
        tau_O3=(frac_tauO3.*(g.omi/1000))*cross_sections.o3;
        % fill-in with mean values
        
        nanid = find(isnan(tau_O3(:,407)));
        tau_O3(nanid,:) = (frac_tauO3(nanid)*O3col)*cross_sections.o3;
    
    catch
        % if OMI data files are missing
        % defualt read from starinfo
        filename_OMIO3=[];
        ozone=(frac_tauO3*O3col)';
        tau_O3=O3col*cross_sections.o3;
        tau_O3=frac_tauO3*tau_O3;
    end
    
else
        % defualt read from starinfo
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


