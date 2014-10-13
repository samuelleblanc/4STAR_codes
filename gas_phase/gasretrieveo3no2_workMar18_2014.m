function [tau_o3 o3vcd tau_no2 no2vcd MSEo3DU2 MSEno2DU2] = gasretrieveo3no2(starsun,cross_sections)
%
% this function recieves starsun struct and retrieves
% no2, o3 (o4 is optional)-add o4vcd afterwars
% 
%---------------------------------------------------
% Michal Segal, Sep 20 2013
% Michal added cwv as well - Sep 23 2013
% Michal modified for O3/NO2 retrieval
%---------------------------------------------------
 %% assign Langley and other parameters according to campaign
 %------------------------
 % 
 % c0 files must be in the starpaths directory
 if starsun.t(1)>=datenum([2013 1 16 0 0 0]) && starsun.t(1)<=datenum([2013 6 16 0 0 0]);                                                      % TCAP winter phase
    %tmp1  =importdata('20130212_VIS_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214.dat');              % TCAPII c0
    %tmp11 =importdata('20130214_VIS_C0_refined_Langley_on_G1_secondL_flight_2xPCAgoodscreened_2x_withOMIozone.dat');                         % TCAPII c0pca
    % 20130214_VIS_C0_refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone
    %tmp1  =importdata('20130214_VIS_C0_refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone.dat');  
    tmp1_ ='20130212_VIS_C0_refined_Langley_on_G1_Langley_flight_screened_2x_withOMIozoneScaled.dat';  
    tmp1  = importdata(fullfile(starpaths, tmp1_));
    c0    = tmp1.data(:,3); 
    tmp2_ ='20130214_VIS_C0_modified_Langley_on_G1_secondL_flight_6_85km_screened_2x_withOMIozone.dat';                                       % TCAPII modified c0
    tmp2  = importdata(fullfile(starpaths, tmp2_));
    modc0 = tmp2.data(:,3);
    model_atmosphere = 3;          % mid-latitude winter (Rayleigh)
elseif starsun.t(1)<datenum([2013 1 16 0 0 0])                                                                                               % TCAP summer phase
    %tmp1  = importdata('20120722_VIS_C0_refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updatedunc.dat'); % TCAPI c0 - correct
    %tmp1 = importdata('20120722_VIS_C0_refined_Langley_on_G1_secondL_flight_screened_2x_withOMIozone323Lscaled.dat');                       % this is adjusted for 323 scaled ozone
    %tmp1 =
    %tmp1_ ='20120722_VIS_C0_refined_Langley_on_G1_Langley_flight_screened_2x_withOMIozoneCorrect.dat';                                       % used for all processes
    tmp1_ ='20120722_VIS_C0_refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updatedunc.dat';               % recent-2014-forj correction
    tmp1  = importdata(fullfile(starpaths, tmp1_)); 
    c0    = tmp1.data(:,3); 
    tmp2_ ='c0_mod22072012_lblrtm6km.mat';                                                                                                   % TCAPI modified c0
    tmp2  = importdata(fullfile(starpaths, tmp2_)); 
    modc0 = tmp2.c0_mod;
    model_atmosphere = 2;          % mid-latitude summer (Rayleigh)
elseif starsun.t(1)>=datenum([2013 6 16 0 0 0])&&starsun.t(1)<=datenum([2013 7 1 0 0 0]);                                                    % SEAC4RS SARP flights
    tmp1_ ='20130212_VIS_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214.dat';                          % TCAPII c0
    tmp1  = importdata(fullfile(starpaths, tmp1_));
    c0    = tmp1.data(:,3); 
    tmp2_ ='20130214_VIS_C0_modified_Langley_on_G1_secondL_flight_6_85km_screened_2x_withOMIozone.dat';                                      % TCAPII modified c0
    tmp2  = importdata(fullfile(starpaths, tmp2_));
    modc0 = tmp2.data(:,3);
    model_atmosphere = 2;          % mid-latitude summer (Rayleigh)
elseif starsun.t(1)>=datenum([2013 7 1 0 0 0]);                                                                                              % MLO 2013 calibration&SEAC4RS
    %tmp1  =importdata('20130711_VIS_C0_refined_Langley_MLO_constrained_airmass_screened_2x.dat');                                           % c0
    tmp1_  ='20130708_VIS_C0_refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x_averagethru20130712.dat';                                    % c0 from MLO 06-07/2013 calibration
    tmp1 = importdata(fullfile(starpaths, tmp1_));
    c0    = tmp1.data(:,3);
    tmp2_ = '20130708_VIS_C0_modified_Langley_MLOscreened_constrained_airmass_2xaveragedthrough20130711.dat';                                % modified c0
    tmp2 = importdata(fullfile(starpaths, tmp2_));
    modc0 = tmp2.data(:,3); 
    model_atmosphere = 2;          % MidLat summer (Rayleigh)
    
    
% add temperature correction factor (not sure if should be here???)
    date = datestr(starsun.t(1),'yyyymmdd');
    if    strcmp(date,'20130816')
        correctf = load(fullfile(starpaths, ['star' date 'c0corrfactor.dat']));
        c0 = c0.*correctf(1:1044)';
    elseif strcmp(date,'20130818')
        correctf = load(fullfile(starpaths, ['star' date 'c0corrfactor.dat']));
        c0 = c0.*correctf(1:1044)';
    elseif strcmp(date,'20130819')
        correctf = load(fullfile(starpaths, ['star' date 'c0corrfactor.dat']));
        c0 = c0.*correctf(1:1044)';
    elseif strcmp(date,'20130821')
        correctf = load(fullfile(starpaths, ['star' date 'c0corrfactor.dat']));
        c0 = c0.*correctf(1:1044)';
    elseif strcmp(date,'20130906')
        correctf = load(fullfile(starpaths, ['star' date 'c0corrfactor.dat']));
        c0 = c0.*correctf(1:1044)';
        
    end
end

%% average spectra for retrieval and perform core calc
%----------------------------------------------------%
%  calculate average spectra (tavg in seconds)
%  tavg = 3;      % 3 sec for flight mode, 10 seconds for ground-based
%  [starsun] = spec_aveg_o3no2(starsun,tavg);%used for SEAC4RS
%  %[spc_avg spc_pca_avg tau_a_avg tau_ray_avg spc_std UTavg tavg Altavg Latavg Lonavg Presavg sza_avg m_O3_avg m_NO2_avg m_H2O_avg m_aero_avg dvlr_avg m_ray_avg] = spec_aveg_samesize(starsun,tavg);%used for SEAC4RS
 % core calculation (filters have to be applied after-math)
 % perform std filter for gas analysis data points
 % pass rel_std<=1% (@670 nm)
%  std_filt=logical(abs((starsun.spc_std(:,626)./starsun.spc_avg(:,626))*100)<=1);
%  idxuse=logical(starsun.dvlr_avg<=0.3&starsun.dvlr_avg>=-0.3&std_filt==1);    % 0.1 used for TCAP, 0.3 for SEAC4RS 
%  [tau_h2oa tau_h2ob cwv] = h2ocorecalc(starsun,modc0,model_atmosphere,idxuse,cross_sections);
[tau_o3 o3vcd tau_no2 no2vcd o4vcd MSEo3DU2 MSEno2DU2] = o3no2corecalc(starsun,c0,cross_sections);
 %end
 return;
 
