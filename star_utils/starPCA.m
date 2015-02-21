%% Details of the program:
% NAME:
%   starPCA
%
% PURPOSE:
%  reduce noise in direct sun rate/OD data by performing PCA on
%  selected spectral ranges
%
% CALLING SEQUENCE:
%   s = starPCA(s,range,mode)
%
% INPUT:
%  - s: structure of starsun data (s) with wavelength range to subset
%       range is a vector with relevant index for wavelengths
%       mode is 0 for processing rate and 1 for processing OD
%
% OUTPUT:
%  - s: original structure of starsun with added variables
%       from pca analysis (eigenvectors, reconstructed spectra) 
%
% DEPENDENCIES:
% 
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  none
%
% MODIFICATION HISTORY:
% Written: Michal Segal, NASA Ames, February 19th, 2015
% Modified:
%
% -------------------------------------------------------------------------
function [s] =starPCA(s,range,mode)

figureflag = 0; % 0 is no figure generation/1 is yes

%% assign data according to mode and spectral range
if     mode==0
    dat = s.ratetot(:,range);
elseif mode==1
    dat = s.tau_tot_slant(:,range);
end

%% filter out NaN's or inf values in data
subw = any(isfinite(dat),1);               % filter out any wavelength with no finite values
subd = find(all(isfinite(dat(:,subw)),2)); % filter out points with no finite values
data = dat(subd,subw);

%% standartize data
N = length(subd);
%
dat_avg=mean(data);
dat_std=std( data);
%
%
datnorm=(data-repmat(dat_avg,N,1))./repmat(dat_std,N,1);

%% calculatae covariance
%-----------------------
datCov = cov(data);

