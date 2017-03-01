% calculate uncertainty in gamma and derived f(RH)
% gamma = -log10(f)./B;
% where f=sigma2/sigma1, B=log10((1-rh2/100)./(1-rh1/100));
% This code was developed from estimate_gamma_uncertainty.m, and is called
% by AScalculateAATSHiGEARAOD.m. 
% Yohei, 2009/11/29

%*****************
% set parameters
%*****************
ii=1e4; % number of Monte Carlo samples
erh2=0.035; % relative error in the RH reading of RR neph #2 
erh1=0.035; % relative error in the RH reading of RR neph #1
esigma2=0.05; % relative error in the scattering mesaurement of RR neph #2
esigma1=0.05; % relative error in the scattering mesaurement of RR neph #1
erha=0.035; % relative error in the ambient RH reading 
erht=0.035; % relative error in the TSI neph RH reading 

% erh2=0; % relative error in the RH reading of RR neph #2 
% erh1=0; % relative error in the RH reading of RR neph #1
% esigma2=0; % relative error in the scattering mesaurement of RR neph #2
% esigma1=0; % relative error in the scattering mesaurement of RR neph #1
% erha=0; % relative error in the ambient RH reading 
% erht=0; % relative error in the TSI neph RH reading 

% run ASAeronetcomparison.m first
if exist('higear') && isfield(higear, 'effrhlo');
    rha=higear.effambrh;
    rht=higear.efftsirh;
    rh2=higear.effrhhi; % RH (%) reading of the RR neph #2
    rh1=higear.effrhlo; % RH (%) reading of the RR neph #1
    frh0=higear.rrneph4./higear.rrneph3; % measured f(RH) at RH2/RH1.
    %     frh0=higear.layeraod./higear.layerdryaod;
elseif  exist('insitu') && isfield(insitu, 'effrhlo');
    rha=insitu.effambrh;
    rht=insitu.efftsirh;
    rh2=insitu.effrhhi; % RH (%) reading of the RR neph #2
    rh1=insitu.effrhlo; % RH (%) reading of the RR neph #1
    frh0=insitu.wetneph./insitu.dryneph; % measured f(RH) at RH2/RH1.
else
    error('Input?');
end;

%*****************
% calculate the measured values of relevant parameters
%*****************
B0=log10((1-rh2/100)./(1-rh1/100)); % measured B
gamma=-log10(frh0)./B0; % measured gamma
% gamma=-log10(frh0(:,2))./B0; % measured gamma
Ba=log10((1-rha/100)./(1-rht/100)); % measured B for ambient samples
fa=10.^(-Ba.*gamma); % measured sigma ambient /sigma TSI neph

%*****************
% simulate true values of gamma
%*****************
rh2b=rh2*(1+randn(ii,1)*erh2)'; % true RH2
maxrh2b=99.999;
rh2b(find(rh2b>maxrh2b))=maxrh2b;
rh1b=rh1*(1+randn(ii,1)*erh1)'; % true RH1
Bb=log10((1-rh2b/100)./(1-rh1b/100)); % true B 
clear rh2b rh1b;
fb=frh0*((1+randn(ii,1)*esigma2)./(1+randn(ii,1)*esigma1))'; % true f
% fb=frh0(:,2)*((1+randn(ii,1)*esigma2)./(1+randn(ii,1)*esigma1))'; % true f
gammab=-log10(fb)./Bb; % true gamma
clear fb Bb;

%*****************
% simulate true f(RH)
%*****************
rhab=rha*(1+randn(ii,1)*erha)'; % true ambient RH
maxrhab=99.999;
rhab(find(rhab>maxrhab))=maxrhab;
rhtb=rht*(1+randn(ii,1)*erht)'; % true TSI neph RH
Bab=log10((1-rhab/100)./(1-rhtb/100)); % true B
clear rhab rhtb;
fab=10.^(-Bab.*gammab); % true sigma ambient /sigma TSI neph
clear Bab;

%*****************
% return the estimated uncertainty
%*****************
fab2=fab;
fab2(find(imag(fab2)~=0))=NaN;
higear.amb_unc=(nanstd(fab2')./nanmedian(fab2'))';
for ia=1:size(fab2,1)
    iaok=find(isfinite(fab2(ia,:))==1);
    if length(iaok)>0
    higear.amb_unclo(ia)=1-prctile(fab2(ia,iaok),15.8655)/fa(ia);
    higear.amb_unchi(ia)=prctile(fab2(ia,iaok),100-15.8655)/fa(ia)-1;
    else
        higear.amb_unclo(ia)=NaN;
        higear.amb_unchi(ia)=NaN;
    end;
end;
if  exist('insitu') && isfield(insitu, 'effrhlo');
    insitu.amb_unc=higear.amb_unc;
    insitu.amb_unclo=higear.amb_unclo;
    insitu.amb_unchi=higear.amb_unchi;
    clear higear;
end;

% [medi, variab]=binfcn('nanmean', fa, fab, 1:0.1:2.7, 1);
