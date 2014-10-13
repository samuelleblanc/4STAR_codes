function [c0_mod,RSD]=modLangley(am,iwln,wvis,data,tau_aero,tau_ray,tau_O4,tau_O3,tau_NO2,m_aero,m_ray,m_O3,m_NO2,m_H2O,a_H2O,b_H2O,stdev_mult)

%
% modified langley for water vapor John's/Beat 2001 program
% data is rate, tau_aero is interpolated tau_aero in water vapor region
% iwln: vector of 1's for water vapor or oxygen bands location
% tau_aero is in the length of valid water wavelengths, which
% dictates the wvl length to be processed
% iwln is array of wvl used for modified Langley
%------------------------------------------------------------
% Michal Feb 20 2013


flag_write_results='no'; %'yes'
flag_restrict_altitude='no';
flag_screen_method='mH2O';%'mH2O^b';%'mH2O'; %'mH2O^b';%

% restrict airmass range
min_m_H2O=am(1);                % to decide check min values of m_H2O
% if am(1)<3
%     min_m_H2O = 3;
% end
max_m_H2O=am(2);                % to decide check max values of m_H2O
% if am(2)>12
%     max_m_H2O = 12;
% end
% define according to b=~0.5 ("harder" constrain)
% min_x=(min_m_H2O)^0.5;      % (min_m_H2O)^0.5
% max_x=(max_m_H2O)^0.5;      % (max_m_H2O)^0.5
% stdev_mult=2;


size1=size(data,1); % should be length of measurements
size2=size(data,2); % should be length of wavelengths
m_ray = m_ray*ones(1,size2);
m_O3 = m_O3*ones(1,size2);
m_NO2 = m_NO2*ones(1,size2);
m_aero = m_aero*ones(1,size2);


%Water Vapor

channels=1:length(iwln);  
% initialize parameters
c0_mod=zeros(length(iwln),1);
U_modlang=zeros(length(iwln),1);
RSD=zeros(length(iwln),1);
%
% for ichan=channels(iwln==1);
for ichan=1:length(channels)
% make calculation for each wavelength
 x=m_H2O.^b_H2O(ichan);                  
 y=real(data.*exp(tau_aero.*m_aero+tau_ray.*m_ray+tau_NO2.*m_NO2+tau_O3.*m_O3+tau_O4.*m_ray));        
 y=real(log(y(:,ichan)));

 

 %Airmass restriction 
 min_x=min_m_H2O.^b_H2O(ichan);      % (min_m_H2O)^b(i)
 max_x=max_m_H2O.^b_H2O(ichan);      % (max_m_H2O)^b(i)
 if strcmp(flag_screen_method,'mH2O')
    i=find(m_H2O<=max_m_H2O & m_H2O>=min_m_H2O);
 elseif strcmp(flag_screen_method,'mH2O^b')
    i=find(x<=max_x & x>=min_x);
 end
 
  x=x(i);
  y=y(i);
  % eliminate NAN's
  yNan=isnan(y);
  i=find(yNan==0);
  x=x(i);
  y=y(i); 
  %y(yNan==1)=0;
  
  % data needed for airborne langley
  %---------------------------------
  
 if strcmp(flag_restrict_altitude,'yes')
  %Altitude restriction for airborne Langley (in km)
   alt_use=alt(i);  % in [meters]
   %UT_use=UT(i)
  i=find(alt_use>=6000);
  x=x(i);
  y=y(i); 
 end

  [p,S] = polyfit (x,y,1);
  [y_fit,delta] = polyval(p,x,S);
  a=y-y_fit;
%   
%    [b,stats] = robustfit(x,y');
%     y_fit=b(1)+b(2)*x;
%     a=y'-y_fit;

%     figure(100)
%     subplot(2,1,1)
%     plot(x,y','g+',x,y_fit);
% %     title(sprintf('%2i.%2i.%2i %8.3f µm',day,month,year,lambda(ichan)),'fontsize',12);
%     title(sprintf('%8.3f µm',lambda(ichan)),'fontsize',12);
%     xlabel('m_{H2O}^b','FontSize',14)
%     ylabel('ln V*','FontSize',14)
%     set(gca,'FontSize',14)
%     grid on
%     xlimval=get(gca,'xlim');
%     ylimval=get(gca,'ylim');
%     mH2Ocalc=exp(log(xlimval)/b_H2O(10));
%     htmin=text(xlimval(1),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(1)));
%     set(htmin,'fontsize',14,'color','r')
%     htmax=text(xlimval(2)-0.055*(xlimval(2)-xlimval(1)),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(2))); 
%     set(htmax,'fontsize',14,'color','r')
%     subplot(2,1,2);
%     plot(x,a,'g+');
%     grid on
%     xlabel('m_{H2O}^b','FontSize',14)
%     ylabel('Residuals','FontSize',14)
%     set(gca,'FontSize',14)
%   
%     pause(0.01)

 while max(abs(a))>stdev_mult*std(a) 
  i=find(abs(a)<max(abs(a)));
  x=x(i);
  y=y(i);
  [p,S] = polyfit (x,y,1);
  [y_fit,delta] = polyval(p,x,S);
  a=y-y_fit;
 end

 c0_mod(ichan)=exp(p(2));% data is already divided with sundist
 U_modlang(ichan)=(-p(1)/a_H2O(channels(ichan)))^(1/b_H2O(channels(ichan)))/1244;
 RSD(ichan)=std(a);

