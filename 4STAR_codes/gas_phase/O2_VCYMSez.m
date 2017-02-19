function [O2_vercol,O4_vercol]=O2_VCYMSez(alt,dec_or_t,lat)

%computes O2 vertical column according to height 
% O2_vercol is given in molec/cm2
% enter alt (the base altitude of calculation) in meters
% for example: Ames rooftop = 10 meters
% also enter declination or time, the latter in the Matlab style. And
% latitude.
% Michal, April 2013 (O2_VCYMS.m)
% updated by Yohei, 2013/06/04, to accept 4STAR data (t and lat)

if ~isequal(size(alt),size(dec_or_t)) || ~isequal(size(alt),size(lat))
    error('alt, dec_or_t and lat must be the same size.');
end;
model_atm=modelatm(dec_or_t,lat);
O2_vercolall=NaN(size(alt));
O4_vercolall=NaN(size(alt));

for idx_model_atm=1:6;
    ok=find(model_atm==idx_model_atm);
    
    %read input atmosphere
    %added by Michal Segal, April 29, 2013
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
    
    %filename='Tropical.asc';
    fid=fopen(which(filename),'r');
    fgetl(fid);
    data=fscanf(fid,'%f',[4 inf]);
    Altitude=data(1,:)*1000; % convert km to meters
    Dens=data(4,:);          % density in molecule/m^3
    clear data
    fclose(fid);
    cumd=fliplr(cumtrapz(fliplr(Altitude),fliplr(-1*Dens)));
    O2_VC=interp1(Altitude,cumd,alt);
    O2_VC(find(alt<min(Altitude)))=cumd(1);
    O2_VC=0.21*O2_VC;
    O2_vercol=O2_VC/(100)^2;
    cumd4=fliplr(cumtrapz(fliplr(Altitude),fliplr(-1*Dens.^2)));
    O4_VC=interp1(Altitude,cumd4,double(alt));
    O4_VC(find(alt<min(Altitude)))=cumd4(1);
    O4_VC=0.21^2*O4_VC;
    O4_vercol=O4_VC/(100)^5;
    
    O2_vercolall(ok)=O2_vercol(ok);
    O4_vercolall(ok)=O4_vercol(ok);
end;
O2_vercol=O2_vercolall;
O4_vercol=O4_vercolall;