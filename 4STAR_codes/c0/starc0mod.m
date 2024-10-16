function [visc0mod, nirc0mod, visnote, nirnote, visc0moderr, nirc0moderr,model_atmosphere]=starc0mod(t,verbose,instrumentname)

%% Details of the function:
% NAME:
%   starc0mod
%
% PURPOSE:
%   determine which modified c0 is to be used within starwrapper routine.
%   returns the 4STAR c0 (TOA count rate) for the time (t) of the
%   measurement. t must be in the Matlab time format. Leave blank and now is
%   assumed. New calibration files should be linked to this code, and all
%   other 4STAR codes should obtain the c0 from this code. See also
%   modLangley.m.
%
% CALLING SEQUENCE:
%  [visc0mod, nirc0mod, visnote, nirnote, vislstr, nirlstr, viswvcols, nirwvcols, visc0moderr, nirc0moderr]=starc0mod(t,verbose)
%
% INPUT:
%  t: t must be in the Matlab time format.
%  verbose: optional, to set if the function outputs text to the command line
%  instrumentname: optional, defaults to 4STAR, to set which instrument to
%  report the modified c0
%
% OUTPUT:
%  - visc0mod: array of TOA Langley, including water vapor regions
%  modification in vis spectrometer
% - nirc0mod: array of TOA Langley, including water vapor regions
%  modification in nir spectrometer
% visnote/nirnote: note of files used in creating c0mod
% viswvcols/nirwvcols: wavelengths index of water vapor absorption regions
% (vis/nir)
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%  - version_set.m: to version control this m script
%
% NEEDED FILES:
%  - yyyymmdd_VIS_C0_modified_Langley*.mat file created by starModLangleyBothSpec.m
%
% EXAMPLE:
%  - rawout=correct_nonlinear(vis_sun.raw);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, NASA Ames, July 21st, 2014
% Modified (v1.0): Samuel LeBlanc, NASA Ames, October 13th, 2014
%           - added version_set for version control
% Modified (v1.1): Samuel LeBlanc, NASA Ames, October, 15th, 2014
%           - added the verbose keyword
% Modified (v1.2): Samuel LeBlanc, NASA Ames, Febuary, 5th, 2015
%           - added if command for selecting the correct run of either
%           importdata or load depending on matlab version
% Modified, Michal Segal, NASA Ames, February, 9th, 2015
%           - added ARISE c0 option in dates choice
%           - changed to version 1.3
% Modified, Michal Segal, February, 18, 2015
%           - fixed bug related to newmatlab
% Modified, Michal segal, October, 10, 2015
%           - added new 20141002 ARISE c0mod
% Modified, Michal Segal, Jan, 10, 2016, added NAAMES and MLO modified
%                                        Langleys
% Modified, Michal Segal, Apr-07-2016, updating modc0 for KORUS, based on
%                                      NAAMES ground Langley
% Modified, Michal Segal, May-02-2016, updated mod c0 for KORUS transit
% Modified, Michal Segal, Aug-23-2016, updated modc0 for ORACLES based on
%                                      June MLO (20160702) modified Langley
% Modified, Michal Segal, Sep-5-2016,  20160825 modc0 from ORACLES tran#2
% Modified, Samuel LeBlanc, 2017-05-28, v2.0, modified to use the
%                   instrumentname input variable (support for multiple instruments)
% Modified, Michal Segal, 2017-07-24, added c0 for ORACLES 2
% Modified, Michal Segal, 2018-09-14, updated modified Langley for ORACLES
%                                     3; using MLO Aug-2018 data
% -------------------------------------------------------------------------
%% function routine
version_set('2.0');

% control the input
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin<=2;
    instrumentname = '4STAR'; % by default use 4STAR
end;
if ~exist('verbose','var'); verbose=true; end;

if verbose; disp('...in starc0mod'), end;

% get the version of matlab
vv = version('-release');
newmatlab = false;
if str2num(vv(1:4)) >= 2015;
    newmatlab = true;
end;

