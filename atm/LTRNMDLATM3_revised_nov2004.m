function LTRNMDLATM3_revised_nov2004(MODELNO)

%		Fills ATMMDL common statement arrays of altitude in
%		km, pressure in mb, temperature in deg K, and water
%		vapor in grams per cubic meter with values corresponding
%		appropriate model atmosphere, as used in LOWTRAN7.  MODELNO
%		specifies which model atmosphere.  ATMMDL arrays are defined
%		at 34 fixed altitudes, ZKMMDL, ranging from 0 to 1000 km.
		
%		MODELNO = 1	Tropical
%			  		 2	Midlatitude summer
%			  		 3	Midlatitude winter
%			  		 4	Subarctic summer
%			  		 5	Subarctic winter
%			  		 6	1976 U. S. standard

global ALT PMATM TMATM H2OPPMV CO2PPMV O3PPMV N2OPPMV CH4PPMV
global ZKMMDL PMBMDL TMKMDL H2OMDL H2OGM3MDL CO2MDL O3MDL N2OMDL CH4MDL
global H2Opercm3MDL CO2percm3MDL O3percm3MDL N2Opercm3MDL CH4percm3MDL airpercm3
global PZERO TZERO AVOGAD ALOSMT GASCON PLANK BOLTZ CLIGHT ADCON
global ALZERO AVMWT AIRMWT AMWT

%ATMCON
Atmcon
MLATMB_revised_nov2004

nalt_user=50; %34;
if nalt_user==34
	ZKMMDL = ones(1,34);
	ZKMMDL(1:26) = [0:1:25];
	ZKMMDL(27:34) = [30,35,40,45,50,60,70,85];
else
    ZKMMDL = ALT;
end
%		Ratio of water vapor molecular weight to air molecular weight
	RATMOLWT = AMWT(1)/AIRMWT;

%		Fill ***MDL arrays.	Assumes that ALT and ZKMMDL arrays start at same
%     value and that there exists an ALT value exactly equal to each ZKMMDL.
nmodelatm=length(MODELNO);
for km=1:length(MODELNO);
 k=MODELNO(km); 
 for j=1:nalt_user,
   for i = 1:50,
      if ALT(i)==ZKMMDL(j)
         PMBMDL(j) = PMATM(i,k);
         TMKMDL(j) = TMATM(i,k);
         H2OMDL(j) = H2OPPMV(i,k);
         CO2MDL(j) = CO2PPMV(i,k);
         O3MDL(j)  = O3PPMV(i,k);
         N2OMDL(j) = N2OPPMV(i,k);
         CH4MDL(j) = CH4PPMV(i,k);
         
          %Convert [ppmv] of water vapor to [g/m**3]
	     RHOAIRGM3 = 1.E+09*PMBMDL(j)*AIRMWT/(TMKMDL(j)*GASCON);
         H2OGM3MDL(j,km) = H2OMDL(j)*1e-06.*RHOAIRGM3*RATMOLWT;
         
         airpercm3(j,km)=1e+3*PMBMDL(j)./(BOLTZ*TMKMDL(j));
          %Convert [ppmv] to number density [no/cm**3]
         H2Opercm3MDL(j,km) = H2OMDL(j)*1e-06.*airpercm3(j,km);
         CO2percm3MDL(j,km) = CO2MDL(j)*1e-06.*airpercm3(j,km);
         O3percm3MDL(j,km) = O3MDL(j)*1e-06.*airpercm3(j,km);
         N2Opercm3MDL(j,km) = N2OMDL(j)*1e-06.*airpercm3(j,km);
         CH4percm3MDL(j,km) = CH4MDL(j)*1e-06.*airpercm3(j,km);
         
         break
      end
   end
 end
end

return