function label=starfieldname2label(fieldname)

% returns a pre-set label for the given 4STAR variable name.
% Yohei, 2012/04/22

pairs={'t' 'UTC'
    'Str' 'Shutter'
    'Md' 'Mode'
    'Zn' 'Zone'
    'Lat' 'Latitude'
    'Lon' 'Longitude'
    'Alt' 'Altitude (m)' % in meter at least for TCAP G1
    'Headng' 'Heading'
    'pitch' 'Pitch'
    'roll' 'Roll'
    'Tst' 'Tst (degC)'
    'Pst' 'Pst (hPa)'
    'RH' 'RH (%)'
    'AZstep' 'AZstep'
    'Elstep' 'Elstep'
    'AZ_deg' 'AZ_deg'
    'El_deg' 'El_deg'
    'QdVlr' 'Quad Left-Right'
    'QdVtb' 'Quad Top-Bottom'
    'QdVtot' 'Quad Total'
    'AZcorr' 'AZcorr'
    'ELcorr' 'ELcorr'
    'Tbox' 'Tbox'
    'Tprecon' 'Tprecon'
    'RHprecon' 'RHprecon'
    'Tint' 'Integration Time (ms)'
    'AVG' 'AVG'
    'raw' 'Raw Count'
    'rate' 'Count Rate (/ms)'
    'rateaero' 'Count Rate (/ms) for Aerosol'
    'm_ray' 'Rayleigh Airmass Factor'
    'm_aero' 'Aerosol Airmass Factor'
    'am' 'Airmass Factor (from sunae.m)'
    'c0' 'C0 (TOA Count Rate) (/ms)'
    'zen' 'Solar Zenith Angle (from sunae.m)'
    'dAZsmdt' 'dAZ_{sm}/dt (deg/s)'
    'od' 'Total Optical Depth'
    'P1' 'P1 Can Pressure (see data sheet)'
    'P2' 'P2 Can RH (see data sheet)'
    'P3' 'P3 Not Connected'
    'P4' 'P4 Not Connected'
    'T1' 'T1 Elevation Motor Temp.'
    'T2' 'T2 Elevation Skin Temp'
    'T3' 'T3 Can Temperature'
    'T4' 'T4 Azimuth Head Temperature'};

ok=find(strcmp(fieldname,pairs(:,1))==1);
if isempty(ok);
    label=char(fieldname);
    sf=strfind(fieldname,'.');
    if ~isempty(sf)
        fieldname1=fieldname(sf(1)+1:end);
        ok=find(strcmp(fieldname1,pairs(:,1))==1);
        if numel(ok)==1
            label=char(pairs(ok,2));
        end;
    end;
elseif numel(ok)==1
    label=char(pairs(ok,2));
elseif numel(ok)>1;
    error('Puzzling.');
end;