% save starsun file to netcdf.

function s=save2netcdf(filein,fileout)

aodonly=true

if nargin<2;
   [fin path]=uigetfile('*starsun.mat','Select input file');
   filein=[path fin];
   [path,name,ext]=fileparts(filein);
   if aodonly
       datestr=name(1:8);
       fileout=[path filesep datestr 'aod.ncf']; 
   else
       fileout=[path filesep name '.ncf'];
   end;
end
s=load(filein);


% remove some fields
wavelength=s.w;
utch=t2utch(s.t);
field={'raw','Str','Md','Zn','Tst','Pst','RH','AZstep','Elstep','AZ_deg','El_deg','QdVlr',...
       'QdVtb','QdVtot','AZcorr','ELcorr','Tbox','Tprecon','RHprecon','filename','ng',...
       'sd_aero_crit','w','skyresp','aeronetcols','skyresperr','rawcorr','rate','dark',...
       'darkstd','viscols','nircols','vist','nirt','visVdettemp','nirVdettemp','visTint',...
       'nirTint','visAVG','nirAVG','visheader','nirheader','visrow_labels','nirrow_labels',...
       'visfilen','nirfilen','vissat_pixel','nirsat_pixel','sunaz','sunel','f','m_ray','m_H2O',...
       'RHprecon_percent','Tprecon_C','Tbox_C','visVdettemp_C','nirVdettemp_C','rawstd','rawmean',...
       'rawrelstd','m_O3','m_NO2','rateaero','tau_aero_noscreening','tau_aero_polynomial',...
       'c0','c0err','aerosolcols','sat_ij','tau_NO2','t','Headng'};
s=rmfield(s,field);
s.wavelength=wavelength;
s.utch=utch;

if aodonly
   fielda={'O3h','O3col','NO2col','tau_ray','tau_r_err','tau_O3','tau_O4','tau_CO2_CH4_N2O',...
           'tau_O3_err','tau_NO2_err','tau_CO2_CH4_N2O_abserr','tau_O4_err','pitch','roll'};
   s=rmfield(s,fielda);
end

s=struct2netcdf(s,fileout);

end