%% Details of the function:
% NAME:
%   retrieveO3
% 
% PURPOSE:
%   retrieves O3 using a given (start,end) wavelength range
%   using differential cross section and linear inversion
% 
%
% CALLING SEQUENCE:
%  function [o3] = retrieveO3(s,wstart,wend,mode)
%
% INPUT:
%  - s: starsun struct from starwarapper
%  - wstart  : wavelength range start in micron
%  - wend    : wavelength range start in micron
%  - mode    : %0-MLO c0; 1-MLO ref spec
%
% hard coded:
%  - linear  : 0 - use linear constrained, 1 - use linear inversion
% 
% 
% OUTPUT:
%   o3.o3vcdDU = o3 vertical column density [DU]
%   o3.o3resiDU= o3 residual [DU];
%   o3.o3OD    = o3 optical depth
%   o3.o4OD    = o4 optical depth (from O3 band retrieval)
%   o3.h2oOD   = h2o optical depth from O3 band retrieval
%
% DEPENDENCIES:
%  - starpaths.m: to find the correct path to the correction file.
%  - loadCrossSections_global.m
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:
%  - [o3] = retrieveO3(s,0.490,0.6823,1);
%
%
% MODIFICATION HISTORY:
% Written: Michal Segal-Rozenhaimer, 2016-04 based on former versions
% from gasessubtract.m
% MS, 2016-05-05, Osan, Korea, added c0gases for O3 retrieval
%                              added option to use linear/lin_constrained
% MS, 2016-08-24, corrected bug to read correct scd reference
% -------------------------------------------------------------------------
%% function routine
function [o3] = retrieveO3(s,wstart,wend,mode)

plotting = 0;
linear   = 1;% do only linear inversion
% load cross-sections
loadCrossSections_global;

 % find wavelength range index
 istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
 iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
 
 wln = find(s.w<=s.w(iend)&s.w>=s.w(istart)); 
 
 % calculate residual spectrum (Rayleigh subtracted)
 % eta = repmat(log(s.c0(wln)),length(s.t),1) - log(s.rateslant(:,wln)) - repmat(s.m_ray,1,length(wln)).*s.tau_ray(:,wln);
 
 
%% retrieve by doing linear inversion first and then fit   
%% linear inversion

 % apply MLO Jan-2016 c0 - need to do that since AOD is using different c0
 % c0_ = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']);
 % c0  = c0_.data(wln,3);
 
 % apply specified O3 gas c0
 % decide which c0 to use
 % mode = 1;%0-MLO c0; 1-MLO ref spec
  
  [tmp]=starc0gases(nanmean(s.t),s.toggle.verbose,'O3',mode);
  
  if mode==0
      % when mode==0 need to choose wln
      c0 = tmp(wln)';
  elseif mode==1
      c0 = tmp.o3refspec;
  end
 