%  mH2Ocalc=exp(log(3)/b_H2O(ichan));    % parameter to use in plot
% %  
%      figure(101)
%      subplot(2,1,1)
%      plot(x,y,'.',x,y_fit);
%      title(sprintf('%8.3f µm   std:%3.1f   V0:%7.4f  RSD:%7.4f',wvis(ichan),stdev_mult,c0_mod(ichan),RSD(ichan)),'FontSize',12);
%      grid on;
%      xlabel('m_{H2O}^b','FontSize',14);
%      ylabel('ln V*','FontSize',14);
%      set(gca,'FontSize',14);
%      % axis([min_x max_x min(y) max(y)]);
%      axis([3 11 0 5]);
%      xlimval=get(gca,'xlim');
%      ylimval=get(gca,'ylim');
%     mH2Ocalc=exp(log(xlimval)/b_H2O(ichan));
%     mH2Ocalc(2)=exp(log(x(1))/b_H2O(ichan));
%     mH2Ocalc(1)=exp(log(x(end))/b_H2O(ichan));
%     htmin=text(xlimval(1),ylimval(1)+0.5*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(1)));
%     %htmin=text(xlimval(1),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(1)));
%     set(htmin,'fontsize',14,'color','r')
%     htmax=text(xlimval(2)-0.1*(xlimval(2)-xlimval(1)),ylimval(1)+0.5*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(2))); 
%     %htmax=text(xlimval(2)-0.055*(xlimval(2)-xlimval(1)),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(2))); 
%    set(htmax,'fontsize',14,'color','r')
%      subplot(2,1,2);
%      plot(x,a,'b.');
%      grid on
%      xlabel('m_{H2O}^b','FontSize',14)
%      ylabel('Residuals','FontSize',14)
%      set(gca,'FontSize',14);
%      % axis([min_x max_x min(a) max(a)]);
%      axis([3 11 -0.01 0.01]);
%      pause(0.001)
end

if strcmp(flag_write_results,'yes')
%write results from Langley-plot to file
%fid=fopen('c:\johnmatlab\AATS6_data_2001\mauna loa\modlang_AATS6.txt','a');
%fid=fopen('c:\johnmatlab\modlang_AATS14_Sept2001.txt','a');
%fid=fopen('c:\johnmatlab\modlang_AATS14_MLONov2002.txt','a');
%fid=fopen('c:\johnmatlab\modlang_AATS14_MLOMar2004.txt','a');
%fid=fopen('c:\johnmatlab\modlang_AATS14_ICARTTair.txt','a');
%fid=fopen('c:\johnmatlab\AATS14 calibration text file\modlang_AATS14_MLOAug2005.txt','a');
%fid=fopen('c:\johnmatlab\AATS14 calibration text file\modlang_AATS14_MLOJan2006.txt','a');
%fid=fopen('c:\johnmatlab\AATS14 calibration text file\modlang_AATS14_MLOMay2006.txt','a');
%fid=fopen('c:\johnmatlab\AATS14 calibration text file\modlang_AATS14_MLOMay2008.txt','a');
%fid=fopen('c:\johnmatlab\AATS14 calibration text file\modlang_AATS14_MLOAug2008.txt','a');
% fid=fopen('c:\johnmatlab\AATS14 calibration text file\modlang_AATS14_AmesJun2011.txt','a');
% fprintf(fid,'%2i.%2i.%4i', day,month,year);
% fprintf(fid,'%5.1f',min_m_H2O,max_m_H2O,stdev_mult);
% fprintf(fid,'%9.4f',V0(iwln==1),U_modlang(iwln==1),RSD(iwln==1));
% fprintf(fid,'%5.1f',max_x,min_x);
% fprintf(fid,'  %s',flag_screen_method);
% fprintf(fid,'\n');
% fclose(fid);
end

return