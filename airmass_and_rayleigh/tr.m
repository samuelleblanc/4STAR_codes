function transmittance=tr(m,tau)

% computes transmittance from airmass (m) and optical depth (tau).
% Yohei, 2012/05/29

[ppm,qqm]=size(m);
[pptau,qqtau]=size(tau);
if qqm==1 && pptau>1;
    transmittance=exp(-repmat(m,1,qqtau).*tau);
elseif qqm==1 && pptau==1;
    transmittance=exp(-m*tau);
elseif ppm==pptau && qqm==qqtau;
    transmittance=exp(-m.*tau);
else
    error('Inconsistent m and tau format.');
end;
