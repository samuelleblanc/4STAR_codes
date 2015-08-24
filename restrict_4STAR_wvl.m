%restrict_4STAR_wvl.m
[visc,nirc,viscrange,nircrange]=starchannelsatAATS(s.t(1));

%UTdechr=timeMatlab_to_UTdechr(s.t);

idxw=[visc(1:10) nirc(11:13)+1044];
idxwvlvisp=[0 0 1 1 1 1 1 1 1 0 1 1 1];
%s.w(idxw)
% 0.3535  0.3800  0.4520  0.5005  0.5204  0.6052  0.6751  0.7805  0.8645  0.9410  1.0191  1.2356  1.5585  2.1391

%                  raw: [22666x1556 double]
%                    w: [1x1556 double]
%                   c0: [1x1556 double]
%                c0err: [1x1556 double]
%                 fwhm: [1x1556 double]
%      rate_noFORJcorr: [22666x1556 double]
%                 dark: [22666x1556 double]
%              darkstd: [22666x1556 double]
%                 rate: [22666x1556 double]
%              forjunc: [22666x1556 double]
%                 flag: [22666x1556 logical]
%                    tau_ray: [22666x1556 double]
%                     tau_O3: [22666x1556 double]
%                    tau_NO2: [1x1556 double]
%                     tau_O4: [22666x1556 double]
%            tau_CO2_CH4_N2O: [1x1556 double]
%     tau_CO2_CH4_N2O_abserr: [1x1556 double]

% resize variables at AATS wvls
s.raw=s.raw(:,idxw);
s.w=s.w(:,idxw);
s.c0=s.c0(idxw);
s.c0err=s.c0err(idxw);
s.fwhm=s.fwhm(idxw);
s.rate_noFORJcorr=s.rate_noFORJcorr(:,idxw);
s.dark=s.dark(:,idxw);
s.darkstd=s.darkstd(:,idxw);
s.rate=s.rate(:,idxw);
s.flag=s.flag(:,idxw);
s.tau_ray=s.tau_ray(:,idxw);
s.tau_O3=s.tau_O3(:,idxw);
s.tau_NO2=s.tau_NO2(:,idxw);
s.tau_O4=s.tau_O4(:,idxw);
s.tau_CO2_CH4_N2O=s.tau_CO2_CH4_N2O(:,idxw);
s.tau_CO2_CH4_N2O_abserr=s.tau_CO2_CH4_N2O_abserr(:,idxw);
s.forjunc=s.forjunc(:,idxw);
qq=length(s.w);

% s = 
%                    t: [22666x1 double]
%                  raw: [22666x1556 double]
%                  Str: [22666x1 double]
%                   Md: [22666x1 double]
%                  Lat: [22666x1 double]
%                  Lon: [22666x1 double]
%                  Alt: [22666x1 double]
%               Headng: [22666x1 double]
%                pitch: [22666x1 double]
%                 roll: [22666x1 double]
%                  Tst: [22666x1 double]
%                  Pst: [22666x1 double]
%                   RH: [22666x1 double]
%               AZstep: [22666x1 double]
%               Elstep: [22666x1 double]
%               AZ_deg: [22666x1 double]
%               El_deg: [22666x1 double]
%                QdVlr: [22666x1 double]
%                QdVtb: [22666x1 double]
%               QdVtot: [22666x1 double]
%               AZcorr: [22666x1 double]
%               ELcorr: [22666x1 double]
%                 Tbox: [22666x1 double]
%              Tprecon: [22666x1 double]
%             RHprecon: [22666x1 double]
%             filename: {18x1 cell}
%                 note: [1x817 char]
%                   ng: []
%                  O3h: 21
%                O3col: 0.3000
%               NO2col: 5.0000e+15
%         sd_aero_crit: 0.0100
%                    w: [1x1556 double]
%                   c0: [1x1556 double]
%                c0err: [1x1556 double]
%                 fwhm: [1x1556 double]
%          aerosolcols: [1x514 double]
%      rate_noFORJcorr: [22666x1556 double]
%                 dark: [22666x1556 double]
%              darkstd: [22666x1556 double]
%              viscols: [1x1044 double]
%              nircols: [1x512 double]
%                 vist: [22666x1 double]
%                 nirt: [22666x1 double]
%                visZn: [22666x1 double]
%                nirZn: [22666x1 double]
%          visVdettemp: [22666x1 double]
%          nirVdettemp: [22666x1 double]
%              visTint: [22666x1 double]
%              nirTint: [22666x1 double]
%               visAVG: [22666x1 double]
%               nirAVG: [22666x1 double]
%            visheader: {9x9 cell}
%            nirheader: {9x9 cell}
%        visrow_labels: {9x1 cell}
%        nirrow_labels: {9x1 cell}
%             visfilen: [22666x1 double]
%             nirfilen: [22666x1 double]
%                sunaz: [22666x1 double]
%                sunel: [22666x1 double]
%                  sza: [22666x1 double]
%                    f: [22666x1 double]
%                m_ray: [22666x1 double]
%               m_aero: [22666x1 double]
%                m_H2O: [22666x1 double]
%     RHprecon_percent: [22666x1 double]
%            Tprecon_C: [22666x1 double]
%               Tbox_C: [22666x1 double]
%        visVdettemp_C: [22666x1 double]
%        nirVdettemp_C: [22666x1 double]
%                 rate: [22666x1556 double]
%              forjunc: [22666x1556 double]
%               rawstd: [22666x2 double]
%              rawmean: [22666x2 double]
%            rawrelstd: [22666x2 double]
%     flagallcolsitems: {7x1 cell}
%          flagallcols: [22666x1x7 logical]
%            flagitems: {'<=1 signal-to-noise ratio or non-positive c0'}
%                 flag: [22666x1556 logical]
%                    tau_ray: [22666x1556 double]
%                  tau_r_err: 0.0150
%                     tau_O3: [22666x1556 double]
%                    tau_NO2: [1x1556 double]
%                     tau_O4: [22666x1556 double]
%            tau_CO2_CH4_N2O: [1x1556 double]
%                 tau_O3_err: 0.0500
%                tau_NO2_err: 0.2700
%                 tau_O4_err: 0.1200
%     tau_CO2_CH4_N2O_abserr: [1x1556 double]
% 