%% SVD
%------
[U,S,V] = svd(datCov);      %C=U*S*V'
%
%
% PC's
%------
PC=U.*sqrt(repmat(diag(S)',length(range),1));% if using covariance matrix
var=100*(diag(S))/sum((diag(S)));
varsum=cumsum(var);

% eigVal
%-------
CIeigVal=1.96*sqrt(2/N*(diag(S)).^2);%CI for vis eigenvalues
ddd=(diag(S));

% scores
%-------
scores=data*U;%data*U;%datnorm*U;

% calculate IND values
%----------------------
% this is factor indicator function
% which helps in the determination
% of # of eigVec to retain for reconstruction
% of the data [Turner et al., 2006]
k=0;
for i=2:length(range)
    k=k+1;
    RE(k) = sqrt(sum(ddd(i:end))/(N*(length(range)-k)));
    IND(k)= RE(k)/((length(range)-k).^2);
end

% find minimal pc's used to represent data
[x,minind] = min(IND);
%

% reconstruct data
% Dest
% create subset matrix for projection
% U_sub = U(:,1:minind*2);
% P_u   =(U_sub*(U_sub'*U_sub)^-1*U_sub');
% no2proj = P_u*no2coef(range);
% project no2 vector onto PC subspace
% projection matrix
% Uproj = U*U'*vector_of_interest;
% derive OSP from U_sub
%--------------------------------------------
% I_u=eye(size(U_vis,1));
% P_u=(I_u)-(U_sub*(U_sub'*U_sub)^-1*U_sub');
% % perform OSP on exp
% %--------------------------------
% dataOsp=P_u*vis_data';% experiment projection
%
% figure;plot(vis_sun.w(vis_ind),dataOsp(:,5000)','--r');
%
%% plots
if figureflag==1
% visualize various matrices
%----------------------------
    figure(1)   % normalized-all
    plot(s.w(range),datnorm);title('normalized data');
    figure(11)  % raw data
    plot(s.w(range),data);title('original data');
    figure(111) % covariance matrix
    plot(s.w(range),datCov);title('covariance');
    % # of EIG
    figure(2);errorbar([1:20],ddd(1:20),CIeigVal(1:20),'ob');title('EIG');
    xlabel('# of eigenvalues');ylabel('eigenvalues value');
    
    % plot IND
    figure(666)
    plot([1:length(range)-1],IND,'.-b');%axis([1 60 1e-12 1e-8]);hold on;
    plot(minind,IND(minind),'<b','markerfacecolor','b','markersize',8);xlabel('# EIG');ylabel('IND');
    title(datestr(s.t(1),'yyyy-mm-dd'));
    
    % plot variance
    figure(3);
    plot([1:20],varsum(1:20),'-xb','MarkerSize',12);hold on;
    title(datestr(s.t(1),'yyyy-mm-dd')); grid on;
    xlabel('PC number');ylabel('Cumulative variance (%)');legend('rateCorrvis','rateCorrnir');
    % plot PC's
    figure(4);
    for i=1:6
    ax(i)=subplot(3,2,i); hold on; plot(s.w(range),PC(:,i),'-b','LineWidth',2);
    xlabel('wavelength [\mum]');ylabel(sprintf('PC%1.0f',i));
    axis([s.w(range(1)) s.w(range(end)) min(PC(:,i)) max(PC(:,i))]);
    title(datestr(s.t(1),'yyyy-mm-dd'));
    end
    linkaxes(ax,'x'); 
    
    % plot PC's (by U only)
%     figure(44);
%     for i=1:6
%     ax(i)=subplot(3,2,i); hold on; plot(s.w(range),U(:,i),'-b','LineWidth',2);
%     xlabel('wavelength [\mum]');ylabel(sprintf('PC (by U) %1.0f',i));
%     axis([s.w(range(1)) s.w(range(end)) min(U(:,i)) max(U(:,i))]);
%     title(datestr(s.t(1),'yyyy-mm-dd'));
%     end
%     linkaxes(ax,'x'); 
%     
    % plot scores
    figure(66);
    for i=1:6
    ax(i)=subplot(3,2,i); hold on; plot(serial2Hh(s.t(subd)),scores(:,i),'.b','LineWidth',2);
    xlabel('time [UT]');ylabel(sprintf('scores of PC%1.0f',i));
    title(datestr(s.t(1),'yyyy-mm-dd'));
    end
    linkaxes(ax,'x');
    
    %% reconstruct the data
    % use differnt number of vis PCA's
    % C=U*S*V'
    %

    % reconstruct
    % 6PCs
     [residuals6,reconstructed6] = pcares(data,6);
    % % 10PCs
     [residuals10,reconstructed10] = pcares(data,10);
    % % 20PCs
     [residuals20,reconstructed20] = pcares(data,20);
    
    % % standartize
    % zdata = zscore(data);
    % % reconstruct
    % % 6PC's
    % [z_residuals6,z_reconstructed6] = pcares(zdata,6);
    % % 10PC's
    % [z_residuals10,z_reconstructed10] = pcares(zdata,10);
    % %
    
    figure(8);
    %plot(starsun.w(vis_ind),vis_reconstructed6([5000],:),'-b');hold on;
    plot(s.w(range),reconstructed6(round(N/2),:),'-g','linewidth',2);hold on;
    plot(s.w(range),reconstructed10(round(N/2),:),'--g','linewidth',2);hold on;
    plot(s.w(range),reconstructed20(round(N/2),:),':g','linewidth',2);hold on;
    plot(s.w(range),data(round(N/2),:),'-k','linewidth',2);hold off;
    legend('6 pc','10 pc','20 pc');
    legend(strcat(num2str(minind),' PCs'),'original spectrum');
    title([datestr(s.t(1),'yyyy-mm-dd')]);
    % std
%     figure(9);
%     %plot(starsun.w(vis_ind),zvis_reconstructed6(length(starsun.t)/2,:),'-b');hold on;
%     plot(s.w(range),zvis_reconstructedout(round(length(s.t)/2),:),'-g','linewidth',2);hold on;
%     plot(s.w(range),zvisdata(round(length(s.t)/2),:),'-k','linewidth',2);hold off;
%     legend(strcat(num2str(minind),' PCs'),'original spectrum');grid on;
%     title(['standartized data', datestr(s.t(1),'yyyy-mm-dd')]);
%

end

%******************************************************
% use reconstruction function with #Eig choice by IND *
%******************************************************
% original data
[residualsout,reconstructedout] = pcares(data,minind*2);

%
%***********************************
%% assign results to function output
%***********************************
pcastr = strcat('pca_',num2str(round(1000*s.w(range(1)))),'_',num2str(round(1000*s.w(range(end)))));
s.(pcastr).pcadata = NaN(length(s.t),length(range));

if     mode==0
    % reconstruct OD if rate is input - this is slant data
    s.(pcastr).pcadata(subd,:) = ...
               real(-log(reconstructedout./repmat(s.c0(range),length(subd),1)));
elseif mode==1
    s.(pcastr).pcadata(subd,:) = reconstructedout;
end
%figure;plot(s.w,pcadata)
s.(pcastr).pc      = PC;
s.(pcastr).eig     = (diag(S));
s.(pcastr).pcanote = strcat('reconstruction made with PC (#) = ', num2str(minind*2),' calculations are based on covariance matrix SVD');
return;