% select a source file
switch instrumentname;
    case{'4STAR'}
        if isnumeric(t); % time of the measurement is given; return the C0 of the time.
            if t>=datenum([2015 9 16 0 0 0]); %
                if now>=datenum([2018 8 01 0 0 0]) % use MLO Aug 2018 for ORACLES 3 (for now; wait until transit)
                    daystr='20180812';
                    filesuffix='modified_langley_4STAR_MLO'; % 
                    model_atmosphere=2; %use MidLat summer for ORACLES
                    %elseif now>=datenum([2016 3 17 0 0 0]); % KORUS transit for KORUS-AQ
                elseif now>=datenum([2017 2 01 0 0 0]) % use MLO May 2017 for ORACLES 2 (for now; wait until transit)
                    daystr='20170531';
                    filesuffix='modified_Langley_MLO_May2017'; % 
                    model_atmosphere=2; %use MidLat summer for ORACLES
                    %elseif now>=datenum([2016 3 17 0 0 0]); % KORUS transit for KORUS-AQ
                elseif now>=datenum([2016 7 07 0 0 0]) && t>=datenum([2016 7 07 0 0 0]); % use June MLO 2016 for ORACLES
                    %if now>=datenum([2016 7 07 0 0 0]); % use June MLO 2016 for ORACLES
                    %daystr='20160702';
                    %filesuffix='modified_Langley_MLO'; % MLO June 2016
                    daystr='20160825';
                    filesuffix='modified_Langley_ORACLES_transit2'; % ORACLES transit#2
                    model_atmosphere=2; %use MidLat summer for ORACLES
                    %elseif now>=datenum([2016 3 17 0 0 0]); % KORUS transit for KORUS-AQ
                elseif now>=datenum([2016 3 17 0 0 0]) && t>=datenum([2016 4 26 0 0 0]); % KORUS transit for KORUS-AQ
                    %daystr='20151104';
                    %filesuffix='modified_Langley_at_WFF_Ground_screened_3correctO3'; % NAAMES ground with correct O3
                    %daystr='20160109';
                    %filesuffix='modified_Langley_at_MLO_screened_2.0std_averagethru20160113'; % MLO-Jan-2016 mean
                    daystr='20160426';
                    %korus-aq transit section 1
                    filesuffix='modified_Langley_korusaq_transit1_v1'; % korus-aq transit 1
                    model_atmosphere=2; %use MidLat summer for KORUS
                elseif now>=datenum([2016 1 19 0 0 0]);
                    daystr='20160109';
                    filesuffix='modified_Langley_at_MLO_screened_2.0std_averagethru20160113'; % MLO-Jan-2016 mean
                    model_atmosphere=1; %Tropical-MLO
                elseif now>=datenum([2016 1 9 0 0 0]);
                    daystr='20160109';
                    filesuffix='modified_Langley_MLO'; % adjust date for each of the calibration days
                    model_atmosphere=1; %(Tropical-MLO)
                end;
            elseif t>=datenum([2015 9 16 0 0 0]); % NAAMES #1
                if now>=datenum([2015 11 23 0 0 0]);
                    daystr='20151118';
                    filesuffix='modified_Langley_sunrise_refined_Langley_on_C130_screened_3.0';
                    model_atmosphere=3; %(MidLAt-winter)
                end;
            elseif t>=datenum([2014 7 1 0 0 0]); % ARISE;
                if now>=datenum([2014 8 1 0 0 0]);
                    daystr='20141002';
                    %filesuffix='modified_Langley_on_C-130_calib_flight_screened_2x_wFORJcorrAODscreened_wunc';
                    filesuffix='modified_Langley_on_C-130_calib_flight_screened_2x_wFORJcorrAODscreened_wunc_201510newcodes';
                    model_atmosphere=3;% ARISE (first archive MidLat winter coefficients)
                end;
            elseif t>=datenum([2013 6 18 0 0 0]); % fiber swapped in the evening of June 17, 2013 at Dryden.
                if now>=datenum([2014 7 18 0 0 0]);
                    daystr='20130708';
                    %filesuffix='modified_Langley_at_MLO_screened_3.0x_averagethru20130712_updated20140721';
                    %filesuffix='modified_Langley_at_MLO_screened_2.0x_updated20140721';
                    %filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_updated20140718';
                    filesuffix='modified_Langley_at_MLO_screened_2.0std_averagethru20130711';
                    model_atmosphere=2;% SEAC4RS (mid-lat summer)
                elseif now>=datenum([2013 7 14 0 0 0]);
                    daystr='20130708';
                    filesuffix='modified_Langley_MLOscreened_constrained_airmass_2xaveragedthrough20130711';
                    model_atmosphere=2;% SEAC4RS (mid-lat summer)
                elseif now>=datenum([2013 6 19 0 0 0]);
                    warning('2013 cal is yet to be obtained.')
                    daystr='20130214';
                    filesuffix='modified_Langley_on_G1_secondL_flight_6_85km_screened_2x_withOMIozone';
                    % refined langley is:'20130212_VIS_C0_refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214.dat'; % TCAPII c0
                    model_atmosphere=3;% TCAPII (mid-lat winter)
                end;
            elseif t>=datenum([2013 1 16 0 0 0]); % y-fiber swapped on Jan 16, 2013 at PNNL (Pasco?).
                if now>=datenum([2013 2 20 0 0 0]);
                    daystr='20130214';
                    filesuffix='modified_Langley_on_G1_secondL_flight_6_85km_screened_2x_withOMIozone';
                    filesuffix='refined_Langley_on_G1_firstL_flight_screened_2x_withOMIozone_averagedwith20130214';
                    filesuffix='refined_Langley_on_G1_firstL_flight_20PCAscreened_2x_withOMIozone';
                    model_atmosphere=2;% TCAPII (mid-lat winter)
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
                    filesuffix='modified_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updated';% was:'c0_mod22072012_lblrtm6km.mat'
                    % TCAP summer langley: '20120722_VIS_C0_refined_Langley_on_G1_Langley_flight_screened_2x_withOMIozoneCorrect.dat'
                    % most updated c0: 'refined_Langley_on_G1_second_flight_screened_2x_withOMIozonemiddleFORJsensitivity_updatedunc'
                    model_atmosphere=2;% SEAC4RS (mid-lat summer)
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
    case {'4STARB'}
        if t>=datenum([2017 08 01 0 0 0]);
            daystr = '20170905';
            filesuffix = 'compared_with_AATS_at_Ames_divbyTint';
            model_atmosphere=2; %use midlat summer for NAAMES3
        else
            error('4STARB c0mod not yet implemented')
        end;
    case {'2STAR'}
        if t>datenum([2015 1 1 0 0 0]); % first 2STARc0
            daystr = '20170527';
            filesuffix = '2STAR_dummy_c0';
            model_atmosphere=1;
        end;
