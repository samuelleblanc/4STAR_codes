% provide a standard axis format for AOD spectra plot. First used in
% ASMontereyAeronetcomparison.m.
% Yohei, 2009/11/07

yl0=ylim;
axis tight;
xl0=xlim;
if xl0(2)<10; % um
    factor=1000;
else
    factor=1;
end;
if xl0(2)*factor<=1200; % assume 4STAR VIS only
    xlim([300 1100]./factor);
    xt=[300:100:1000 2000 3000]/factor;
    xtl={'300' '400' '500' '600' '700' '800' '900' '1000' '2000' '3000'};
elseif xl0(1)*factor>=900 && xl0(2)*factor<=1800; % assume 4STAR NIR
    xlim([900 1800]./factor);
    xt=(900:100:1700)/factor;
    xtl={'' '1000' '' '1200' '' '1400' '' '' '1700'};
elseif xl0(2)*factor<=1800; % assume 4STAR VIS and NIR
    xlim([300 1800]./factor);
    xt=(300:100:1700)/factor;
    xtl={'300' '400' '500' '600' '' '800' '' '1000' '' '1200' '' '1400' '' '' '1700'};
else; % assume AATS
    xlim([300 2400]./factor);
    xt=[300:100:1000 2000 3000]/factor;
    xtl={'300' '400' '500' '600' '' '800' '' '1000' '2000' '3000'};
end;
set(gca,'xscale','log','xtick',xt, ...
    'xticklabel', xtl,'ylim',yl0, ...
    'fontsize', 16, 'linewidth', 1, 'color', 'none');
xlabel('Wavelength (nm)');