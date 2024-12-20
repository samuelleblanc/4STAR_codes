function [visc0, nirc0, visnote, nirnote, vislstr, nirlstr, visaerosolcols, niraerosolcols, visc0err, nirc0err]=starc0lamp(t,verbose,instrumentname)

% returns the 4STAR c0lamp (TOA count rate adjusted with FEL lamp values) for the time (t) of the
% measurement. t must be in the Matlab time format. Leave blank and now is
% assumed.
% MS, 2015-01-09, adopted from starc0 to reflect starc0lamp choice
% 2015-04-14, MS, added seac4rs adjusted c0 filename
% 2017-05-28, SL, v2.0, added instrumentname to handle multiple different
% instruments
%---------------------------------------------------------------------------------------------------


version_set('2.0');
if ~exist('verbose','var')
    verbose=true;
end;

if verbose; disp('In starc0lamp'), end;

% control the input
if nargin==0;
    t=now;
    instrumentname = '4STAR'; % by default use 4STAR
elseif nargin<=2;
    instrumentname = '4STAR'; % by default use 4STAR
end;

% select a source file
% use one adjusted lamp c0 per campaign!
switch instrumentname;
    case {'4STAR'}
        if isnumeric(t); % time of the measurement is given; return the C0 of the time.
            if t>=datenum([2014 7 1 0 0 0]); % ARISE;
                if now>=datenum([2014 9 1 0 0 0]);
                    % values
                    % vis
                    visfilename='20141024_scaled_langley.dat';
                    a=importdata(fullfile(starpaths,visfilename));
                    visc0(1,:)=a.data(1:1044,3)';
                    visc0err(1,:)=NaN(1,size(visc0,2));
                    % nir
                    nirfilename='20141024_scaled_langley.dat';
                    a=importdata(fullfile(starpaths,nirfilename));
                    nirc0(1,:)=a.data(1045:1556,3)';
                    nirc0err(1,:)=NaN(1,size(nirc0,2));
                    
                    % notes
                    visnote=['C0 from ' ];
                    nirnote=['C0 from ' ];
                    visnote=[visnote visfilename ', '];
                    nirnote=[nirnote nirfilename ', '];
                end;
                
            elseif t>=datenum([2013 6 18 0 0 0]); % SEAC4RS and post-SEAC4RS; fiber swapped in the evening of June 17, 2013 at Dryden.
                if now>=datenum([2014 10 17]);
                    
                    % values
                    % vis
                    visfilename='20140716_scaled_langley_seac4rs_c0.dat';
                    a=importdata(fullfile(starpaths,visfilename));
                    visc0(1,:)=a.data(1:1044,3)';
                    visc0err(1,:)=NaN(1,size(visc0,2));
                    % nir
                    nirfilename='20140716_scaled_langley_seac4rs_c0.dat';
                    a=importdata(fullfile(starpaths,nirfilename));
                    nirc0(1,:)=a.data(1045:1556,3)';
                    nirc0err(1,:)=NaN(1,size(nirc0,2));
                    
                    % notes
                    visnote=['C0 from ' ];
                    nirnote=['C0 from ' ];
                    visnote=[visnote visfilename ', '];
                    nirnote=[nirnote nirfilename ', '];
                elseif now>=datenum([2014 10 10]) & now<=datenum([2014 10 16]);
                    disp('need to generate SEAC4RS starc0 lamp adjusted');
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
    case {'4STARB'}
        error('4STARB does not have a defined c0lamp yet')
    case {'2STAR'}
        error('2STAR does not have a defined c0lamp yet')
end;
vislstr = [];
nirlstr = [];

% return channels used for AOD fitting
[visc,nirc]=starchannelsatAATS(t,instrumentname);
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

return;

