function [tau_h2oa tau_h2ob cwv] = gasretrievecwv(starsun,cross_sections)
%
% this function recieves starsun struct and retrieves
% cwv
% 
%---------------------------------------------------
% 
% Michal Jan 17 2014
%---------------------------------------------------
 %% assign Langley and other parameters according to campaign
 %------------------------
 % 
 % c0 files must be in the starpaths directory
 if starsun.t(1)>=datenum([2013 1 16 0 0 0]) && starsun.t(1)<=datenum([2013 6 16 0 0 0]);                                                     % TCAP winter phase
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
    tmp1_ ='20120722_VIS_C0_refined_Langley_on_G1_Langley_flight_screened_2x_withOMIozoneCorrect.dat';
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
    vislampc0 = load('vislampLang.c0');
    nirlampc0 = load('nirlampLang.c0');
end

%% average spectra for retrieval and perform core calc
%----------------------------------------------------%
%  calculate average spectra (tavg in seconds)
%  tavg = 3;      % 3 sec for flight mode, 10 seconds for ground-based
%  [starsun] = spec_aveg_cwv(starsun,tavg);%used for SEAC4RS
 [tau_h2oa tau_h2ob cwv] = cwvcorecalc(starsun,modc0,model_atmosphere,cross_sections);
 %end
 return;
 
