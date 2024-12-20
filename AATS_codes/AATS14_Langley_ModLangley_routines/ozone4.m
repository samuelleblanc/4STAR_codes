function [tau_aero,tau_NO2,tau_O3,O3_col,p]=ozone4(site,day,month,year,lambda,O3_xsect,NO2_xsect,NO2_clima,UT,GPS_Alt,m_aero,...
          m_ray,m_NO2,m_O3,m_H2O,wvl_chapp,wvl_aero,tau,tau_r,tau_O4,tau_H2O,O3_col_start,order);
% Estimates ozone column and computes aerosol optical depth for all wavelengths incl. H2O-absorption channels. % 
% Michalsky J. J., J. C. Liljegren, and L. C. Harrison, 1995: A comparison of Sun photometer derivations of total column
% water vapor and ozone to standard measures of same at the Southern Great Plains Atmospheric Radiation Measurement site.
% Journal of Geophysical Research. Vol. 100, No. D12, 25'995-26'003.
% Written 18. 7.95 by B. Schmid % Changes 21. 7.95 by B. Schmid: Bugs fixed in plotting final fit, dO3 gives increment in O3 Col% Changes 24. 7.95 by B. Schmid: New Formula for Rayleigh-Scattering (preliminary)% Changes 25. 7.95 by B. Schmid: New Ozone Absorption Cross-Sections (preliminary)% Changes 26. 7.95 by B. Schmid: NO2 Absorption Cross-Sections included (preliminary)% Changes 27. 7.95 by B. Schmid: Interpolates tau_aero for H2O-absorption channels.% Changes 19.12.95 by B. Schmid: Allows to select order of polynomial fit and returns coefficients of polynom% Changes 20. 3.96 by B. Schmid: New Ozone Absorption Cross-Sections (from MODTRAN3 )% Changes 20. 3.96 by B. Schmid: New NO2 Absorption Cross-Sections included (from MODTRAN3) % Changes 11. 4.96 by B. Schmid: Uses individual airmasses% Changes 13. 5.96 by B. Schmid: Allows input of NO2 column, all cross sections are computed externally
% Changes 10. 7.97 by B. Schmid: Plots fit at all SPM wavelengths% Changes 23.10.98 by B. Schmid: corrects for O2-O2 absorption% Changes  8. 2.99 by B. Schmid: corrects for H2O absorption
dO3=0.001; %Resolution of retrievaltau_NO2=NO2_clima*NO2_xsect;tau_O3=O3_col_start*O3_xsect;              tau2=tau-tau_r*(m_ray/m_aero);tau3=tau2-tau_NO2*(m_NO2/m_aero);tau4=tau3-tau_O4*(m_ray/m_aero);
tau5=tau4-tau_H2O*(m_ray/m_H2O);
tau_aero=tau5-tau_O3*(m_O3/m_aero);
jbad=find(tau>=99.9999);

jwluse=(tau<99.9999)'.*wvl_chapp;
jwluse=find(jwluse==1);
x=log(lambda(jwluse));y=log(tau_aero(jwluse));
[p,S] = polyfit(x,y,order);[y_fit,delta] = polyval(p,x,S);a=sum(abs(delta));
% start iteration
for iter=1:300
 O3_col=O3_col_start+dO3*iter; tau_O3=O3_col*O3_xsect; tau_aero=tau5-tau_O3*(m_O3/m_aero); y=log(tau_aero(jwluse)); [p,S] = polyfit(x,y,order) ; [y_fit,delta] = polyval(p,x,S); normresid(iter)=S.normr;
 errsave(iter)=sum(abs(delta));
 O3save(iter)=O3_col;
 if sum(abs(delta)) > a  break; end; a=sum(abs(delta));end
O3_col=O3_col-dO3;

%figure(82)
%plot(O3save,errsave,'.',O3save,normresid,'.')
%legend('sum of err est','norm of residuals')
%ylabel('error estimate')
%xlabel('Columnar Ozone (DU)')

