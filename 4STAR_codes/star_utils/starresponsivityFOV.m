function     [responsivityFOV,responsivityFOVA, responsivityFOVP]=starresponsivityFOV(t, datatype, QdVlr,QdVtb,QdVtot,instrumentname)

% returns the responsivity of 4STAR over pointing direction.
% Yohei, 2012/10/04, 2013/02/13

% YS: In low light channels, noises in FOV measurements appear as if the
% responsivity was noisy. How can we fix this?
% MS: 2014-08-22: added SEAC4RS FOV dates
% SL: v1.0, 2014-10-13: added version control of this m-script via version_set
% MS: v1.1, added Yohei's FOV updates
% SL: v1.2, 2017-05-09, added FOV for ORACLES, and modified load for using 4STAR's name in the file
% SL: v2.0, 2017-05-28, modified for use with multiple instruments, added the instrumentname variable (defaults to 4STAR)
% MS: v2.0, 2017-06-05, modified line 58 to fit SARP and KORUS-AQ; based on
%                       ORACLES FOV, which are closest in time

if ~exist('instrumentname');
    instrumentname = '4STAR';
end;

% specify FOV data source
switch instrumentname;
    case {'4STAR'}
if t>datenum([2016 8 1 0 0 0]); %ORACLES
    daystr = '20160923';
    fova_filen=3; % filenumber of 15
    fovp_filen=1; % filenumber of 11
elseif t>datenum([2013 7 16 0 0 0]); % SEAC4RS. NAAMES #1 data processing relies on this FOV too. More notes below.
    daystr='20130805';
    fova_filen=13; % file number for almucantar FOV
    fovp_filen=12; % file number for principal plane FOV
    % NAAMES #1 did not yield a good FOV test, due primarily to the short
    % days and unfavorable sky conditions. For post-experiment data
    % processing, time periods of failed tracking were identified by manual
    % data inspection. The tracking error in computed AOD for other time
    % periods is estimated to be smaller than the error due to c0
    % uncertainty, etc.
elseif t>datenum([2013 1 16 0 0 0]);
    daystr='20130213';
    fova_filen=23; % file number for almucantar FOV
    fovp_filen=21; % file number for principal plane FOV
elseif t>datenum([2012 10 3 0 0 0]); % before 2012/10/03 there was no tracking error analysis based on FOV tests
    daystr='20120715';
    fova_filen=18; % file number for almucantar FOV
    fovp_filen=17; % file number for principal plane FOV
end;
    case {'4STARB'}
        warning('4STARB FOV not yet implemented, using recent 4STAR')
        daystr = '20160923';
        fova_filen=3; % filenumber of 15
        fovp_filen=1; % filenumber of 11
        instrumentname = '4STAR';
    case {'2STAR'}
        warning('2STAR FOV not yet implemented, using recent modified 4STAR')
        daystr = '20160923';
        fova_filen=3; % filenumber of 15
        fovp_filen=1; % filenumber of 11
end; %switch instrumentname
% load FOV data
%if t>datenum([2016 6 15 0 0 0]);% FOV for SARP/KORUS-AQ
if t>datenum([2016 4 15 0 0 0]);% FOV for SARP/KORUS-AQ
    daystr = '20160923';
    fova_filen=3; % filenumber of 15
    fovp_filen=1; % filenumber of 11
    load(which([instrumentname '_' daystr 'starfov.mat']));
else
    daystr = '20160923';
    fova_filen=3; % filenumber of 15
    fovp_filen=1; % filenumber of 11
    load(which( [daystr 'starfov.mat']));
end;
version_set('2.0');

if isequal(lower(datatype(1:3)), 'vis') || isequal(lower(datatype(1:3)), 'sun');
    if strcmp(daystr,'20130805')
        sa=vis_fova;
        sp=vis_fovp;
    else
        sa=vis_fova(fova_filen);
        sp=vis_fovp(fovp_filen);
    end
elseif isequal(lower(datatype(1:3)), 'nir');
    if strcmp(daystr,'20130805')
        sa=nir_fova;
        sp=nir_fovp;
    else
        sa=nir_fova(fova_filen);
        sp=nir_fovp(fovp_filen);
    end
end;
if isequal(lower(datatype(1:3)), 'sun') | isequal(lower(datatype(1:3)), 'sky'); % VIS+NIR
    if strcmp(daystr,'20130805')
        san=nir_fova;
        spn=nir_fovp;
        sa.nrate=[sa.nrate san.nrate];
        sp.nrate=[sp.nrate spn.nrate];
    elseif strcmp(instrumentname,'2STAR')
        if strcmp(daystr,'20160923'); %special case processing when FOV not yet defined
            visw_2s = starwavelengths(t,'2STAR').*1000.0;
            sa.nrate=interp1(sa.w,sa.nrate,visw_2s);
            sp.nrate=interp1(sp.w,sp.nrate,visw_2s);
        end
    else
        san=nir_fova(fova_filen);
        spn=nir_fovp(fovp_filen);
        sa.nrate=[sa.nrate san.nrate];
        sp.nrate=[sp.nrate spn.nrate];
    end
end;

% translate the quad signals into responsivity
responsivityFOVA=interp1(sa.QdVlr./sa.QdVtot, sa.nrate, QdVlr./QdVtot);
responsivityFOVP=interp1(sp.QdVtb./sp.QdVtot, sp.nrate, QdVtb./QdVtot);
responsivityFOV=responsivityFOVA.*responsivityFOVP;

