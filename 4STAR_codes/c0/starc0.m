function [visc0, nirc0, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(t,verbose,instrumentname)

% returns the 4STAR c0 (TOA count rate) for the time (t) of the
% measurement. t must be in the Matlab time format. Leave blank and now is
% assumed. New calibration files should be linked to this code, and all
% other 4STAR codes should obtain the c0 from this code. See also
% starwavelengths.m and Langley.m. To read data from a known c0 file, use
% importdata.m. To save new c0 data, use starsavec0.m.
% Yohei, 2012/05/28, 2012/05/31, 2013/02/19.
% Michal, 2013/02/19.
% Samuel, v1.0, 2014/10/13, added version_set, to version control the current m script
% Samuel, v1.1, 2014/10/15, added verbose keyword
% Michal, v1.2, 2014/11/17, combined version from NAS
% MS, 2014-11-19, added ARISE cal-flight Langley to list
% MS, changed line 21 from 8 1 000 to 7 1 000 to account for pre-ARISE cal
% MS, 2015-01-15, changed ARISE c0 to recent one with Forj correction
% SL, v1.3, 2015-07-22, updated the starc0 for special case testing of lower c0
%                 from Yohei sent on 20150720, new c0 from 20130708
% MS, v1.3, 2015-10-20, updated starc0 with new ARISE c0
% MS, v1,3, 2015-10-28, updated starc0 with new c0 (unc=0.03)
% MS, v1.4, 2016-01-10, updated MLO c0
% SL, v1.5, 2016-02-17, update to what we think should be used from Jan MLO
% MS, v1.6, 2016-04-07, update latest c0 to WFF 20151104, which seems like our best bet.
% MS, v1.7, 2016-05-01, updated c0 from korus-aq transit flight 1
% MS, v1.7, 2016-05-02, updated c0 from korus-aq transit 1, o3 corrected
% SL, v1.8, 2016-08-22, updated c0 from mean MLO June 2016.
% MS, v1.9, 2016-11-09, updated c0 from mean MLO 2016 to KORUS
% SL, v1.10, 2017-04-07, updated c0 from mean MLO 2016 November for ORACLES
% SL, v2.0, 2017-05-27, Updates to use multiple different instruments,
% MS, v2.1, 2018-09-14, updated c0 from MLO 20180812 (tentative) for ORCLES 3 
% MS, v2.1, 2018-09-14, updated mean c0 from MLO Aug-2018 for ORACLES 3
% MS, v2.1, 2018-09-20, updated suffix of starc0 for 4STAR for ORACLES 3

% defined via instrumentname variable, defaults to 4STAR

version_set('2.1');
if ~exist('verbose','var')
    verbose=true;
end;

if verbose; disp('In starc0'), end;

% control the input
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin<=2;
    instrumentname = '4STAR'; % by default use 4STAR
end;

switch instrumentname;
    case {'4STAR'}
        % select a source file
        if isnumeric(t); % time of the measurement is given; return the C0 of the time.
            if t>=datenum([2018 8 1 0 0 0]); %for ORACLES 2018
                if t>=datenum([2018 9 24 0 0 0])
                    daystr = '20181005';
                    filesuffix = 'refined_averaged_4STAR_MLO_inflight';
                elseif t>=datenum([2018 9 21 0 0 0]) %From transit
                     daystr = '20180922';
                     filesuffix = 'refined_averaged_4STAR_MLO_inflight';
                else
                     daystr = '20180811';
                     filesuffix = 'refined_Langley_4STAR_averaged_with_MLO_2018_Aug_11_12';
                end
            elseif t>=datenum([2018 1 1 0 0 0]); %for COSR 2018 and on
                 %daystr = '20180209';
                 %filesuffix = 'refined_averaged_MLO_inflight_polyfit_v2';
                 %filesuffix = 'refined_langley_4STARam_MLOFeb2018_day5_';
                 daystr = '20181005';
                 filesuffix = 'refined_averaged_4STAR_MLO_inflight_withFebMLO';
                 
            elseif t>=datenum([2017 2 1 0 0 0]); %for ORACLES 2017
                if t>=datenum([2017 8 9 0 0 0]); % from averages including the polyfit aod from high altitude during transit
                    daystr = '20170905';
                    %filesuffix = 'refined_averaged_MLO_inflight_polyfit_v2';
                    filesuffix = 'refined_averaged_MLO_inflightsubset_polyfit_withBonanza_specialshortwvl_mid';
                elseif t>=datenum([2017 7 9 0 0 0]); % from averages including the polyfit aod from high altitude during transit
                    daystr = '20170815';
                    %filesuffix = 'refined_averaged_MLO_inflight_polyfit_v2';
                    filesuffix = 'refined_averaged_MLO_inflightsubset_polyfit';
                elseif t>=datenum([2017 7 8 0 0 0]); % using averages of MLO and transit #3
                    daystr = '20170807';
                    filesuffix = 'refined_averaged_MLO_inflight';
                elseif t>=datenum([2017 7 7 0 0 0]); %from Transit #3 to Ascension
                    daystr = '20170807';
                    filesuffix = 'refined_langley_4STAR_subset_pm';
                elseif t>=datenum([2017 7 1 0 0 0]); % From transit #1 Morning at WFF
                    daystr = '20170801';
                    filesuffix = 'refined_langley_4STAR_WFF_ground';
                elseif t>=datenum([2017 2 1 0 0 0]); % From November 2016 MLO, first half before spectrometer dropout7
                    daystr = '20170527';
                    filesuffix = 'refined_Langley_MLO_May2017';
                end;
            elseif t>=datenum([2016 6 30 0 0 0]); %for ORACLES 2016
                if  t>=datenum([2016 9 22 0 0 0]); % From November 2016 MLO, first half before spectrometer dropouts
                    %daystr='20161113';
                    %filesuffix='refined_Langley_MLO_Nov2016part1good_gnd';
                    %daystr = '20160927';
                    %filesuffix = 'refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160927_ORACLES';
                    %filesuffix = 'refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1';
                    daystr = '20160924';
                    filesuffix = 'refined_averaged_inflight_Langley_high_alts_transitback_ORACLES';
                elseif t>=datenum([2016 9 15 10 0 0])&t<datenum([2016 9 22 0 0 0]);
                    filesuffix = 'refined_averaged_inflight_Langley_high_alts_ORACLES';
                    daystr = '20160920';
                elseif t>=datenum([2016 9 11 0 0 0])&t<datenum([2016 9 15 10 0 0]);
                    filesuffix = 'refined_Langley_averaged_with_high_alt_inflight_ORACLES_notransist';
                    daystr = '20160912';
                    
                elseif t>=datenum([2016 9 7 0 0 0])& t<datenum([2016 9 11 0 0 0]);
                     daystr = '20160908';
                     filesuffix = 'refined_Langley_averaged_inflight_high_alts_with_Langley_highRH_ORACLES';   
                %    daystr = '20160918';
                %    filesuffix = 'refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160918_ORACLES';
                elseif t>=datenum([2016 9 3 0 0 0]) & t<datenum([2016 9 7 0 0 0]);
                    daystr = '20160904';
                    filesuffix = 'refined_Langley_averaged_inflight_high_alts_highRH_ORACLES'
                elseif t>=datenum([2016 8 29 0 0 0])&t<datenum([2016 9 3 0 0 0]);
                    daystr = '20160831';
                    filesuffix='refined_Langley_averaged_inflight_Langley_high_alt_ORACLES';
                elseif t>=datenum([2016 8 26 0 0 0])&t<datenum([2016 8 29 0 0 0]); % From November 2016 MLO, first half before spectrometer dropouts
                    %daystr='20161113';
                    %filesuffix='refined_Langley_MLO_Nov2016part1good_gnd';
                    %daystr = '20160904';
                    %filesuffix = 'refined_Langley_averaged_with_MLO_Nov17_airborne_Langley_and_highalt_AOD_on_20160904_ORACLES';
                    %filesuffix = 'refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1';
                    daystr = '20160825';
                    filesuffix = 'refined_Langley_ORACLES_transit2';
                elseif t>=datenum([2016 8 24 0 0 0])&t<=datenum([2016 8 26 0 0 0]);
                    daystr = '20160824';
                    filesuffix = 'refined_Langley_averaged_inflight_Langley_ORACLES_transits';
                elseif t>=datenum([2016 8 23 0 0 0]);
                    %if t>=datenum([2016 8 24 0 0 0]); % From November 2016 MLO, first half before spectrometer dropouts
                    %daystr='20161115';
                    daystr = '20160927';
                    %filesuffix='refined_Langley_MLO_Nov2016part1good_gnd';
                    %filesuffix='refined_Langley_Nov2016part1.5incl1115_good_mean';
                    filesuffix = 'refined_Langley_airborne_ORACLES_averages_v1';
                    filesuffix = 'refined_mix_Langley_airborne_MLO_high_alt_AOD_ORACLES_averages_v1';
                elseif t>=datenum([2016 8 22 0 0 0]);
                    daystr='20160825';
                    filesuffix='refined_Langley_ORACLES_transit2';
                elseif t>=datenum([2016 8 22 0 0 0]);
                    daystr='20160823';
                    filesuffix='refined_Langley_ORACLES_WFF_gnd';
                elseif t>=datenum([2016 6 30 0 0 0]); %MLO June 2016
                    daystr='20160707';
                    filesuffix='Langley_MLO_June2016_mean';
                end;
            elseif t>=datenum([2016 2 11 0 0 0]); % modifications on diffusers, fiber cables, shutter, etc. ended on 2016/03/16
                if now>=datenum([2016 4 7 0 0 0]);
                    %daystr='20151104';
                    %filesuffix='refined_Langley_at_WFF_Ground_screened_3.0x';      % ground-based sunrise measurements at WFF is our best bet for KORUS
                    %filesuffix='refined_Langley_at_WFF_Ground_screened_3correctO3'; % ground-based sunrise measurements at WFF is our best bet for KORUS
                    %daystr='20160109';
                    %filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113_wFORJcorr'; % MLO-Jan-2016 mean
                    %filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113'; % MLO-Jan-2016 mean
                    %daystr='20160426';
                    %korus-aq transit section 1
                    %filesuffix='refined_Langley_korusaq_transit1_v1'; % korus-aq transit 1
                    
                    daystr='20160707';
                    filesuffix='Langley_MLO_June2016_mean';
                    
                elseif now>=datenum([2016 1 19 0 0 0]);
                    %daystr='20160109';
                    %filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113_wFORJcorr'; % MLO-Jan-2016 mean
                    %filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113'; % MLO-Jan-2016 mean
                    
                    daystr='20160707';
                    filesuffix='Langley_MLO_June2016_mean';
                    
                elseif now>=datenum([2016 1 9 0 0 0]);
                    %daystr='20160109';
                    %filesuffix='refined_Langley_MLO'; % adjust date for each of the calibration days
                    
                    daystr='20160707';
                    filesuffix='Langley_MLO_June2016_mean';
                    
                end;
                % transferred from Yohei's laptop, for record keeping
                if now>=datenum([2016 3 19 0 0 0]) && now<=datenum([2016 4 28 0 0 0]);
                    daystr='20160317';
                    filesuffix='compared_with_AATS_at_Ames'; % rooftop comparison with AATS, the local noon value
                elseif now>=datenum([2016 3 18 8 45 0]) && now<=datenum([2016 3 18 9 45 0]); % just to make initial starsun files
                    daystr='20160109';
                    filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113'; % MLO-Jan-2016 mean
                end;
                % end of transferred from Yohei's laptop, for record keeping
            elseif t>=datenum([2016 1 09 0 0 0]); % MLO Jan-2016
                if now>=datenum([2016 1 19 0 0 0]);
                    daystr='20160109';
                    filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113'; % MLO-Jan-2016 mean
                elseif now>=datenum([2016 1 16 0 0 0]);
                    daystr='20160109';
                    %filesuffix='refined_Langley_MLO_wFORJcorr'; % adjust date for each of the calibration days
                    filesuffix='refined_Langley_at_MLO_screened_2.0std_averagethru20160113_wFORJcorr';
                    %filesuffix='refined_Langley_MLOwFORJcorrection1';
                    %filesuffix='refined_Langley_MLO_wstraylightcorr';
                end;
            elseif t>=datenum([2015 9 16 0 0 0]); % NAAMES #1
                if now>=datenum([2016 4 20 0 0 0]); % c0 adjusted for each flight; see NAAMESquickplots.m.
                    if t>datenum([2015 11 23 0 0 0])
                        daystr='20151123';
                        %daystr='20151104';
                        %filesuffix='refined_Langley_at_WFF_Ground_screened_3.0x';
                        filesuffix='adjusted_for_minimum_intraday_changes_in_high_alt_AOD';
                    elseif t>datenum([2015 11 18 0 0 0])
                        daystr='20151118';
                        filesuffix='adjusted_for_minimum_intraday_changes_in_high_alt_AOD';
                    elseif t>datenum([2015 11 17 0 0 0])
                        daystr='20151117';
                        filesuffix='adjusted_for_minimum_intraday_changes_in_high_alt_AOD';
                    elseif t>datenum([2015 11 14 0 0 0])
                        daystr='20151114';
                        filesuffix='adjusted_for_minimum_intraday_changes_in_high_alt_AOD';
                    elseif t>datenum([2015 11 12 0 0 0])
                        daystr='20151112';
                        filesuffix='adjusted_for_minimum_intraday_changes_in_high_alt_AOD';
                    elseif t>datenum([2015 11 09 0 0 0])
                        daystr='20151109';
                        filesuffix='adjusted_for_minimum_intraday_changes_in_high_alt_AOD';
                    else
                        daystr='20151104';
                        filesuffix='refined_Langley_at_WFF_Ground_screened_3.0x'; % ground-based sunrise measurements at WFF
                    end;
                elseif now>=datenum([2016 4 14 0 0 0]); % preliminary uncertainty values (2%) added
                    daystr='20151118';
                    filesuffix='sunrise_refined_Langley_on_C130_screened_3.0x_2percentunc_varyingO3'; % ground-based sunrise measurements at WFF
                elseif now>=datenum([2016 2 16 14 0 0]); % preliminary uncertainty values (2%) added
                    daystr='20151118';
                    filesuffix='sunrise_refined_Langley_on_C130_screened_3.0x_2percentunc'; % ground-based sunrise measurements at WFF % WRONG NIR FORMATTING CORRECTED ON 2016/02/22
                elseif now>=datenum([2015 11 23 0 0 0]);
                    daystr='20151118';
                    filesuffix='sunrise_refined_Langley_on_C130_screened_3.0x'; % WRONG NIR FORMATTING % ground-based sunrise measurements at WFF
                elseif now>=datenum([2015 11 6 0 0 0]);
                    daystr='20151104';
                    filesuffix='refined_Langley_at_WFF_Ground_screened_3.0x'; % ground-based sunrise measurements at WFF
                elseif now>=datenum([2015 9 24 0 0 0]);
                    daystr='20150916';
                    filesuffix='compared_with_AATS_at_Ames'; % Tentative C0, to be replaced once Langley plot is made
                end;
            elseif t>=datenum([2014 8 1 0 0 0]); % ARISE; note that the optical throughput was dropped ~20% before ARISE. This was, Yohei believes Roy said, upon cable swap.
                if now>=datenum([2014 9 1 0 0 0]);
                    %daystr='20140830';
                    daystr='20141002';
                    %filesuffix='refined_Langley_on_C130_screened_3.0x'; % This is known to be ~10% low for the second half of ARISE>
                    %filesuffix='refined_Langley_on_C-130_calib_flight_screened_2x_wFORJcorrAODscreened_wunc';
                    %before Oct-08-2015
                    %filesuffix='refined_Langley_on_C-130_calib_flight_screened_2x_wFORJcorrAODscreened_wunc_201510newcodes';% on Oct-20-2015
                    filesuffix='refined_Langley_on_C-130_calib_flight_screened_2x_wFORJcorrAODscreened_wunc_201510newcodes_unc003';% on Oct-28-2015
                    % use for separate starsun files to obtaine modified Langley
                    %filesuffix='refined_Langley_MLO_constrained_airmass_screened_2x';
                end;
                %     elseif t>=datenum([2013 9 1 0 0 0]) & now>=datenum([2014 10 13]) & now<=datenum([2014 10 16]); % SEAC4RS and post-SEAC4RS latter days
                %             daystr='20130708';
                %             filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled3p20141013'; % This is not an average MLO cal; rather, it is chosen because the resulting 4STAR transmittance comes close to the AATS's for SEAC4RS ground comparisons (e.g., 20130819).
                %     elseif t>=datenum([2013 6 18 0 0 0]) & t<datenum([2013 9 1 0 0 0]) & now>=datenum([2014 10 13]) & now<=datenum([2014 10 16]); % SEAC4RS early days
                %             daystr='20130708';
                %             filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled2p20141013'; % This is not an average MLO cal; rather, it is chosen because the resulting 4STAR transmittance comes close to the AATS's for SEAC4RS ground comparisons (e.g., 20130819).
            elseif t>=datenum([2013 6 18 0 0 0]); % SEAC4RS and post-SEAC4RS; fiber swapped in the evening of June 17, 2013 at Dryden.
                if now>=datenum([2015 7 17]);
                    daystr='20130708';
                    filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled3p20141013';
                    filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled3p20141013'; % sepcial case testing with lower c0
                    %             filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_updated20140718';
                elseif now>=datenum([2014 10 17]);
                    daystr='20130708';
                    filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_20140718';
                    %             filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_updated20140718';
                    % use for separate starsun files to obtaine modified Langley
                    %filesuffix='refined_Langley_MLO_constrained_airmass_screened_2x';
                elseif now>=datenum([2014 10 10]) & now<=datenum([2014 10 16]);
                    daystr='20130708';
                    filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled20141010'; % This is not an average MLO cal; rather, it is chosen because the resulting 4STAR transmittance comes close to the AATS's for SEAC4RS ground comparisons (e.g., 20130819).
                    %             filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_updated20140718';
                elseif now>=datenum([2014 7 18 0 0 0]) & now<=datenum([2014 10 16]);
                    daystr='20130708';
                    filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_updated20140718';
                    % use for separate starsun files to obtaine modified Langley
                    %filesuffix='refined_Langley_MLO_constrained_airmass_screened_2x';
                elseif now>=datenum([2013 7 14 0 0 0]);
                    daystr='20130708';
                    filesuffix='refined_Langley_at_MLO_mbnds_03.2_12.0_screened_3x_averagethru20130712';
                    % use for separate starsun files to obtaine modified Langley
                    %filesuffix='refined_Langley_MLO_constrained_airmass_screened_2x';
                elseif now>=datenum([2013 6 19 0 0 0]);
                    warning('2013 cal is yet to be obtained.')
                    daystr='20130212';
                    filesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214';
                end;
            elseif t>=datenum([2013 1 16 0 0 0]); % y-fiber swapped on Jan 16, 2013 at PNNL (Pasco?).
                if now>=datenum([2013 2 20 0 0 0]);
                    daystr='20130212';
                    filesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214';
                elseif now>=datenum([2013 2 19 0 0 0]);
                    daystr='20130212';
                    filesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone';
                elseif now>=datenum([2013 2 13 0 0 0]);
                    daystr='20130212';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x';
                else; % record keeping
                    warning('2013 cal is yet to be obtained.')
                    daystr='99999999';
                    filesuffix='invalid';
                end;
            elseif t>=datenum([2012 8 23 0 0 0]); % record keeping % 2012December MLO cal
                warning('2012 December cal needs to be updated. Also determine since when this cal should be applied (Sept 2012?).')
                daystr='20121218';
                filesuffix='refined_Langley_at_MLO_screened_2.5x';
            elseif t>=datenum([2012 7 3 0 0 0]); % new VIS spectrometer since July 3, 2012, i.e., the beginning of TCAP
                if now>=datenum([2013 3 22 0 0 0]);
                    daystr='20120722';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updatedunc';
                elseif now>=datenum([2013 1 30 0 0 0]);
                    daystr='20120722';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity';
                elseif now>=datenum([2013 1 27 0 0 0]);
                    daystr='20120722';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x_withOMIozone';
                elseif now>=datenum([2012 10 2 0 0 0]); % record keeping
                    daystr='20120722';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x_averagedwith20120707';
                elseif now>=datenum([2012 7 23 8 0 0]); % record keeping
                    daystr='20120722';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x';
                else; % record keeping
                    daystr='20120707'; % temporary calibration, over m_aero over 1.2 - 1.8.
                    %         filesuffix='refined_Langley_on_G1_screened_2x_with_gas_absorption_ignored';
                    %         filesuffix='refined_Langley_on_G1_second_flight_screened_2x_with_gas_absorption_ignored';
                    filesuffix='refined_Langley_on_G1_second_flight_screened_2x';
                end;
            elseif  t>=datenum([2012 05 25]);
                daystr='MLO2012May';
                filesuffix='refined_Langley_at_MLO_V3';
            else;
                daystr='20120420';
                filesuffix='refined_airborne_Langley_on_G1';
            end;
        else; % special collections
            if isequal(t, 'MLO201205') || isequal(t, 'MLO2012May')
                daystr={'20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
                filesuffix=repmat({'refined_Langley_at_MLO_V3'},size(daystr));
            end;
        end;
    case {'2STAR'}
        if t>datenum([2017 04 10 0 0 0]); %2STAR c0 from MLO May 2017
            daystr = '20170527';
            filesuffix = 'refined_Langley_2STAR_MLO_May2017';
        elseif t>datenum([2015 1 1 0 0 0]); % first 2STARc0
            daystr = '20170527';
            filesuffix = '2STAR_dummy_c0';
        end;
        
    case{'4STARB'}
        if t>=datenum([2018 2 11 0 0 0]); %for COSR 2018 and on
                 daystr = '20180212';
                 %filesuffix = 'refined_averaged_MLO_inflight_polyfit_v2';
                 filesuffix = '4STARB_refined_averaged_good_MLO_Feb2018';
        elseif t>=datenum([2018 1 1 0 0 0]); %for COSR 2018 and on
                 daystr = '20180209';
                 %filesuffix = 'refined_averaged_MLO_inflight_polyfit_v2';
                 filesuffix = 'refined_langley_4STARBam_MLOFeb2018_day5_';
        elseif t>=datenum([2017 08 30 0 0 0]);
            daystr = '20171107';
            filesuffix = '4STARB_Oct2017_rooftop_mean_plus2inflights';
        elseif t>=datenum([2017 08 20 0 0 0]);
            daystr = '20170918';
            filesuffix = 'compared_with_AATS_at_StJohns_version20171003225734up3pb';
        elseif t>=datenum([2017 08 01 0 0 0]);
            daystr = '20170905';
            filesuffix = 'compared_with_AATS_at_Ames_divbyTint';
        else
        error('4STARB starc0 not yet implemented')
        end;
    end; % case
% read the file and return c0 values and notes
if ~exist('visc0')
    if ~exist('filesuffix');
        error('Update starc0.m');
    elseif isstr(filesuffix);
        daystr={daystr};
        filesuffix={filesuffix};
    end;
    visnote=['C0 from ' ];
    nirnote=['C0 from ' ];
    vislstr=repmat({},length(filesuffix),1);
    nirlstr=repmat({},length(filesuffix),1);
    for i=1:length(filesuffix);
        visfilename=[daystr{i} '_VIS_C0_' filesuffix{i} '.dat'];
        orientation='vertical'; % coordinate with starLangley.m.
        if isequal(orientation,'vertical');
            try;
                a=importdata(which(visfilename));
            catch;
                error(['Cant open file: ' visfilename])
            end;
            %             a=importdata(fullfile(starpaths,visfilename));
            visc0(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
            if sum(strcmp(lower(a.colheaders), 'c0err'))>0;
                visc0err(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
            elseif sum(strcmp(lower(a.colheaders), 'c0errlo'))>0 & sum(strcmp(lower(a.colheaders), 'c0errhi'))>0;
                if i~=i;
                    error('This part of code to be developed.');
                end;
                visc0err=[a.data(:,strcmp(lower(a.colheaders), 'c0errlo'))'; a.data(:,strcmp(lower(a.colheaders), 'c0errhi'))'];
            else
                visc0err(i,:)=NaN(1,size(visc0,2));
            end;
            visc0(visc0==-1)=NaN;
            visc0err(visc0err==-1)=NaN;
        else
            visc0(i,:)=load(which(visfilename));
            visc0err(i,:)=NaN(1,size(visc0,2));
        end;
        visnote=[visnote visfilename ', '];
        vislstr(i)={visfilename};
        if ~strcmp(instrumentname, '2STAR');
            nirfilename=[daystr{i} '_NIR_C0_' filesuffix{i} '.dat'];
            if isequal(orientation,'vertical');
                a=importdata(which(nirfilename));
                nirc0(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
                if sum(strcmp(lower(a.colheaders), 'c0err'))>0;
                    nirc0err(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
                elseif sum(strcmp(lower(a.colheaders), 'c0errlo'))>0 & sum(strcmp(lower(a.colheaders), 'c0errhi'))>0;
                    if i~=i;
                        error('This part of code to be developed.');
                    end;
                    nirc0err=[a.data(:,strcmp(lower(a.colheaders), 'c0errlo'))'; a.data(:,strcmp(lower(a.colheaders), 'c0errhi'))'];
                else
                    nirc0err(i,:)=NaN(1,size(nirc0,2));
                end;
                nirc0(nirc0==-1)=NaN;
                nirc0err(nirc0err==-1)=NaN;
            else
                nirc0(i,:)=load(which(nirfilename));
                nirc0err(i,:)=NaN(1,size(nirc0,2));
            end;
            nirnote=[nirnote nirfilename ', '];
            nirlstr(i)={nirfilename};
        else;
            nirc0 = [];
            nirc0err = [];
            nirnote = '';
            nirlstr = '';
        end;%if 2star
    end;
    visnote=[visnote(1:end-2) '.'];
    nirnote=[nirnote(1:end-2) '.'];
end;
if verbose; disp(['Using the C0 from ' visfilename]), end;

% return channels used for AOD fitting
[visc,nirc]=starchannelsatAATS(t,instrumentname);
cross_sections=taugases(t,'vis',0,0,0,0,0.27,2.0e15,instrumentname); % put 0 degree as latitude for the application here; inputting the latitude would be cumbersome to no real effect.
visaerosolcols1=find(exp(-cross_sections.h2oa.*1000.^cross_sections.h2ob)>0.9999 & cross_sections.o2<1e-25);
h2o=abs(exp(-cross_sections.h2oa.*1000.^cross_sections.h2ob));
h2ook=find(isfinite(h2o)==1 & imag(h2o)==0);
h2ong=find(isfinite(h2o)==0 | imag(h2o)~=0);
h2o4ng=interp1(log(cross_sections.wln(h2ook)),h2o(h2ook), log(cross_sections.wln));
h2o(h2ong)=h2o4ng(h2ong);
visaerosolcols=find(h2o>0.9997 & cross_sections.o2<1e-27); % Yohei 2013/01/28
% visaerosolcols1=visaerosolcols1(visaerosolcols1<=1044);
% visaerosolcols2=[repmat(visc(1:9),3,1)+repmat([-1 0 1]',1,9)];
% visaerosolcols=union(visaerosolcols1,visaerosolcols2(:));
if ~strcmp(instrumentname,'2STAR');
    cross_sections=taugases(t,'nir',0,0,0,0,0.27,2.0e15,instrumentname); % put 0 degree as latitude for the application here; inputting the latitude would be cumbersome to no real effect.
    h2o=abs(exp(-cross_sections.h2oa.*1000.^cross_sections.h2ob)); % Yohei 2013/01/28
    niraerosolcols=find(h2o>=0.997 &  cross_sections.o2<1e-29)+1044; % Yohei 2013/01/28
    % niraerosolcols1=[(find(cross_sections.wln/1000>1.000 & cross_sections.wln/1000<1.08))' (find(cross_sections.wln/1000>1.520 & cross_sections.wln/1000<1.69))'];  % column direction transposed
    % niraerosolcols1=[];
    % !!! note the 1236 nm is excluded, as Beat says it's affected by gases??
    % niraerosolcols2=[repmat(nirc([11 13]),3,1)+1044+repmat([-1 0 1]',1,2)];
    % % niraerosolcols3=[repmat(interp1(cross_sections.wln/1000,1:numel(cross_sections.wln),1.640,'nearest'),3,1)+1044+repmat([-1 0 1]',1,1)];
    % niraerosolcols3=[repmat(interp1(cross_sections.wln/1000,1:numel(cross_sections.wln),1.640,'nearest'),3,1)+repmat([-1 0 1]',1,1)];
    % niraerosolcols=union(niraerosolcols1,niraerosolcols2(:)');
    % niraerosolcols=union(niraerosolcols,niraerosolcols3);
    aerosolcols =[visaerosolcols(:)' niraerosolcols(:)'];
else
    aerosolcols =visaerosolcols';
    niraerosolcols = [];
end;
% record keeping
if 1==2; % never executed, just for record keeping
    % preliminary MLO C0, used until 20120625
    if t>=datenum([2012 06 17]);
        daystr='MLO2012May';
        filesuffix='refined_Langley_at_MLO';
    elseif t>=datenum([2012 05 26]);
        daystr='20120526';
        filesuffix='refined_Langley_at_MLO';
    elseif t>=datenum([2012 05 25]);
        daystr='20120525';
        filesuffix='refined_Langley_at_MLO';
        filesuffix='refined_Langley_at_MLO_V2';
    end;
    if isequal(t, 'MLO201205') || isequal(t, 'MLO2012May')
        daystr={'20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO'},size(daystr));
        filesuffix=repmat({'refined_Langley_at_M LO_V2'},size(daystr));
    elseif isequal(t, 'OLD_MLO201205') || isequal(t, 'OLD_MLO2012May')
        daystr={'20120420' '20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO'},size(daystr));
        filesuffix(1)={'refined_Langley_on_G1'};
    end;
    % until 2012/05/23, V0 from standard Langley plots
    visc0=load(which('20120420_VIS_C0_standard_Langley_on_G1.dat'));
    visnote='C0 from 20120420 airborne Langley on G1.';
    nirc0=load(which('20120420_NIR_C0_standard_Langley_on_G1.dat'));
    nirnote='C0 from 20120420 airborne Langley on G1.';
end;

% C0 not finalized? Unmask the lines below
% visc0=visc0*NaN;nirc0=nirc0*NaN;
% visnotec0='VIS C0 turned off';
% nirnotec0='NIR C0 turned off';

