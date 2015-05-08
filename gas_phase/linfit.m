function [varall,gas] = linfit(s,wln,crosssections,xsind,gasname)
% retrieve trace gases by linear fit
% output is input to non-linear fit
% this is for count rate, using appropraite cross
% sections for each window, and 3rd order polynomial
% polyorder is polynomial order
% basis is the parameters matrix
% s.ratetot is slant OD, Ray subtracted
% coef is retrieved coefficients (SC) for each data point
% ccoef is a matrix of all retrieved coefficients
% RR is fit residual
% recon is reconstructed spectrum
%
% MS, 2015-04-24, NASA Ames
% Modification History:
%
%------------------------------------------------------------------

% prepare basis matrix (size: wln x # of components)

  polyorder  = 3;
  basisl = length(xsind)+polyorder+1;
  basis  = zeros(length(wln),basisl);
  k = 0;
  for i=1:basisl
      if i <= length(xsind)
            basis(:,i) = crosssections(wln,xsind(i));
      elseif i == length(xsind) + 1
            basis(:,i) = ones(length(wln),1);
      else
            k = k + 1;
            basis(:,i) = (s.w(wln)'.^k).*ones(length(wln),1);
      end
  end
  
% retrieve SCD
 tt = size(s.t,1);
 ccoef=[];
 RR   =[];
   for k=1:tt;
        meas = log(s.c0(wln)'./s.ratetot(k,(wln))');
        coef=basis\meas;
        recon=basis*coef;
        RR=[RR recon];
        ccoef=[ccoef coef];
   end

% calculate main gas VCD (in DU)
 
 if strcmp(gasname,'o3')
     airmass = s.m_O3;
 elseif strcmp(gasname,'no2')
     airmass = s.m_NO2;
 end
 
 VCD = real((((ccoef(1,:))*1000))')./airmass;
 
 % calculate residual error
 model = log(repmat(s.c0(wln),tt,1)./ s.rateslant(:,wln));
 Err   = (model-RR')./repmat((coef),1,tt);          % in atm cm
 MSEDU = real((1000*(1/length(wln))*sum(Err.^2))'); % convert from atm cm to DU
 RMSE  = real(sqrt(real(MSEDU)));
   
 
 % prepare to plot meas,model,res
   
   spectrum     = model-RR' + ccoef(1,:)'*basis(:,1)';
   fit          = ccoef(1,:)'*basis(:,1)';
   residual     = model-RR';
   
%    plot fitted and "measured" no2 spectrum
     for i=1:100:tt
         figure(888);
         plot(s.w((wln)),spectrum(i,:),'-k','linewidth',2);hold on;
         plot(s.w((wln)),fit(i,:),'-r','linewidth',2);hold on;
         plot(s.w((wln)),residual(i,:),':k','linewidth',2);hold off;
         xlabel('wavelength [\mum]','fontsize',14,'fontweight','bold');title(strcat(datestr(s.t(i),'yyyy-mm-dd HH:MM:SS'),' o3VCD= ',num2str(VCD(i))),...
                'fontsize',14,'fontweight','bold');
         ylabel('OD','fontsize',14,'fontweight','bold');legend('measured spectrum (subtracted)','fitted O_{3} spectrum','residual');
         set(gca,'fontsize',12,'fontweight','bold');%axis([0.430 0.49 -0.015 0.01]);legend('boxoff');
         pause(1);
     end
%%
 
return;