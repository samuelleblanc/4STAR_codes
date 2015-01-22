function [visc0, nirc0, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0(t,verbose)

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



version_set('1.2');
if ~exist('verbose','var')
    verbose=true;
end;

if verbose; disp('In starc0'), end;

% control the input
if nargin==0;
    t=now;
end;

% select a source file
if isnumeric(t); % time of the measurement is given; return the C0 of the time.
    if t>=datenum([2014 7 1 0 0 0]); % ARISE; note that the optical throughput was dropped ~20% before ARISE. This was, Yohei believes Roy said, upon cable swap.
        if now>=datenum([2014 9 1 0 0 0]);
            daystr='20141002';
            %daystr='20140830';
            %filesuffix='refined_Langley_on_C130_screened_3.0x'; % This is known to be ~10% low for the second half of ARISE>
            %filesuffix='refined_Langley_on_C-130_from20141002';  % this is from cal-flight (still not final)
            filesuffix='refined_Langley_on_C-130_calib_flight_screened_2x_wFORJcorr';
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
        if now>=datenum([2014 10 17]);
            daystr='20130708';
            filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_20140718';
            % use for separate starsun files to obtaine modified Langley
            %filesuffix='refined_Langley_MLO_constrained_airmass_screened_2x';
        elseif now>=datenum([2014 10 10]) & now<=datenum([2014 10 16]);
            daystr='20130708';
            filesuffix='refined_Langley_at_MLO_screened_3.0x_averagethru20130712_scaled20141010'; % This is not an average MLO cal; rather, it is chosen because the resulting 4STAR transmittance comes close to the AATS's for SEAC4RS ground comparisons (e.g., 20130819).
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
            a=importdata(fullfile(starpaths,visfilename));
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
            visc0(i,:)=load(fullfile(starpaths,visfilename));
            visc0err(i,:)=NaN(1,size(visc0,2));
        end;
        visnote=[visnote visfilename ', '];
        vislstr(i)={visfilename};
        nirfilename=[daystr{i} '_NIR_C0_' filesuffix{i} '.dat'];
        if isequal(orientation,'vertical');
            a=importdata(fullfile(starpaths,nirfilename));
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
            nirc0(i,:)=load(fullfile(starpaths,nirfilename));
            nirc0err(i,:)=NaN(1,size(nirc0,2));
        end;
        nirnote=[nirnote nirfilename ', '];
        nirlstr(i)={nirfilename};
    end;
    visnote=[visnote(1:end-2) '.'];
    nirnote=[nirnote(1:end-2) '.'];
end;

% return channels used for AOD fitting
[visc,nirc]=starchannelsatAATS(t);
cross_sections=taugases(t,'vis',0,0,0.27); % put 0 degree as latitude for the application here; inputting the latitude would be cumbersome to no real effect.
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
cross_sections=taugases(t,'nir',0,0,0.27); % put 0 degree as latitude for the application here; inputting the latitude would be cumbersome to no real effect.
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
    visc0=load(fullfile(starpaths,'20120420_VIS_C0_standard_Langley_on_G1.dat'));
    visnote='C0 from 20120420 airborne Langley on G1.';
    nirc0=load(fullfile(starpaths,'20120420_NIR_C0_standard_Langley_on_G1.dat'));
    nirnote='C0 from 20120420 airborne Langley on G1.';
end;

% C0 not finalized? Unmask the lines below
% visc0=visc0*NaN;nirc0=nirc0*NaN;
% visnotec0='VIS C0 turned off';
% nirnotec0='NIR C0 turned off';

