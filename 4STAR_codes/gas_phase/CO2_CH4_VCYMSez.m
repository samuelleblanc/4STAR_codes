function [CO2_vercol,CH4_vercol]=CO2_CH4_VCYMSez(alt,dec_or_t,lat)

%computes CO2 and CH4 vertical column according to height 
% CO2_vercol is given in molec/cm2
% CH4_vercol is given in molec/cm2
% enter alt (the base altitude of calculation) in meters
% for example: Ames rooftop = 10 meters
% also enter declination or time, the latter in the Matlab style. And
% latitude.
% Based on O2_VCYMS.m
% SL, July 11th, 2022
version_set('v1.0')

scale_co2 = true;

if ~isequal(size(alt),size(dec_or_t)) || ~isequal(size(alt),size(lat))
    error('alt, dec_or_t and lat must be the same size.');
end;
model_atm=modelatm(dec_or_t,lat);
CO2_vercolall=NaN(size(alt));
CH4_vercolall=NaN(size(alt));

if scale_co2
    x = dec_or_t-datenum([1958 3 31 0 0 0]);
    scaler_co2 = 0.6238*sin(0.0175869*x-0.4093939) - 0.00151 +...
        9.95962278e-08*x.^2+2.05187056e-03*x+3.14688027e+02; %rough parameterization for MLO
    scaler_co2 = scaler_co2/330.;
end

%% Set modeled values
%     DATA CO2    From MLATMB_revised_nov2004 (Livingston based on Anderson standard model atmosphere)
CO2_profile_ppmv = [3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02, 3.300E+02,...
          3.300E+02, 3.280E+02, 3.200E+02, 3.100E+02, 2.700E+02,...
          1.950E+02, 1.100E+02, 6.000E+01, 4.000E+01, 3.500E+01];
CO2PPMV(:,1) = CO2_profile_ppmv'; %same CO2 profile for all atmospheric models
CO2PPMV(:,2) = CO2_profile_ppmv';
CO2PPMV(:,3) = CO2_profile_ppmv';
CO2PPMV(:,4) = CO2_profile_ppmv';
CO2PPMV(:,5) = CO2_profile_ppmv';
CO2PPMV(:,6) = CO2_profile_ppmv';
     
%       DATA  CH4 %from the same as CO2
%     
CH4PPMV(:,1) = [1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00,...
          1.700E+00, 1.700E+00, 1.699E+00, 1.697E+00, 1.693E+00,...
          1.685E+00, 1.675E+00, 1.662E+00, 1.645E+00, 1.626E+00,...
          1.605E+00, 1.582E+00, 1.553E+00, 1.521E+00, 1.480E+00,...
          1.424E+00, 1.355E+00, 1.272E+00, 1.191E+00, 1.118E+00,...
          1.055E+00, 9.870E-01, 9.136E-01, 8.300E-01, 7.460E-01,...
          6.618E-01, 5.638E-01, 4.614E-01, 3.631E-01, 2.773E-01,...
          2.100E-01, 1.651E-01, 1.500E-01, 1.500E-01, 1.500E-01,...
          1.500E-01, 1.500E-01, 1.500E-01, 1.400E-01, 1.300E-01,...
          1.200E-01, 1.100E-01, 9.500E-02, 6.000E-02, 3.000E-02]';

CH4PPMV(:,2) = [1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00, 1.697E+00,...
          1.687E+00, 1.672E+00, 1.649E+00, 1.629E+00, 1.615E+00,...
          1.579E+00, 1.542E+00, 1.508E+00, 1.479E+00, 1.451E+00,...
          1.422E+00, 1.390E+00, 1.356E+00, 1.323E+00, 1.281E+00,...
          1.224E+00, 1.154E+00, 1.066E+00, 9.730E-01, 8.800E-01,...
          7.888E-01, 7.046E-01, 6.315E-01, 5.592E-01, 5.008E-01,...
          4.453E-01, 3.916E-01, 3.389E-01, 2.873E-01, 2.384E-01,...
          1.944E-01, 1.574E-01, 1.500E-01, 1.500E-01, 1.500E-01,...
          1.500E-01, 1.500E-01, 1.500E-01, 1.400E-01, 1.300E-01,...
          1.200E-01, 1.100E-01, 9.500E-02, 6.000E-02, 3.000E-02]';

CH4PPMV(:,3) = [1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00, 1.697E+00,...
          1.687E+00, 1.672E+00, 1.649E+00, 1.629E+00, 1.615E+00,...
          1.579E+00, 1.542E+00, 1.508E+00, 1.479E+00, 1.451E+00,...
          1.422E+00, 1.390E+00, 1.356E+00, 1.323E+00, 1.281E+00,...
          1.224E+00, 1.154E+00, 1.066E+00, 9.730E-01, 8.800E-01,...
          7.931E-01, 7.130E-01, 6.438E-01, 5.746E-01, 5.050E-01,...
          4.481E-01, 3.931E-01, 3.395E-01, 2.876E-01, 2.386E-01,...
          1.944E-01, 1.574E-01, 1.500E-01, 1.500E-01, 1.500E-01,...
          1.500E-01, 1.500E-01, 1.500E-01, 1.400E-01, 1.300E-01,...
          1.200E-01, 1.100E-01, 9.500E-02, 6.000E-02, 3.000E-02]';

