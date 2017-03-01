function [od,cumsca]=vertsca2od(alt, sca, plotplot)

% Yohei, 2005-08-12
% Estimate optical depth from scattering coefficient

okr=find(isfinite(alt)==1 & isfinite(sca)==1 & alt>=0); 
nng=length(alt)-length(okr);
[alt,i]=sort(alt(okr));
if isempty(okr)
    od=NaN;
    cumsca=[NaN NaN];
    warning('No plot made.  AOD = NaN.');
else
    alt=alt(:);
    sca=sca(okr(i));
    sca=sca(:);
    lowaltrr=find(alt<=alt(1)*2);
%     lowaltsca=nanmedian(sca(lowaltrr));
    lowaltsca=nanmean(sca(lowaltrr));
    scaleheight=8500; % scale height (m)
    pressurefactor=exp(alt(1)/scaleheight);% assuming sufficient mixing, the fractional AOD is set proportional to the atmospheric pressure. 
    lowaltod=alt(1)*lowaltsca*pressurefactor;
    highaltod=0;
    binwidth0=diff(alt)/2;
    binwidth=[0;binwidth0]+[binwidth0;0];
    od=binwidth'*sca+lowaltod+highaltod;
    if nargout>=2;
        cumsca(:,1)=[repmat(NaN, nng, 1);alt];
        cumsca(:,2)=[repmat(NaN, nng, 1);lowaltod+cumsum(binwidth.*sca)];
    end;
    if plotplot==1;
        scaperi=repmat([lowaltsca;sca;0],1,2)';
        scaperi=scaperi(:);
        altperi=[0 alt(1);[alt-[0;binwidth0] alt+[binwidth0;0]];alt(end) 0]';
        altperi=altperi(:);
        figure;
        ph=plot(sca*1e6, alt, '.k', 'markersize',10);
        xlabel('Scattering Coefficient (Mm^{-1})');
        ylabel('Altitude (m)');
        if length(scaperi)<=10000; % avoid long processing time
            hold on;
            fh=fill(scaperi*1e6, altperi, [1 .7 1]);
            set(fh, 'edgecolor','r', 'facealpha', 0.5);
            legend(fh,['Optical Depth = ' num2str(od, '%0.3f')]);
        else
            legend(ph,['Optical Depth = ' num2str(od, '%0.3f')]);
        end;
        stamp('vertsca2od.fig, vertsca2od.m');
    end;
end;