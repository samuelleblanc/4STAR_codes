function [visresp, nirresp, visnote, nirnote, vislstr, nirlstr,visaerosolcols, niraerosolcols, visresperr, nirresperr] = starskyresp(t,instrumentname);

%% Details of the program:
% NAME:
%   starskyresp
% 
% PURPOSE:
%  returns the 4STAR responsivity [cts/ms / W/(m^2.sr.um)] for the time (t) of the
%  measurement. t must be in the Matlab time format. Leave blank and now is
%  assumed. New calibration files should be linked to this code, and all
%  other 4STAR codes should obtain the responsivity functions from this code. See also
%  starwavelengths.m and starLangley.m.  
%
% CALLING SEQUENCE:
%   [visresp, nirresp, visnote, nirnote, vislstr, nirlstr,visaerosolcols, niraerosolcols, visresperr, nirresperr] = starskyresp(t)
%
% INPUT:
%  t: time (in matlab format) of the measurements, to choose the correct
%     response function, when omitted takes the current time
%  instrumentname: (defaults to 4STAR), name of instrument that returns the
%                   proper response function
% 
% OUTPUT:
%  visresp: response function for the vis spectrometer
%  nirresp: response function for the nir spectrometer
%  visnote: notes indicating which response function file used for vis
%  nirnote: notes indicating which response function file used for nir
%  vislstr: visfilename for response function
%  nirlstr: nirfilename for response function
%  visaerosolcols: returns wavelength index to which the aeronet channels match in vis  
%  niraerosolcols: returns wavelength index to which the aeronet channels match in nir
%  visresperr: response uncertainty for vis spectrometer
%  nirresperr: response uncertainty for nir spectrometer 
%
% DEPENDENCIES:
%  - version_set.m (for version control of the script)
%
% NEEDED FILES:
%  - VIS and NIR sky barrell response functions created from HISS
%
% EXAMPLE:
%
%
% MODIFICATION HISTORY:
% Written (v1.0): Yohei Shinozuka, 2012/05/28, 2012/05/31 (ported over from starc0)
% Modified (v1.1): Samuel LeBlanc, NASA Ames, October 14th, 2014
%                  - update to include calibrations from post SEAC4RS and
%                    pre-ARISE
%                  - updated to include links to response functions of
%                    ARISE calibrations
%                  - added version control of this m-script
% Modified (v1.2): Samuel LeBlanc, NASA Ames, 2015-01-08
%                  - update to include post-ARISE cals
% Modified (v1.3): Samuel LeBlanc, NASA Ames, 2015-03-16
%                  - update to include recently modified ARISE cals
% Modified (v1.3): Michal Segal, NASA Ames, 2015-04-10, modified cal dates
%                  for SEAC4RS to correct a bug
% Modified (v1.4): Samuel LeBlanc, NASA Ames, 2015-05-08
%                  for ARISE update with new set of the response functions
% Modified (v1.5): Samuel LeBlanc, NASA Ames, 2015-05-12
%                  Update to ARISE, decision to use pre-cal for entire field
%                  mission, until 2014-10-24
% Modified (v1.6): Samuel LeBlanc, NASA Ames, 2015-11-11, happy veteran's day
%                  Update to NAAMES, put in the pre-NAAMES lab cal
% Modified (v1.7): Samuel LeBlanc, NASA Ames, 2016-09-29
%                  Update with pre KORUS radiance cal data
% Modified (v2.0): Samuel LeBlanc, Hilo, Hawaii, 2017-05-28
%                  Modifed codes to handle multiple different instruments
%
% -------------------------------------------------------------------------

%% start of function
version_set('2.0');

% control the input
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin<=2;
    instrumentname = '4STAR'; % by default use 4STAR
end;

% select a source file
switch instrumentname;
    case {'4STAR'}
