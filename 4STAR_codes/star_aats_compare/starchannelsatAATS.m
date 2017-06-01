function [visc,nirc,viscrange,nircrange]=starchannelsatAATS(t,instrumentname)

% returns the 4STAR visible channels that correspond to AATS-14 wavelengths.
% Yohei, 2012/03/04.
% Sam, 2017/05/28, v2.0, added instrumentname to support mutiple instruments
version_set('v2.0')

if nargin==1;
    instrumentname = '4STAR';
    [visw,nirw]=starwavelengths(t,instrumentname); 
    [lambda,fwhm]=aatslambda(t);
else
    [visw,nirw]=starwavelengths(now,instrumentname); 
    [lambda,fwhm]=aatslambda;
end;
visc=round(interp1(visw,1:length(visw),lambda));
viscrange(1,:)=ceil(interp1(visw, 1:length(visw), lambda-fwhm/2));
viscrange(2,:)=floor(interp1(visw, 1:length(visw), lambda+fwhm/2));
viscrange(2,find(isfinite(viscrange(2,:))==0&isfinite(viscrange(1,:))==1))=length(visw);

if ~strcmp(instrumentname,'2STAR');
    nirc=round(interp1(nirw,1:length(nirw),lambda));
    nircrange(1,:)=ceil(interp1(nirw, 1:length(nirw), lambda-fwhm/2));
    nircrange(2,:)=floor(interp1(nirw, 1:length(nirw), lambda+fwhm/2));
    nircrange(2,find(isfinite(nircrange(2,:))==0&isfinite(nircrange(1,:))==1))=length(nirw);
else;
    nirc = [];
    nircrange = [];
end;

% fine-tuning
if visc(11)>1040; 
    visc(11)=1040;
    viscrange(2,11)=1040;
end;