end; %switch

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
            if newmatlab;
                %                 a=load(fullfile(starpaths,visfilename));
                %                 visc0mod(i,:)=a(:,3);% test
                a=importdata(which(visfilename));
                visc0mod(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
            else;
                a=importdata(which(visfilename));
                visc0mod(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
                %visc0mod(i,:)=a(:,3)';
            end;
            sprintf('%s',size(a,1)) ;
            sprintf('%f',size(a,2)) ;
            sprintf('%s',visfilename);
            %.data(:,strcmp(lower(a.colheaders), 'c0'))';
            %             if sum(strcmp(lower(a.colheaders), 'c0err'))>0;
            %                 visc0moderr(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
            %             elseif sum(strcmp(lower(a.colheaders), 'c0errlo'))>0 & sum(strcmp(lower(a.colheaders), 'c0errhi'))>0;
            %                 if i~=i;
            %                     error('This part of code to be developed.');
            %                 end;
            %                 visc0moderr=[a.data(:,strcmp(lower(a.colheaders), 'c0errlo'))'; a.data(:,strcmp(lower(a.colheaders), 'c0errhi'))'];
            %             else
            visc0moderr(i,:)=NaN(1,size(visc0mod,2));
            %             end;
            visc0mod(visc0mod==-1)=NaN;
            visc0moderr(visc0moderr==-1)=NaN;
        else
            visc0mod(i,:)=load(which(visfilename));
            visc0moderr(i,:)=NaN(1,size(visc0mod,2));
        end;
        visnote=[visnote visfilename ', '];
        vislstr(i)={visfilename};
        if ~strcmp(instrumentname, '2STAR');
            nirfilename=[daystr{i} '_NIR_C0_' filesuffix{i} '.dat'];
            if isequal(orientation,'vertical');
                if newmatlab;
                    %                 a=load(fullfile(starpaths,nirfilename));
                    %                 nirc0mod(i,:)=a(:,3);
                    a=importdata(which(nirfilename));
                    nirc0mod(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
                else;
                    a=importdata(which(nirfilename));
                    nirc0mod(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0'))';
                    %nirc0mod(i,:)=a(:,3)';
                end;
                %             if sum(strcmp(lower(a.colheaders), 'c0err'))>0;
                %                 nirc0moderr(i,:)=a.data(:,strcmp(lower(a.colheaders), 'c0err'))';
                %             elseif sum(strcmp(lower(a.colheaders), 'c0errlo'))>0 & sum(strcmp(lower(a.colheaders), 'c0errhi'))>0;
                %                 if i~=i;
                %                     error('This part of code to be developed.');
                %                 end;
                %                 nirc0moderr=[a.data(:,strcmp(lower(a.colheaders), 'c0errlo'))'; a.data(:,strcmp(lower(a.colheaders), 'c0errhi'))'];
                %             else
                nirc0moderr(i,:)=NaN(1,size(nirc0mod,2));
                %             end;
                nirc0mod(nirc0mod==-1)=NaN;
                nirc0moderr(nirc0moderr==-1)=NaN;
            else
                nirc0mod(i,:)=load(which(nirfilename));
                nirc0moderr(i,:)=NaN(1,size(nirc0mod,2));
            end;
            nirnote=[nirnote nirfilename ', '];
            nirlstr(i)={nirfilename};
        else;
            nirc0mod = [];
            nirc0moderr = [];
            nirnote = '';
            nirlstr = '';
        end;%if 2star
    end;
    visnote=[visnote(1:end-2) '.'];
    nirnote=[nirnote(1:end-2) '.'];
end;

% return channels used for AOD fitting
% [visc,nirc]=starchannelsatAATS(t);
% cross_sections=taugases(t,'vis',0,0,0.27); % put 0 degree as latitude for the application here; inputting the latitude would be cumbersome to no real effect.
% visaerosolcols1=find(exp(-cross_sections.h2oa.*1000.^cross_sections.h2ob)>0.9999 & cross_sections.o2<1e-25);
% h2o=abs(exp(-cross_sections.h2oa.*1000.^cross_sections.h2ob));
% h2ook=find(isfinite(h2o)==1 & imag(h2o)==0);
% h2ong=find(isfinite(h2o)==0 | imag(h2o)~=0);
% h2o4ng=interp1(log(cross_sections.wln(h2ook)),h2o(h2ook), log(cross_sections.wln));
% h2o(h2ong)=h2o4ng(h2ong);
% viswvcols=find(h2o>0.9997 & cross_sections.o2<1e-27); % Yohei 2013/01/28
% visaerosolcols1=visaerosolcols1(visaerosolcols1<=1044);
% visaerosolcols2=[repmat(visc(1:9),3,1)+repmat([-1 0 1]',1,9)];
% visaerosolcols=union(visaerosolcols1,visaerosolcols2(:));
% cross_sections=taugases(t,'nir',0,0,0.27); % put 0 degree as latitude for the application here; inputting the latitude would be cumbersome to no real effect.
% h2o=abs(exp(-cross_sections.h2oa.*1000.^cross_sections.h2ob)); % Yohei 2013/01/28
% nirwvcols=find(h2o>=0.997 &  cross_sections.o2<1e-29)+1044; % Yohei 2013/01/28
% niraerosolcols1=[(find(cross_sections.wln/1000>1.000 & cross_sections.wln/1000<1.08))' (find(cross_sections.wln/1000>1.520 & cross_sections.wln/1000<1.69))'];  % column direction transposed
% niraerosolcols1=[];
% !!! note the 1236 nm is excluded, as Beat says it's affected by gases??
% niraerosolcols2=[repmat(nirc([11 13]),3,1)+1044+repmat([-1 0 1]',1,2)];
% % niraerosolcols3=[repmat(interp1(cross_sections.wln/1000,1:numel(cross_sections.wln),1.640,'nearest'),3,1)+1044+repmat([-1 0 1]',1,1)];
% niraerosolcols3=[repmat(interp1(cross_sections.wln/1000,1:numel(cross_sections.wln),1.640,'nearest'),3,1)+repmat([-1 0 1]',1,1)];
% niraerosolcols=union(niraerosolcols1,niraerosolcols2(:)');
% niraerosolcols=union(niraerosolcols,niraerosolcols3);
% aerosolcols =[viswvcols(:)' nirwvcols(:)'];

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
        filesuffix=repmat({'refined_Langley_at_MLO_V2'},size(daystr));
    elseif isequal(t, 'OLD_MLO201205') || isequal(t, 'OLD_MLO2012May')
        daystr={'20120420' '20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO'},size(daystr));
        filesuffix(1)={'refined_Langley_on_G1'};
    end;
    % until 2012/05/23, V0 from standard Langley plots
    visc0mod=load(which('20120420_VIS_C0_standard_Langley_on_G1.dat'));
    visnote='C0 from 20120420 airborne Langley on G1.';
    nirc0mod=load(which('20120420_NIR_C0_standard_Langley_on_G1.dat'));
    nirnote='C0 from 20120420 airborne Langley on G1.';
end;

% C0 not finalized? Unmask the lines below
% visc0=visc0*NaN;nirc0=nirc0*NaN;
% visnotec0='VIS C0 turned off';
% nirnotec0='NIR C0 turned off';