%if(UT>=22.485&UT<=22.54) O3_col=0.260; end  %for 12/17 only
tau_O3=O3_col*O3_xsect;tau_aero=tau5-tau_O3*(m_O3/m_aero);
% interpolate tau_aero for non-windows channelsy=log(tau_aero(jwluse));[p,S] = polyfit(x,y,order); [y_fit,delta] = polyval(p,log(lambda),S);tau_aero(wvl_aero==0)=exp(y_fit(wvl_aero==0));
if ~isempty(jbad)
    %now reset tau and tau_aero previously set=999999 
    tau(jbad)=99.9999;
    tau_aero(jbad)=99.9999;
end

flag_nicegraph='no';
figure(2)

if strcmp(flag_nicegraph,'yes') 

 loglog(lambda(wvl_aero==1),tau(wvl_aero==1) ,'ro','MarkerFaceColor','r','MarkerSize',10)
 hold on
 loglog(lambda(wvl_aero==1),tau2(wvl_aero==1),'co','MarkerFaceColor','c','MarkerSize',8)
 loglog(lambda(wvl_aero==1),tau3(wvl_aero==1),'go','MarkerSize',8)
 loglog(lambda(wvl_aero==1),tau4(wvl_aero==1),'go','MarkerSize',8)
 loglog(lambda(wvl_aero==1),tau5(wvl_aero==1),'mo','MarkerFaceColor','m','MarkerSize',8)
 loglog(lambda(wvl_aero==1),tau_aero(wvl_aero==1),'bd','MarkerFaceColor','b','MarkerSize',10)
 loglog(lambda(wvl_aero==1),tau_O3(wvl_aero==1),'ko','MarkerFaceColor','k','MarkerSize',10)
 loglog(lambda,exp(y_fit),'b:','LineWidth',2)
 set(gca,'ylim',[0.0005 0.5]);

 set(gca,'xlim',[.300 1.6]); %2.20
 set(gca,'xtick',[0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.2,1.4,1.6]); %,1.8,2,2.2]);
 set(gca,'TickLength',[0.02 0.05],'LineWidth',1.5);
 h1=text(0.8,0.3,'Total')
 set(h1,'FontSize',14,'Color','r')
 h2=text(0.8,0.2,'Total minus Rayleigh')
 set(h2,'FontSize',14,'Color','c')
 h3=text(0.8,0.1,'Total minus all gases except ozone')
 set(h3,'FontSize',14,'Color','m')
 h4=text(0.8,0.05,'Aerosol')
 set(h4,'FontSize',14,'Color','b')
 h5=text(0.8,0.35,'Ozone')
 set(h5,'FontSize',14,'Color','k')

 %load modtran_tauozone_data
 %load modtranozonedata  %for 1/21/03 14.5 fit
else
 hold off
 loglog(lambda(wvl_aero==1),tau(wvl_aero==1) ,'r+',...
        lambda(wvl_aero==1),tau2(wvl_aero==1),'co',...
        lambda(wvl_aero==1),tau3(wvl_aero==1),'go',...
        lambda(wvl_aero==1),tau4(wvl_aero==1),'go',...
        lambda(wvl_aero==1),tau5(wvl_aero==1),'mo',...
        lambda(wvl_aero==1),tau_aero(wvl_aero==1),'bd',...
        lambda,exp(y_fit),'b');    
end

 set(gca,'xlim',[.300 2.2],'ylim',[.0001 1]);
 set(gca,'xtick',[0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0,1.2,1.4,1.6 1.8,2,2.2]);
 xlabel('Wavelength [microns]','FontSize',14); ylabel('Optical Depth','FontSize',14)
 set(gca,'FontSize',14) ht=title(sprintf('maer: %6.3f  zGPS:%6.3f  UT:%6.3f  DU:%4.0f',m_aero,GPS_Alt,UT,1000*O3_col));
 set(ht,'FontSize',14)

 pause(0.00001)