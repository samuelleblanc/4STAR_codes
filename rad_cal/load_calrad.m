function [cals pname date corstr]=load_calrad();

%% function to load Radiance calibration file from the multi lamp
% calibration sphere
% Loads cal file and then formats the variables to match the
% sasze_radcals_nonlinear analysis routine made by Connor Flynn.
%

%file='rad_cal.mat'
%pname='C:\Users\sleblan2\Research\4STAR\cal\20131120\2013_11_20.4STAR.NASA_Ames.Flynn\'
%date='20131120'

%infile = getfullname_('*rad_cal.mat','radcals','Select "All Lamp" radcals file.');
[file pname]=uigetfile('*rad_cal*.mat','Select radcals from 4STAR with all lamsp');

sfile={file};
date=sfile{1}(1:8);
pname1=pname;
disp(['Loading the matlab file: ' pname file])
disp(['for Date: ' date])
load([pname file]);

fields = fieldnames(cal);
for f = length(fields):-1:1;
    if ~isempty(strfind(fields{f},'Lamps_'))
        Lamps(f) = sscanf(fields{f}(strfind(fields{f},'Lamps_')+length('Lamps_'):end),'%f');
    end
end
Lamps = unique(Lamps); 
for LL = Lamps
    lamp_str =['Lamps_',num2str(LL)];
    for spc = {'vis','nir'}
        spc = char(spc);
        if spc=='vis' 
            dnmax=repmat(2^16,1,1044);
            cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).lambda=vis.nm;
        else
            dnmax=repmat(2^15,1,512);
            cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).lambda=nir.nm;
        end
        cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).t_int_ms = cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).t_ms ;
        for t = length(cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).t_int_ms):-1:1
            ms_str = strrep(sprintf('%g',cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).t_int_ms(t)),'.','p');
            cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).(['welldepth_',ms_str,'_ms'])=...
                (cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).light(t,:)-cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).dark(t,:))./...
                (dnmax-cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).dark(t,:));
            cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).(['resp_',ms_str,'_ms'])=cal.(['Lamps_',sprintf('%g',LL)]).(char(spc)).resp(t,:);
        end
    end
end

pname=pname1;
cals=cal;

if exist('docorrection')
  if docorrection
    disp('Using nonlinearity corrected data')
    corstr='_corr';
  else
    corstr='';
  end
else
    corstr='';
end
%stophere
return