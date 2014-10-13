function [welldepth]=welldepth(raw,visc,nirc)
%% function to calculate the well depth ratio that is filled for 4STAR
%% outputs welldepth as a ratio to 1, 1 begin the max (2^16 for vis and 2^15 for nir)

maxvis=2^16;
maxnir=2^15;

nvis=1044;
nnir=512;

% build array of 1556 with maxes
maxarr=[repmat(maxvis,1,nvis) repmat(maxnir,1,nnir)];

%divide the array by the max vector
wdepth=bsxfun(@rdivide, raw,maxarr);

%now check if the wavelength needs to be set to aats wavelengths
if nargin > 1; 
    c=[visc(1:10) nirc(11:13)+1044 NaN];
    cok=find(isfinite(c)==1);
    welldepth=wdepth(:,c(cok));
else    
  welldepth=wdepth;    
end;

%end;