if isnumeric(t); % time of the measurement is given; return the response of the time.
    if t>=datenum([2012 7 3 0 0 0])&& t< datenum([2013 1 16 0 0 0]) ; % new VIS spectrometer since July 3, 2012       
        daystr='20120920'; % temporary calibration, over m_aero over 1.2 - 1.8.
        %         filesuffix='refined_Langley_on_G1_screened_2x_with_gas_absorption_ignored';
        %         filesuffix='refined_Langley_on_G1_second_flight_screened_2x_with_gas_absorption_ignored';
        filesuffix='from_20120920_006_VIS_park_with_201112131052Hiss-corrected';
        daystr = '20130506';
        filesuffix = 'with_20130605124300HISS'; 
    elseif t >= datenum([2013 1 16 0 0 0]) && t < datenum([2013 8 1 0 0 0]);
        % response linked to 20130506_VIS_SKY_Resp_with_20130605124300HISS.dat
        daystr = '20130506';
        filesuffix = 'with_20130605124300HISS';    
    elseif t>= datenum([2013 8 1 0 0 0]) && t < datenum([2013 9 24 0 0 0]);
        % updated by SL to use May 2013 radiance calibration from the
        % sphere with 9 lamps - For SEAC4RS data
        daystr = '20130507';
        filesuffix = 'from_20130507_008_VIS_park_with_20130605124300HISS';
    elseif t>= datenum([2013 9 24 0 0 0]) && t < datenum([2014 5 20 0 0 0]);
        daystr = '20131121';
        filesuffix = 'from_20131121_010_VIS_park_with_20130605124300HISS';
    elseif t>= datenum([2014 5 21 0 0 0]) && t < datenum([2014 7 15 0 0 0]);
        % for using calibration from first lab sphere cal
        % with SEAC4RS fiber (not the long one going on ARISE)
        daystr = '20140624'; % date of cal
        filesuffix = 'from_20140624_016_VIS_park_with_20140606091700HISS';
    elseif t >= datenum([2014 7 16 0 0 0]) && t < datenum([2014 9 18 0 0 0]);
        % for using calibration from second lab sphere cal
        % with long fiber for the ARISE field campaign
        daystr = '20140716';
        filesuffix = 'from_20140716_003_VIS_park_with_20140606091700HISS';
        %filesuffix = 'from_20140716_004_VIS_park_with_20140606091700HISS';
    elseif t >= datenum([2014 9 18 0 0 0]) && t < datenum([2014 09 26 0 0 0]);
        % for using calibration from second lab sphere cal
        % with long fiber for the ARISE field campaign
        daystr = '20140926';
        filesuffix = 'from_20140926_004_NIR_park_with_20140716_small_sphere_rad';
        %filesuffix = 'from_20141024_009_VIS_park_with_20140606091700HISS';
    elseif t >= datenum([2014 9 26 0 0 0]) && t < datenum([2015 09 14 0 0 0]);
        % for using calibration from second lab sphere cal
        % with long fiber for the ARISE field campaign
        daystr = '20141024';
        filesuffix = 'from_20141024_005_VIS_park_with_20140606091700HISS';
        %filesuffix = 'from_20141024_009_VIS_park_with_20140606091700HISS';
    elseif t >= datenum([2015 09 15 0 0 0]) && t < datenum([2016 03 30 0 0 0]);
        % For using calibration from the pre-NAAMES-2015 large sphere lab
        % cal
        daystr = '20150915';
        filesuffix = 'from_20150915_012_VIS_park_with_20140606091700HISS';
    elseif t >= datenum([2016 03 30 0 0 0]) && t< datenum([2017 06 19 0 0 0]);
        daystr = '20160330';
        filesuffix = 'from_20160330_018_VIS_ZEN_with_20160121125700HISS';
    elseif t >= datenum([2017 06 20 0 0 0]) && t< datenum([2017 08 27 0 0 0]);
        daystr = '20170620';
        filesuffix = 'from_4STAR_20170620_009_VIS_ZEN_with_20160121125700HISS';
    elseif t >= datenum([2017 08 27 0 0 0]) && t< datenum([2017 12 10 0 0 0]);
        % for ORACLES 2017 only ** to be updated
        disp('Using bad sky barrel response function. Please update.')
        daystr = '20171102';
        filesuffix = 'from_4STAR_20171102_005_VIS_ZEN_with_20160121125700HISS';
    elseif t >= datenum([2017 12 10 0 0 0]);
        % for COSR and ORACLES 2018 - using updated radiance values from
        % the spectralon panel tests
        daystr = '20180210';
        filesuffix = 'from_4STAR_Spectralon_panel_203709_with_4STAR_20180210_002';
    end;  
else % special collections 
    % cjf: need to generate radiance cals from March data to be used at MLO
    if isequal(t, 'MLO201205') || isequal(t, 'MLO2012May')
        daystr={'20120525' '20120526' '20120528' '20120531' '20120601' '20120602' '20120603'};
        filesuffix=repmat({'refined_Langley_at_MLO_V3'},size(daystr));
    end;
