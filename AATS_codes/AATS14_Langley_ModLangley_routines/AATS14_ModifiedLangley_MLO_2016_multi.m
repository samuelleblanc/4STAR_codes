%modlang_Beat.m  from 2/4/2001
%performs modified Langley plots for water vapor channels.
%play with 1) time interval in prepare.m
%          2) airmass range: min_m_H2O, max_m_H2O
%          3) standard deviation multiplier for Thompson-tau method: stdev_mult
% Edited, MS, 2016-01-10, adjusted for MLO 2016
%

% calculate AOD
% daystr = '20160109';
% folder = 'C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\mat_files\';
% put in daystr and folder
AATS14_MakeAOD_2016

% START MODIFIED LANGLEY PLOT
clear
close all

%dateCWV='20130712';
% need to change date for each calibration day
dateCWV='20160114';

fileload=strcat('C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\mat_files\',dateCWV,'aats.mat');
load(fileload);

UTlim901=[16 20];
figure(901)
ax1=subplot(2,1,1);
plot(UT,m_ray,'b.')
hold on
plot(UT,m_H2O,'g.')
set(gca,'fontsize',16)
set(gca,'xlim',UTlim901)
grid on
hleg=legend('Ray','H2O');
set(hleg,'fontsize',16)
ylabel('airmass','fontsize',20)
title(dateCWV,'fontsize',16)
ax2=subplot(2,1,2);
plot(UT,U/H2O_conv,'g.')
set(gca,'fontsize',16)
set(gca,'xlim',UTlim901)
grid on
ylabel('CWV [cm]','fontsize',20)
xlabel('UT [hr]','fontsize',20)
linkaxes([ax1 ax2],'x')

flag_screen_method='mH2O^b';%'mH2O'; %
flag_screen_method='mH2O';

%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% min_x=1.2;%1.5;%1.2;%3.15;%1.3;%2.35;%1.2;%1.2;%3.5;%1;%3.5; %1
% max_x=4.7;%4.5;%4.7;%4.75;%5.2;%5.45; %8;%5.0;%3.5;%6.0; %3.25;%6.0;

if strcmp(flag_screen_method,'mH2O^b')
    min_x_mat=[1.2 1.2 1.2 1.2 1.2];
    max_x_mat=[10 4.5 3.5 3.2 3];
    
    min_x_mat=[1.3 1.3 1.4 1.4];
    max_x_mat=[4.0 5.0 4.0 5.0];
    stdev_mult_mat=[3 3 3 3];
    
    min_x_mat=[1.5 1.6 1.65 1.7 1.75 1.8];%[1.45];%[1.5 1.5];
    max_x_mat=[5.0 5.0 5.0 5.0 5.0 5.0];% [4.0];%[4.0 5.0];
    stdev_mult_mat=[3 3 3 3 3 3];%[3 3];

    min_x_mat=[1.3 1.3 1.4 1.4];
    max_x_mat=[4.0 5.0 4.0 5.0];
    stdev_mult_mat=[3 3 3 3];

    min_x_mat=[1.3 1.4 1.5 1.6 1.7 1.3 1.4 1.5 1.6 1.7 1.3 1.4 1.5 1.6 1.65 1.7 1.75];
    max_x_mat=[3.0 3.0 3.0 3.0 3.0 4.0 4.0 4.0 4.0 4.0 5.0 5.0 5.0 5.0 5.0  5.0 5.0];
    
    min_x_mat=[2 2.1 2.2 2.3 2.4 2.5];
    max_x_mat=[5 5 5 5 5 5];
    stdev_mult_mat=3.0*ones(size(min_x_mat));
end

if strcmp(flag_screen_method,'mH2O')
    min_m_H2O_mat=[1.2 1.2 1.2];
    max_m_H2O_mat=[15 15 15];
    stdev_mult_mat=[3 2 1.5];
    
    min_m_H2O_mat=[1.2 1.4 1.4 1.4 1.4];
    max_m_H2O_mat=[20 20 15 15 10];
    stdev_mult_mat=[3 3 3 2 2];
    
    min_m_H2O_mat=[1.2 1.4 1.4 1.4 1.4];
    max_m_H2O_mat=[20 20 15 15 10];
    stdev_mult_mat=[3 3 3 2 2];
    
    min_m_H2O_mat=[1.4];
    max_m_H2O_mat=[12];
    stdev_mult_mat=[3];
    
    min_m_H2O_mat=[1.4 1.4 1.4 1.4 1.4 1.5 1.5 1.5 1.5 1.6 1.6 1.6 1.6];
    max_m_H2O_mat=[14 12 10 8 6 14 12 10 8 6 14 12 10 8 6];
    stdev_mult_mat=[3 3 3 3 3 3 3 3 3 3 3 3 3];

    min_m_H2O_mat=[1.6:0.1:2.0];
    max_m_H2O_mat=20*ones(size(min_m_H2O_mat));
    stdev_mult_mat=3.0*ones(size(min_m_H2O_mat));
end

%following added by JML 7/15/2013 to allow specification of additional time range
iflag_specify_timerange='yes';
if strcmp(iflag_specify_timerange,'yes')
    UTrangeuse=[16.1 18.75];
else
    UTrangeuse=[-inf inf];
end

%fwrite_txtfile='/Users/meloe/Programs.dir/ReadAATS/ForMLO/Process_MLO_MK_AATS.dir/OutputText/Mod_langley_AATS14May2012.txt';
%fwrite_txtfile='c:\johnmatlab\AATS14 calibration text file\Mod_langley_AATS14_MLOJuly2013.txt'; %John
fwrite_txtfile='C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\AATS_Calib\Mod_langley_AATS14_MLOJan2016.txt'; %MS

%-------------------------------------------------------------------------%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


for iconfmod=1:length(stdev_mult_mat)
    
    if strcmp(flag_screen_method,'mH2O')
        min_m_H2O=min_m_H2O_mat(iconfmod);
        max_m_H2O=max_m_H2O_mat(iconfmod);
        min_x=exp(log(min_m_H2O)/b_H2O(10));
        max_x=exp(log(max_m_H2O)/b_H2O(10));
    elseif strcmp(flag_screen_method,'mH2O^b')
        min_x=min_x_mat(iconfmod);
        max_x=max_x_mat(iconfmod);
    end
    
    stdev_mult=stdev_mult_mat(iconfmod);
    
    flag_write_results='yes'; %'yes'
    flag_restrict_altitude='no';
    
    
    mH2Ocalc=exp(log(3)/b_H2O(10));
    
    n=size(data');
    
    
    
    %Water Vapor
    
    channels=1:size(wvl_water');
    
    
    for ichan=channels(wvl_water==1);
        
        x=m_H2O.^b_H2O(channels(ichan));
        y=data.*exp(tau_aero.*(ones(n(2),1)*m_aero)+tau_ray.*(ones(n(2),1)*m_ray)+tau_NO2.*(ones(n(2),1)*m_NO2)+tau_ozone.*(ones(n(2),1)*m_O3));
        y=log(y(ichan,:));
        
        
        
        %Airmass restriction
        
        if strcmp(flag_screen_method,'mH2O')
            i=find(m_H2O<=max_m_H2O & m_H2O>=min_m_H2O & UT>=UTrangeuse(1) & UT<=UTrangeuse(2));
        elseif strcmp(flag_screen_method,'mH2O^b')
            i=find(x<=max_x & x>=min_x & UT>=UTrangeuse(1) & UT<=UTrangeuse(2));
        end
        x=x(i);
        y=y(i);
        ruse=r(i);
        zp_use=Press_Alt(i);
        pmb_use=press(i);
        UT_use=UT(i)
        
        if strcmp(flag_restrict_altitude,'yes')
            %Altitude restriction for airborne Langley
            %i=find(ruse>6.35); %use for 7/29/04 ICARTT Langley
            %i=find(zp_use>=6.4); %use for 8/2/04 ICARTT Langley
            %i=find(zp_use>=5.78); %use for 8/7/04 ICARTT Langley
            i=find(zp_use>=6.36); %use for 8/8/04 ICARTT Langley
            x=x(i);
            y=y(i);
        end
        
        [p,S] = polyfit(x,y,1)
        [y_fit,delta] = polyval(p,x,S);
        a=y-y_fit;
        
        figure
        subplot(2,1,1)
        plot(x,y,'g+',x,y_fit);
        title(sprintf('%s %2i.%2i.%2i %8.3f µm',site,day,month,year,lambda(ichan)),'fontsize',12);
        xlabel('m_{H2O}^b','FontSize',14)
        ylabel('ln V*','FontSize',14)
        set(gca,'FontSize',14)
        grid on
        xlimval=get(gca,'xlim');
        ylimval=get(gca,'ylim');
        mH2Ocalc=exp(log(xlimval)/b_H2O(10));
        htmin=text(xlimval(1),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(1)));
        set(htmin,'fontsize',14,'color','r')
        htmax=text(xlimval(2)-0.055*(xlimval(2)-xlimval(1)),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(2)));
        set(htmax,'fontsize',14,'color','r')
        subplot(2,1,2);
        plot(x,a,'g+');
        grid on
        xlabel('m_{H2O}^b','FontSize',14)
        ylabel('Residuals','FontSize',14)
        set(gca,'FontSize',14)
        
%         pause
        
        while max(abs(a))>stdev_mult*std(a)
            i=find(abs(a)<max(abs(a)));
            x=x(i);
            y=y(i);
            [p,S] = polyfit (x,y,1)
            [y_fit,delta] = polyval(p,x,S);
            a=y-y_fit;
        end
        
        V0(ichan)=exp(p(2))/sundist(day,month,year)
        U_modlang(ichan)=(-p(1)/a_H2O(channels(ichan)))^(1/b_H2O(channels(ichan)))/1244 %Precipitable water content
        RSD(ichan)=std(a)
        
        figure
        subplot(2,1,1)
        plot(x,y,'.',x,y_fit);
        title(sprintf('%s %2i.%2i.%2i %8.3f µm   std:%3.1f   V0:%7.4f  RSD:%7.4f  V0aer:%s',site,day,month,year,lambda(ichan),stdev_mult,V0(ichan),RSD(ichan),flag_calib),'FontSize',12);
        grid on
        xlabel('m_{H2O}^b','FontSize',14)
        ylabel('ln V*','FontSize',14)
        set(gca,'FontSize',14)
        xlimval=get(gca,'xlim');
        ylimval=get(gca,'ylim');
        mH2Ocalc=exp(log(xlimval)/b_H2O(10));
        mH2Ocalc(2)=exp(log(x(1))/b_H2O(10));
        mH2Ocalc(1)=exp(log(x(end))/b_H2O(10));
        htmin=text(xlimval(1),ylimval(1)+0.5*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(1)));
        %htmin=text(xlimval(1),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(1)));
        set(htmin,'fontsize',14,'color','r')
        htmax=text(xlimval(2)-0.1*(xlimval(2)-xlimval(1)),ylimval(1)+0.5*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(2)));
        %htmax=text(xlimval(2)-0.055*(xlimval(2)-xlimval(1)),ylimval(1)+0.03*(ylimval(2)-ylimval(1)),sprintf('%4.2f',mH2Ocalc(2)));
        set(htmax,'fontsize',14,'color','r')
        subplot(2,1,2);
        plot(x,a,'b.');
        grid on
        xlabel('m_{H2O}^b','FontSize',14)
        ylabel('Residuals','FontSize',14)
        set(gca,'FontSize',14)
        %pause
        if strcmp(flag_screen_method,'mH2O')
            pfn = strcat('C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\AATS_Calib\figs\','MODLANG',num2str(year),num2str(month),num2str(day),'\','MODLnVstarairmass',num2str(iconfmod),'-',num2str(min_m_H2O),'-',num2str(max_m_H2O),'-',num2str(stdev_mult),'-',num2str(year),num2str(month),num2str(day),'B.jpg');
        else
            pfn = strcat('C:\Users\msegalro.NDC\Campaigns\MLO2016\AATS\AATS_Calib\figs\','MODLANG',num2str(year),num2str(month),num2str(day),'\','MODLnVstarairmass',num2str(iconfmod),'-',num2str(min_x),'-',num2str(max_x),'-',num2str(stdev_mult),'-',num2str(year),num2str(month),num2str(day),'B.jpg');
        end
        S = sprintf('print -djpeg %s',pfn);
        eval(S);
    end
    
    if strcmp(flag_write_results,'yes')
        %write results from Langley-plot to file
        fid=fopen(fwrite_txtfile,'a');
        fprintf(fid,'%02i/%02i/%4i', month,day,year);
        if strcmp(flag_screen_method,'mH2O^b')
            min_m_H2O=0;
            max_m_H2O=0;
        end
        fprintf(fid,'%5.1f',min_m_H2O,max_m_H2O,stdev_mult);
        fprintf(fid,'%9.4f',V0(wvl_water==1),U_modlang(wvl_water==1),RSD(wvl_water==1));
        fprintf(fid,'%6.1f',min_x,max_x);
        fprintf(fid,'%5.1f',mH2Ocalc(1),mH2Ocalc(2));
        fprintf(fid,'  %s',flag_screen_method);
        fprintf(fid,'\n');
        fclose(fid);
    end
end