function ae=sca2angstrom(sca, wl)

% Yohei, 2005-11-13
% Return Angstrom exponent. See also scaang2sca.m.

lwl=size(wl,2);
if lwl<2
    error('The number of wavelengths must be 2 or greater.');
elseif size(sca,2)~=lwl
    error('Scattering coefficient and wavelength must have the same number of columns.');
end;
method=1;
% sca(find(sca<0))=NaN;
if lwl==2;
    ae=-log10(sca(:,1)./sca(:,2))./log10(wl(1)./wl(2));
elseif lwl>2;
    if method==1; % take log-linear regression
        ok=find(sum(isfinite(sca),2)>=2);
        ae=repmat(NaN,size(sca,1),1);
        for i=1:length(ok);
            b=regress(log(sca(ok(i),:))',[log(wl)' ones(lwl,1)], 0.05);
            ae(ok(i))=-b(1);
        end;
    elseif method==2; % take all 3 combinations of the 3 wavelengths
        for i=1:3;
            i1=rem(i,3)+1;
            i2=rem((i+1),3)+1;
            ae(:,i)=-log10(sca(:,i1)./sca(:,i2))./log10(wl(i1)./wl(i2));
        end;
    end;
end;