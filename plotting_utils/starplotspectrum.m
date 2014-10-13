function h=starplotspectrum(w, y, aerosolcols, viscols, nircols)

% plots a 4STAR spectrum
% Yohei, 2012/10/16

h=NaN(3,1);
if ~isempty(viscols);
    h2=loglog(w(viscols), y(:,viscols), '.-', 'color',[0.5 0.5 0.75]);
    h(2)=h2(1);
    hold on;
end;
if ~isempty(nircols);
    h3=loglog(w(nircols), y(:,nircols), '.-', 'color',[1 0.5 0.25]);
    h(3)=h3(1);
    hold on;
end;
if ~isempty(aerosolcols);
    h1=loglog(w(aerosolcols), y(:,aerosolcols), '.', 'color',[0 0 0]);
    h(1)=h1(1);
end;
if any(isfinite(h))
    hold off;
    gglwa
    grid on;
end;
