function     [responsivityFOV,responsivityFOVA, responsivityFOVP]=starresponsivityFOV(t, datatype, QdVlr,QdVtb,QdVtot)

% returns the responsivity of 4STAR over pointing direction.
% Yohei, 2012/10/04, 2013/02/13

% YS: In low light channels, noises in FOV measurements appear as if the
% responsivity was noisy. How can we fix this?
% MS: 2014-08-22: added SEAC4RS FOV dates
% SL: v1.0, 2014-10-13: added version control of this m-script via version_set

% specify FOV data source
if now>datenum([2013 7 16 0 0 0]);
    daystr='20130805';
    fova_filen=13; % file number for almucantar FOV
    fovp_filen=12; % file number for principal plane FOV
elseif now>datenum([2013 1 16 0 0 0]);
    daystr='20130213';
    fova_filen=23; % file number for almucantar FOV
    fovp_filen=21; % file number for principal plane FOV
elseif now>datenum([2012 10 3 0 0 0]); % before 2012/10/03 there was no tracking error analysis based on FOV tests
    daystr='20120715';
    fova_filen=18; % file number for almucantar FOV
    fovp_filen=17; % file number for principal plane FOV
end;

% load FOV data
load(fullfile(starpaths, [daystr 'starfov.mat']));

version_set('1.0');

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