%%%%%%%%%%%%%%  Other Variables
%   Anir                       1x1                        8  double               
%   B                          1x1                        8  double               
%   Bnir                       1x1                        8  double               
%   Cnir                       1x1                        8  double               
%   R1                     22666x1                   181328  double               
%   R2                         1x1                        8  double               
%   Rnir                   22666x1                   181328  double               
%   T2                         1x1                        8  double               
%   ans                        1x16                      16  logical              
%   boolean                    1x1                        8  double               
%   cc                         1x2                       16  double               
%   datatype                   1x3                        6  char                 
%   datatype2                  1x7                       14  char                 
%   dayspast                   1x1                        8  double               
%   daystr                     1x8                       16  char                 
%   daystr2                    1x8                       16  char                 
%   denom_nir              22666x1                   181328  double               
%   ff                         1x1                        8  double               
%   filen                      0x0                        0  double               
%   filen2                     0x0                        0  double               
%   flight                     1x2                       16  double               
%   fn                         8x1                      974  cell                 
%   fnc                        1x8                      978  cell                 
%   forjnote                   1x84                     168  char                 
%   forjunc                22666x1556             282146368  double               
%   i                          0x0                        0  double               
%   ig3                    22664x1                   181312  double               
%   infofile                   1x43                      86  char                 
%   m_aero_max                 1x1                        8  double               
%   maxdayspast                1x1                        8  double               
%   nflagallcolsitems          1x1                        8  double               
%   nflagitems                 1x1                        8  double               
%   ngap                       1x1                        8  double               
%   niraerosolcols             1x120                    960  double               
%   nirc0                      1x512                   4096  double               
%   nirc0err                   1x512                   4096  double               
%   nirfwhm                    1x512                   4096  double               
%   nirnote                    1x89                     178  char                 
%   nirnotec0                  1x99                     198  char                 
%   nirw                       1x512                   4096  double               
%   note                       1x71                     142  char                 
%   note2                      1x71                     142  char                 
%   pp                         1x1                        8  double               
%   qq                         1x1                        8  double               
%   rows                       3x1                       24  double               
%   s                          1x1               1738414682  struct               
%   savefigure                 1x1                        1  logical              
%   ti                         1x1                        8  double               
%   visaerosolcols             1x394                   3152  double               
%   visc0                      1x1044                  8352  double               
%   visc0err                   1x1044                  8352  double               
%   visfwhm                    1x1044                  8352  double               
%   visnote                    1x69                     138  char                 
%   visnotec0                  1x99                     198  char                 
%   visw                       1x1044                  8352  double