CH4PPMV(:,4) = [1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00, 1.697E+00,...
          1.687E+00, 1.672E+00, 1.649E+00, 1.629E+00, 1.615E+00,...
          1.579E+00, 1.542E+00, 1.506E+00, 1.471E+00, 1.434E+00,...
          1.389E+00, 1.342E+00, 1.290E+00, 1.230E+00, 1.157E+00,...
          1.072E+00, 9.903E-01, 9.170E-01, 8.574E-01, 8.013E-01,...
          7.477E-01, 6.956E-01, 6.442E-01, 5.888E-01, 5.240E-01,...
          4.506E-01, 3.708E-01, 2.992E-01, 2.445E-01, 2.000E-01,...
          1.660E-01, 1.500E-01, 1.500E-01, 1.500E-01, 1.500E-01,...
          1.500E-01, 1.500E-01, 1.500E-01, 1.400E-01, 1.300E-01,...
          1.200E-01, 1.100E-01, 9.500E-02, 6.000E-02, 3.000E-02]';

CH4PPMV(:,5) = [1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00, 1.697E+00,...
          1.687E+00, 1.672E+00, 1.649E+00, 1.629E+00, 1.615E+00,...
          1.579E+00, 1.542E+00, 1.506E+00, 1.471E+00, 1.434E+00,...
          1.389E+00, 1.342E+00, 1.290E+00, 1.230E+00, 1.161E+00,...
          1.084E+00, 1.014E+00, 9.561E-01, 9.009E-01, 8.479E-01,...
          7.961E-01, 7.449E-01, 6.941E-01, 6.434E-01, 5.883E-01,...
          5.238E-01, 4.505E-01, 3.708E-01, 3.004E-01, 2.453E-01,...
          1.980E-01, 1.590E-01, 1.500E-01, 1.500E-01, 1.500E-01,...
          1.500E-01, 1.500E-01, 1.500E-01, 1.400E-01, 1.300E-01,...
          1.200E-01, 1.100E-01, 9.500E-02, 6.000E-02, 3.000E-02]';

CH4PPMV(:,6) = [1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00, 1.700E+00,...
          1.700E+00, 1.700E+00, 1.699E+00, 1.697E+00, 1.693E+00,...
          1.685E+00, 1.675E+00, 1.662E+00, 1.645E+00, 1.626E+00,...
          1.605E+00, 1.582E+00, 1.553E+00, 1.521E+00, 1.480E+00,...
          1.424E+00, 1.355E+00, 1.272E+00, 1.191E+00, 1.118E+00,...
          1.055E+00, 9.870E-01, 9.136E-01, 8.300E-01, 7.460E-01,...
          6.618E-01, 5.638E-01, 4.614E-01, 3.631E-01, 2.773E-01,...
          2.100E-01, 1.650E-01, 1.500E-01, 1.500E-01, 1.500E-01,...
          1.500E-01, 1.500E-01, 1.500E-01, 1.400E-01, 1.300E-01,...
          1.200E-01, 1.100E-01, 9.500E-02, 6.000E-02, 3.000E-02]';  

%% run through all possible modles for the time and flight span 
for idx_model_atm=1:6;
    ok=find(model_atm==idx_model_atm);
    
    %read atmosphere defaults from the
    %added by Samuel LeBlanc, July 12, 2022
    if idx_model_atm==1
        filename = 'tropical_model_atmo.asc';
    elseif idx_model_atm==2
%         filename = 'midlatwinter_model_atmo.asc';
        filename = 'midlatsummer_model_atmo.asc';
    elseif idx_model_atm==3
%         filename = 'midlatsummer_model_atmo.asc';
        filename = 'midlatwinter_model_atmo.asc';
    elseif idx_model_atm==4
        filename = 'subarcsummer_model_atmo.asc';
    elseif idx_model_atm==5
        filename = 'subarcwinter_model_atmo.asc';
    elseif idx_model_atm==6
        filename = '1976USstandard_model_atmo.asc';
    end
    
    % load the altitude and density from file
    fid=fopen(which(filename),'r');
    fgetl(fid);
    data=fscanf(fid,'%f',[4 inf]);
    Altitude=data(1,:)*1000; % convert km to meters
    Dens=data(4,:);          % density in molecule/m^3
    clear data
    fclose(fid);
    
    % multiply and integrate to get the column amount
    %CO2
    cumd=fliplr(cumtrapz(fliplr(Altitude),fliplr(Dens.*CO2PPMV(:,idx_model_atm)'*-1e-06))); %convert ppm to fraction, returns co2 molec/m^2 at each level
    CO2_VC=interp1(Altitude,cumd,alt);
    CO2_VC(find(alt<min(Altitude)))=cumd(1);
    if scale_co2, CO2_VC=CO2_VC.*scaler_co2; end
    CO2_percm2 = CO2_VC/(100)^2; %convert to per cm2

    %CH4
    cumd4=fliplr(cumtrapz(fliplr(Altitude),fliplr(-1*Dens.*CO2PPMV(:,idx_model_atm)'*1e-06)));
    CH4_VC=interp1(Altitude,cumd4,alt);
    CH4_VC(find(alt<min(Altitude)))=cumd4(1);
    CH4_percm2 = CH4_VC/(100)^2; %convert to per cm2

    
    CO2_vercolall(ok)=CO2_percm2(ok); % associate the right models to the right alt/lat combinations
    CH4_vercolall(ok)=CH4_percm2(ok);
end;
CO2_vercol=CO2_vercolall;
CH4_vercol=CH4_vercolall;