%  c0_wstart=0.490;
%  c0_wend  =0.682;
%  % find c0 wavelength range index
%  c0_istart = interp1(s.w,[1:length(s.w)],c0_wstart, 'nearest');
%  c0_iend   = interp1(s.w,[1:length(s.w)],c0_wend  , 'nearest');
%  
%  c0_wln_ind = find(s.w<=s.w(c0_iend)&s.w>=s.w(c0_istart)); 
%  c0_wln     = s.w(c0_wln_ind);
%  
%  % find wavelength range for new c0
%  new_c0_istart = interp1(c0_wln,[1:length(c0_wln)],wstart, 'nearest');
%  new_c0_iend   = interp1(c0_wln,[1:length(c0_wln)],wend  , 'nearest');
%  new_c0_wln    = c0_wln(new_c0_istart:new_c0_iend);
%  new_c0        = c0(new_c0_istart:new_c0_iend);
%  c0=new_c0;
%  % find wavelengths
%  wln_istart = interp1(s.w,[1:length(s.w)],wstart, 'nearest');
%  wln_iend   = interp1(s.w,[1:length(s.w)],wend  , 'nearest');
%  wln        = find(s.w<=s.w(wln_iend)&s.w>=s.w(wln_istart)); 
%  w = s.w(wln); 
 
 % apply MLO Jan-2016 c0 - need to do that since AOD is using different c0
 % c0_ = importdata([starpaths,'20160109_VIS_C0_refined_Langley_at_MLO_screened_2.0std_averagethru20160113.dat']);
 % c0  = c0_.data(wln,3);
 
    basis=[o3coef(wln), o4coef(wln), no2coef(wln) h2ocoef(wln)...
        ones(length(wln),1) s.w(wln)'.*ones(length(wln),1) ((s.w(wln)').^2).*ones(length(wln),1) ((s.w(wln)').^3).*ones(length(wln),1)];
 
   ccoef=[];
   RR=[];
   % o3 inversion is being done on total slant path (not Rayleigh
   % subtracted)
   for k=1:length(s.t);
        %meas = log(s.c0(wln)'./s.rateslant(k,(wln))');
        meas = log(c0'./s.rateslant(k,(wln))');

        % invert
        coef=basis\meas;
        %coefo3=basiso3\tau_OD(k,(wln))';
        recon=basis*coef;
        RR=[RR recon];
        ccoef=[ccoef coef];
   end
   
   % calculate vcd
   
   % create smooth o3 time-series
   xts = 60/3600;   %60 sec in decimal time
   
   if mode==0
       o3VCD = real((((ccoef(1,:))*1000))')./s.m_O3;
       tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
       [o3VCDsmooth, sn] = boxxfilt(tplot, o3VCD, xts);
       o3vcd_smooth = real(o3VCDsmooth);
   elseif mode==1
       % load reference spectrum
       % ref_spec = load([starpaths,'20160113O3refspec.mat']);
       o3SCD = real((((ccoef(1,:))*1000))') + tmp.o3scdref;%ref_spec.o3col*ref_spec.mean_m;
       tplot = serial2Hh(s.t); tplot(tplot<10) = tplot(tplot<10)+24;
       [o3SCDsmooth, sn] = boxxfilt(tplot, o3SCD, xts);
       o3vcd_smooth = real(o3SCDsmooth)./s.m_O3;
   end
   
   % checkexiting toolbox
   %v=ver;f=any(strcmp('optim', {v.Name}));
   %license('test', 'optim_toolbox') 
%  % calculate error
   tau_OD  = s.tau_tot_slant;%s.tau_tot_vertical;% need to also check tau_tot_slant;
   o3Err   = (tau_OD(:,wln)'-RR(:,:))./repmat((o3coef(wln)),1,length(s.t));    % in atm cm
   MSEo3DU = real(((1/length(wln)-8)*sum(o3Err.^2))');                         
   
   %license('test', 'optim_toolbox') 

   % calculate error
   tau_OD  = s.tau_tot_slant;%s.tau_tot_vertical;% need to also check tau_tot_slant;
   o3Err   = (tau_OD(:,wln)'-RR(:,:))./repmat((o3coef(wln)),1,length(s.t));    % in atm cm
   MSEo3DU = real(((1/length(wln))*sum(o3Err.^2))');                         
   RMSEo3  = real(sqrt(real(MSEo3DU)))./s.m_O3;                                % convert to DU vertical
   
%    gas.o3Inv    = o3VCD;%o3vcd_smooth is the default output;
%    gas.o3Inv    = o3vcd_smooth;
%    gas.o3resiInv= RMSEo3;

  if plotting
       figure;subplot(211);%plot(tplot,o3VCD,'.r');hold on;
              plot(tplot,o3vcd_smooth,'.g');hold on;
              %plot(tplot,O3conc_smooth,'.r');hold on;
              axis([tplot(1) tplot(end) 250 350]);
              xlabel('time');ylabel('o3 [DU]');
              title([datestr(s.t(1),'yyyy-mm-dd'), ' linear inversion']);
              %legend('inversion','inversion smooth','constrained inversion smooth');
              legend('inversion smooth');
              subplot(212);plot(tplot,RMSEo3,'.r');hold on;
              axis([tplot(1) tplot(end) 0 5]);
              xlabel('time');ylabel('o3 RMSE [DU]');
              title([datestr(s.t(1),'yyyy-mm-dd'), 'linear inversion']);
  end
   
    % prepare to plot spectrum OD and o3 cross section
   %tau_OD = log(repmat(s.c0(wln),length(s.t),1)./s.rateslant(:,(wln)));
   tau_OD = log(repmat(c0,length(s.t),1)./s.rateslant(:,(wln)));
   o3spectrum     = tau_OD-RR' + ccoef(1,:)'*basis(:,1)';
   o3fit          = ccoef(1,:)'*basis(:,1)';
   o3residual     = tau_OD-RR';

   %RMSEo3_new     = sqrt(sum(sum((o3residual.^2)))/(length(wln)-8));
   
   % save data for further plotting (heatmap)
   t   = serial2Hh(s.t);
   alt = s.Alt;
   lat = s.Lat;
   lon = s.Lon;
   res = real(o3residual./repmat(s.m_O3,1,length(wln)));
   res_ = res(~isnan(res(:,1)),:);
   dat = [t alt lat lon res];
   fi = strcat(datestr(s.t(1),'yyyy-mm-dd'), '-O3residual','.txt');
   save(fi,'-ASCII','dat');
   
   if plotting
%      plot fitted and "measured" o3 spectrum
         for i=1:1000:length(s.t)
             figure(1111);
             plot(s.w((wln)),o3spectrum(i,:),'-k','linewidth',2);hold on;
             plot(s.w((wln)),o3fit(i,:),'-r','linewidth',2);hold on;
             plot(s.w((wln)),o3residual(i,:),':k','linewidth',2);hold off;
             xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' o3VCD= ',num2str(o3vcd_smooth(i)),' RMSE = ',num2str(RMSEo3(i)./s.m_O3(i))),...
                    'fontsize',14,'fontweight','bold');
             ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted O_{3} spectrum','residual');
             set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
             pause(1);
         end
      c_wln    = s.w(wln);
      wlnlabel = arrayfun(@(x){sprintf('%0.3f',x)}, c_wln);
      tlabel   = arrayfun(@(x){sprintf('%0.3f',x)}, t);
      altlabel = arrayfun(@(x){sprintf('%0.3f',x)}, alt);
      latlabel = arrayfun(@(x){sprintf('%0.3f',x)}, lat);
      lonlabel = arrayfun(@(x){sprintf('%0.3f',x)}, lon);
      dat=dat(:,[5:246]);
      %dat = dat';
      figure(222);
      surf(res);
      %heatmap(dat(:,[1,5:246]), 'RowLabels', wlnlabel, 'ColumnLabels',tlabel,'Colormap', 'redbluecmap');
      %heatmap(dat,'RowLabels', 5:246,'Colorbar',true);
      heatmap(dat', wlnlabel,tlabel);
      colormap(redblue);
      colorbar;
      
      figure(223);
      %heatmap(dat(:,[1,5:246]), 'RowLabels', wlnlabel, 'ColumnLabels',tlabel,'Colormap', 'redbluecmap');
      %heatmap(dat,'RowLabels', 5:246,'Colorbar',true);
      heatmap(dat, wlnlabel,altlabel);
      colormap(redblue);
      colorbar;
      
      figure(224);
      %heatmap(dat(:,[1,5:246]), 'RowLabels', wlnlabel, 'ColumnLabels',tlabel,'Colormap', 'redbluecmap');
      %heatmap(dat,'RowLabels', 5:246,'Colorbar',true);
      heatmap(dat, wlnlabel,latlabel);
      colormap(redblue);
      colorbar;
      
      figure(225);
      %heatmap(dat(:,[1,5:246]), 'RowLabels', wlnlabel, 'ColumnLabels',tlabel,'Colormap', 'redbluecmap');
      %heatmap(dat,'RowLabels', 5:246,'Colorbar',true);
      heatmap(dat, wlnlabel,lonlabel);
      colormap(redblue);
      colorbar;
   end
   
   
   if linear==0
 
   % save linear inversion coefficients as input to constrained retrieval
   
   x0=[ccoef(1,:)' ccoef(2,:)' ccoef(4,:)' ccoef(5,:)' ccoef(6,:)' ccoef(7,:)' ccoef(8,:)'];

           O3conc=[];H2Oconc=[];O4conc=[];O2conc=[];O3resi=[];o3OD=[];

           % perform constrained retrieval
            if mode==0
                    [O3conc, H2Oconc, O4conc, O3resi, o3OD, varall_lin] = o3corecalc_lin_adj(s,o3coef,o4coef,h2ocoef,wln,s.tau_tot_slant,x0,c0(wln));
            elseif mode==1
                    [O3conc, H2Oconc, O4conc, O3resi, o3OD, varall_lin] = o3corecalc_lin_adj(s,o3coef,o4coef,h2ocoef,wln,s.tau_tot_slant,x0,c0);
            end


           [O3conc_s, sn] = boxxfilt(tplot, O3conc, xts);
           O3conc_smooth = real(O3conc_s);
           % save smooth values
           %gas.o3 = O3conc_smooth;
           %gas.o3resi = (O3resi);
           %gas.o4  = O4conc; % already converted in routine./s.m_ray; % slant converted to vertical
           %gas.h2o = H2Oconc;% already converted in routine./s.m_H2O;% slant converted to vertical
           %gas.o3OD  = o3OD; % this is to be subtracted from slant path this is slant
           %tplot = serial2hs(s.t);

           o3amount  = -log(exp(-(real(O3conc/1000)*o3coef')));%(O3conc/1000)*o3coef';
           o4coefVIS = zeros(length(s.w),1); o4coefVIS(1:1044) = o4coef(1:1044);
           o4amount  = -log(exp(-(real(O4conc)*o4coef')));%O4conc*o4coef';
           h2ocoefVIS= zeros(length(s.w),1); h2ocoefVIS(wln) = h2ocoef(wln);
           h2oamount = -log(exp(-(real(H2Oconc)*h2ocoefVIS')));%H2Oconc*h2ocoefVIS';
           %tau_OD_fitsubtract = tau_ODslant - o3amount - o4amount -h2oamount;
           %tau_OD_fitsubtract4 = tau_OD_fitsubtract3 - real(o3amount) - real(o4amount) -real(h2oamount);% subtraction of remaining gases in o3 region
           
           % save parameters
            o3.o3DU    = O3conc_smooth;
            o3.o3resiDU= O3resi;%RMSEo3;

            o3.o4      = O4conc;
            o3.h2o     = H2Oconc;
  
    elseif linear==1
           % this is vertical
           o3amount  = -log(exp(-(real(o3vcd_smooth/1000)*o3coef')));%(O3conc/1000)*o3coef';VCD
           o4coefVIS = zeros(length(s.w),1); o4coefVIS(1:1044) = o4coef(1:1044);
           o4amount  = (-log(exp(-(real(ccoef(2,:)')*o4coef'))))./repmat(s.m_ray,1,length(s.w));%O4conc*o4coef';
           h2ocoefVIS= zeros(length(s.w),1); h2ocoefVIS(wln) = h2ocoef(wln);
           h2oamount = (-log(exp(-(real(ccoef(4,:)')*h2ocoefVIS'))))./repmat(s.m_H2O,1,length(s.w));%H2Oconc*h2ocoefVIS';
           
            % save parameters
            o3.o3DU    = o3vcd_smooth;
            o3.o3resiDU= RMSEo3;
            o3.o3SCD   = (ccoef(1,:)*1000)';

            o3.o4      = real(ccoef(2,:));
            o3.h2o     = real(ccoef(4,:));

   end   
   
   

   % save OD amount

    o3.o3OD    = o3amount;%(O3conc/1000)*o3coef';
    o3.o4OD    = o4amount;
    o3.h2oOD   = h2oamount;
    
    %% flag bad O3 values based on std
    o3std =NaN(length(s.t),1);
    o3mean=NaN(length(s.t),1);
    o3.flag  =zeros(length(s.t),1);
    sd_o3_crit = 5e-3;
    % 0 is good data, 1 is bad data
    
    ti=60/86400;
            for i=1:length(s.t);
                rows=find(s.t>=s.t(i)-ti/2&s.t<=s.t(i)+ti/2);
                if numel(rows)>0;
                    o3std(i) =nanstd(o3vcd_smooth(rows),0,1);
                    o3mean(i)=nanmean(o3vcd_smooth(rows),1);
                end
            end;
            
            % flag
            o3relstd=o3std./o3mean;
            o3.flag(o3relstd>sd_o3_crit)=1;

    
  
 
 return;