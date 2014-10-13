function [visc,nirc,viscrange,nircrange]=starchannelsatAATS(t)

% returns the 4STAR visible channels that correspond to AATS-14 wavelengths.
% Yohei, 2012/03/04.

if nargin==1;
    [visw,nirw]=starwavelengths(t); 
    [lambda,fwhm]=aatslambda(t);
else
    [visw,nirw]=starwavelengths; 
    [lambda,fwhm]=aatslambda;
end;
visc=round(interp1(visw,1:length(visw),lambda));
nirc=round(interp1(nirw,1:length(nirw),lambda));

viscrange(1,:)=ceil(interp1(visw, 1:length(visw), lambda-fwhm/2));
viscrange(2,:)=floor(interp1(visw, 1:length(visw), lambda+fwhm/2));
viscrange(2,find(isfinite(viscrange(2,:))==0&isfinite(viscrange(1,:))==1))=length(visw);

nircrange(1,:)=ceil(interp1(nirw, 1:length(nirw), lambda-fwhm/2));
nircrange(2,:)=floor(interp1(nirw, 1:length(nirw), lambda+fwhm/2));
nircrange(2,find(isfinite(nircrange(2,:))==0&isfinite(nircrange(1,:))==1))=length(nirw);

% fine-tuning
if visc(11)>1040; 
    visc(11)=1040;
    viscrange(2,11)=1040;
end;