end;
    case {'4STARB'}
        
        %warning('4STARB radiance response using old HISS values, and old fiber configuration')
        if t< datenum([2017 07 15 0 0 0]);
            daystr = '20170621';
            filesuffix = 'from_4STARB_20170621_005_VIS_ZEN_with_20160121125700HISS';
        elseif t>= datenum([2017 07 15 0 0 0]);
            daystr = '20171102';
            filsuffix = 'from_4STARB_20171102_004_NIR_ZEN_with_20160121125700HISS';
        end;
    case {'2STAR'}
        warning('2STAR does not have a radiance measurement, returning nul arrays')
        visresp=[]; nirresp=[]; visnote=''; nirnote=''; 
        vislstr=''; nirlstr=''; visaerosolcols=[]; niraerosolcols=[]; 
        visresperr=[]; nirresperr=[];
        return
end; %switch instrumentname

% read the file and return response values and notes
if ~exist('visresp')
    if ~exist('filesuffix');
        error('Update starskyresp.m');
    elseif isstr(filesuffix);
        daystr={daystr};
        filesuffix={filesuffix};
    end;
    visnote=['Resp from '];
    nirnote=['Resp from '];
    vislstr=repmat({},length(filesuffix),1);
    nirlstr=repmat({},length(filesuffix),1);
    for i=1:length(filesuffix);
        visfilename=[daystr{i} '_VIS_SKY_Resp_' filesuffix{i} '.dat'];
        orientation='vertical'; % coordinate with starLangley.m.
        if isequal(orientation,'vertical');
            if not(exist(which(visfilename)));
                warning(['*** File not found:' which(visfilename)])
            end;
            a=importdata(which(visfilename));
            visresp(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resp'))';
            if sum(strcmp(lower(a.colheaders), 'resperr'))>0;
                visresperr(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resperr'))';
            else
                visresperr(i,:)=NaN(1,size(visresp,2));
            end;
        else
            visresp(i,:)=load(which(visfilename));
            visresperr(i,:)=NaN(1,size(visresp,2));
        end;
        visnote=[visnote visfilename ', '];
        vislstr(i)={visfilename};
        nirfilename=strrep(visfilename,'VIS','NIR');
        if isequal(orientation,'vertical');
            a=importdata(which(nirfilename));
            nirresp(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resp'))';
            if sum(strcmp(lower(a.colheaders), 'resperr'))>0;
            nirresperr(i,:)=a.data(:,strcmp(lower(a.colheaders), 'resperr'))';
        else
            nirresperr(i,:)=NaN(1,size(nirresp,2));
        end;
        else
            nirresp(i,:)=load(which(nirfilename));
            nirresperr(i,:)=NaN(1,size(nirresp,2));
        end;
        nirnote=[nirnote nirfilename ', '];
        nirlstr(i)={nirfilename};
    end;
    visnote=[visnote(1:end-2) '.'];
    nirnote=[nirnote(1:end-2) '.'];
end;

% return channels used for AOD fitting
[visaerosolcols,niraerosolcols]=starchannelsatANET(t);
goodvis = sum(~isNaN(visaerosolcols));
% visaerosolcols=[repmat(visaerosolcols(~isNaN(visaerosolcols)),3,1)+repmat([-1 0 1]',1,goodvis)];
goodnir = sum(~isNaN(niraerosolcols));

% niraerosolcols=[repmat(niraerosolcols(~isNaN(niraerosolcols)),3,1)+1044+repmat([-1 0 1]',1,goodnir)]; 
aerosolcols=[visaerosolcols niraerosolcols];


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
    visresp=load(which('20120420_VIS_C0_standard_Langley_on_G1.dat'));
    visnote='C0 from 20120420 airborne Langley on G1.';
    nirresp=load(which('20120420_NIR_C0_standard_Langley_on_G1.dat'));
    nirnote='C0 from 20120420 airborne Langley on G1.';
end;

return

function [visaerosolcols,niraerosolcols] = starchannelsatANET(t)
% anet_wl = [440, 673, 873, 1022]; 
anet_wl = [440, 675, 870, 995.5]; % substituting longest VIS spectrometer wavelength 
[visw, nirw]=starwavelengths(nanmean(t));
visaerosolcols = interp1(1000.*visw, [1:length(visw)],anet_wl,'nearest');
% visaerosolcols = interp1(1000.*visw, [1:length(visw)],anet_wl,'nearest','extrap');
visaerosolcols = unique(visaerosolcols); 
visaerosocols(visaerosolcols<1 | visaerosolcols>length(visw)) = NaN;
visaerosolcols(isNaN(visaerosolcols))= [];

niraerosolcols = interp1(1000.*nirw, [1:length(nirw)],anet_wl,'nearest')+1044;
niraerosolcols(isNaN(niraerosolcols))= [];
return
% SSA441-T,SSA673-T,SSA873-T,SSA1022-T

