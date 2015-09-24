function [visc,nirc,viscrange,nircrange]=starchannelsatSEAC4RSArchive(t)

% returns the 4STAR visible channels that correspond to the SEAC4RS archive wavelengths.
% Yohei, 2013/07/25, after starchannelsatTCAPArchive.m.
% Yohei, 2015/09/16. Updated for the R2 processing.

if nargin==1;
    [visw,nirw]=starwavelengths(t); 
else
    [visw,nirw]=starwavelengths; 
end;
if now>=datenum([2015 9 15 0 0 0]); % for R2 archive
    lambda=[0.3800    0.4518    0.5008    0.5200    0.5320    0.55  0.6055 0.6197  0.6753  0.7806    0.8645  1.0199    1.0396 1.0642    1.2358    1.5587 1.6266];
elseif now>=datenum([2014 4 1 0 0 0]); % for R0 archive
    lambda=[0.3800    0.4518 0.5008    0.5200    0.5320    0.55  0.6055    0.6753  0.7806    0.8645  1.0199    1.0642    1.2358    1.5587];
else
    lambda=[0.355 0.3800    0.4518    0.5008    0.5200    0.5320    0.55  0.6055    0.6753  0.7806    0.8645  1.0199    1.0642    1.2358    1.5587];
end;
fwhm=zeros(size(lambda)); 
visc=round(interp1(visw,1:length(visw),lambda));
nirc=round(interp1(nirw,1:length(nirw),lambda));

% The lines below are not currently meaningful; kept here for format consistency with starchannelsatAATS.m and for possible future use 
viscrange(1,:)=ceil(interp1(visw, 1:length(visw), lambda-fwhm/2));
viscrange(2,:)=floor(interp1(visw, 1:length(visw), lambda+fwhm/2));
viscrange(2,find(isfinite(viscrange(2,:))==0&isfinite(viscrange(1,:))==1))=length(visw);

nircrange(1,:)=ceil(interp1(nirw, 1:length(nirw), lambda-fwhm/2));
nircrange(2,:)=floor(interp1(nirw, 1:length(nirw), lambda+fwhm/2));
nircrange(2,find(isfinite(nircrange(2,:))==0&isfinite(nircrange(1,:))==1))=length(nirw);
