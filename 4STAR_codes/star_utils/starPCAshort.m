function [pcadata pcavisdata pcanirdata pcvis pcnir eigvis eignir pcanote] =starPCAshort(starsun)
% this function recieves starsun data structure
% and extracts PCA's from data, and reconstructs
% data into additional data tab as starsun.pcadata
%-------------------------------------------------
% Michal Feb 22 2013
% added IND calculation and automatic choice of reconstruction eigVector #
% Michal Segal Feb 25 2013
% added calculation of starsun.rate Aug 22 2013
%
% Michal added figure flag Sep-20 2013
%-------------------------------------
figureflag = 0; % 0 is no figure generation/1 is yes
% standartization
%----------------
N = length(starsun.t);
%
avg_rate=nanmean(starsun.rate);
std_rate=nanstd(starsun.rate);
%
%
ratenorm_=(starsun.rate-repmat(avg_rate,N,1))./repmat(std_rate,N,1);
% eliminate NaN's
inan = isNaN(ratenorm_);
inanind = inan(:,2)==0;
ratenorm=ratenorm_(inan(:,2)==0,:);
vis_ind = [220:1044];
nir_ind = [1045:1510];
ratenormvis = ratenorm(:,vis_ind);
ratenormnir = ratenorm(:,nir_ind);
%
% use data
visdata = starsun.rate(inan(:,2)==0,vis_ind);
nirdata = starsun.rate(inan(:,2)==0,nir_ind);

% covariance matrix
%-------------------
% use data without standartization-covariance matrix
rateCovvis = cov(starsun.rate(inan(:,2)==0,vis_ind));
rateCovnir = cov(starsun.rate(inan(:,2)==0,nir_ind));

% SVD
%-----
[U_vis,S_vis,V_vis] = svd(rateCovvis);    %C=U*S*V'
[U_nir,S_nir,V_nir] = svd(rateCovnir);    %C=U*S*V'
%
%
% PC's
%------
% vis
PC_vis=U_vis.*sqrt(repmat(diag(S_vis)',length(vis_ind),1));
var_vis=100*(diag(S_vis))/sum((diag(S_vis)));
varsum_vis=cumsum(var_vis);
% nir
PC_nir=U_nir.*sqrt(repmat(diag(S_nir)',length(nir_ind),1));
var_nir=100*(diag(S_nir))/sum((diag(S_nir)));
varsum_nir=cumsum(var_nir);

% eigVal
%-------
% vis
CIeigVal_vis=1.96*sqrt(2/N*(diag(S_vis)).^2);%CI for vis eigenvalues
ddd=(diag(S_vis));

% nir
CIeigVal_nir=1.96*sqrt(2/N*(diag(S_nir)).^2);%CI for nir eigenvalues
nnn=(diag(S_nir));

% scores
%-------
vis_scores=ratenormvis*U_vis;
nir_scores=ratenormnir*U_nir;

% calculate IND values
%----------------------
% vis
k=0;
for i=2:length(vis_ind)
    k=k+1;
    REvis(k) = sqrt(sum(ddd(i:end))/(sum(inanind)*(length(vis_ind)-k)));
    INDvis(k)= REvis(k)/(length(vis_ind)-k).^2;
end

% nir
k=0;
for i=2:length(nir_ind)
    k=k+1;
    REnir(k) = sqrt(sum(nnn(i:end))/(sum(inanind)*(length(nir_ind)-k)));
    INDnir(k)= REnir(k)/(length(nir_ind)-k).^2;
end
%
% IND related calculation
% find minimal values
[xvis,minindvis] = min(INDvis);
[xnir,minindnir] = min(INDnir);
%
%% plots
if figureflag==1
% visualize various matrices
%----------------------------
    figure(1)   % normalized-all
    plot(starsun.w,ratenorm);title('ratenorm');
    figure(11)  % raw data
    plot(starsun.w,starsun.rate);title('rate');
    figure(111) % correlation matrix
    plot(starsun.w(220:1044),rateCorrvis);title('corralation');
    figure(1111)% covariance matrix
    plot(starsun.w(220:1044),rateCovvis);title('covariance');
    % # of EIG
    figure(2);errorbar([1:20],ddd(1:20),CIeigVal_vis(1:20),'ob');title('vis EIG');
    xlabel('# of eigenvalues');ylabel('eigenvalues value');
    figure(22);errorbar([1:20],nnn(1:20),CIeigVal_nir(1:20),'or');title('nir EIG');
    xlabel('# of eigenvalues');ylabel('eigenvalues value');

    % plot IND
    figure(666)
    subplot(211);plot([1:length(vis_ind)-1],INDvis,'.-b');axis([1 60 1e-12 1e-8]);hold on;
    plot(minindvis,INDvis(minindvis),'<b','markerfacecolor','b','markersize',8);xlabel('# EIG');ylabel('IND');
    title(datestr(starsun.t(1),'yyyy-mm-dd'));
    subplot(212);plot([1:length(nir_ind)-1],INDnir,'.-r');axis([1 60 1e-10 1e-8]);hold on;
    plot(minindnir,INDnir(minindnir),'<r','markerfacecolor','r','markersize',8);xlabel('# EIG');ylabel('IND');

    % plot variance
    figure(3);
    plot([1:10],varsum_vis(1:10),'-xb','MarkerSize',12);hold on;
    plot([1:10],varsum_nir(1:10),'-xr','MarkerSize',12);hold on;
    title(datestr(starsun.t(1),'yyyy-mm-dd')); grid on;
    xlabel('PC number');ylabel('Cumulative variance (%)');legend('rateCorrvis','rateCorrnir');
    % plot PC's
    % vis
    figure(4);
    for i=1:6
    ax(i)=subplot(3,2,i); hold on; plot(starsun.w(vis_ind),PC_vis(:,i),'-b','LineWidth',2);
    xlabel('wavelength [\mum]');ylabel(sprintf('PC%1.0f',i));
    axis([starsun.w(vis_ind(1)) starsun.w(vis_ind(end)) min(PC_vis(:,i)) max(PC_vis(:,i))]);
    title(datestr(starsun.t(1),'yyyy-mm-dd'));
    end
    linkaxes(ax,'x'); 
    % nir
    figure(5);
    for i=1:6
    ax(i)=subplot(3,2,i); hold on; plot(starsun.w(nir_ind),PC_nir(:,i),'-r','LineWidth',2);
    xlabel('wavelength [\mum]');ylabel(sprintf('PC%1.0f',i));
    axis([starsun.w(nir_ind(1)) starsun.w(nir_ind(end)) min(PC_nir(:,i)) max(PC_nir(:,i))]);
    title(datestr(starsun.t(1),'yyyy-mm-dd'));
    end
    linkaxes(ax,'x'); 
    % plot scores
    % vis
    figure(6);
    for i=1:6
    ax(i)=subplot(3,2,i); hold on; plot(serial2Hh(starsun.t(inanind==1)),vis_scores(:,i),'.b','LineWidth',2);
    xlabel('time [UT]');ylabel(sprintf('scores of PC%1.0f',i));
    title(datestr(starsun.t(1),'yyyy-mm-dd'));
    end
    linkaxes(ax,'x');
    % nir
    figure(7);
    for i=1:6
    ax(i)=subplot(3,2,i); hold on; plot(serial2Hh(starsun.t(inanind==1)),nir_scores(:,i),'.r','LineWidth',2);
    xlabel('time [UT]');ylabel(sprintf('scores of PC%1.0f',i));
    title(datestr(starsun.t(1),'yyyy-mm-dd'));
    end
    linkaxes(ax,'x');
    
    figure(8);
    %plot(starsun.w(vis_ind),vis_reconstructed6([5000],:),'-b');hold on;
    plot(starsun.w(vis_ind),vis_reconstructedout(round(length(starsun.t)/2),:),'-g','linewidth',2);hold on;
    plot(starsun.w(vis_ind),visdata(round(length(starsun.t)/2),:),'-k','linewidth',2);hold off;
    legend(strcat(num2str(minindvis),' PCs'),'original spectrum');
    title(['vis original data', datestr(starsun.t(1),'yyyy-mm-dd')]);
    % std
    figure(9);
    %plot(starsun.w(vis_ind),zvis_reconstructed6(length(starsun.t)/2,:),'-b');hold on;
    plot(starsun.w(vis_ind),zvis_reconstructedout(round(length(starsun.t)/2),:),'-g','linewidth',2);hold on;
    plot(starsun.w(vis_ind),zvisdata(round(length(starsun.t)/2),:),'-k','linewidth',2);hold off;
    legend(strcat(num2str(minindvis),' PCs'),'original spectrum');grid on;
    title(['vis standartized data', datestr(starsun.t(1),'yyyy-mm-dd')]);
%

end

%% reconstruct the data
% use differnt number of vis PCA's
% C=U*S*V'
%

% reconstruct
% 6PCs
% [vis_residuals6,vis_reconstructed6] = pcares(visdata,6);
% [nir_residuals6,nir_reconstructed6] = pcares(nirdata,6);
% % 10PCs
% [vis_residuals10,vis_reconstructed10] = pcares(visdata,10);
% [nir_residuals10,nir_reconstructed10] = pcares(nirdata,10);
% % 20PCs
% [vis_residuals20,vis_reconstructed20] = pcares(visdata,20);
% [nir_residuals20,nir_reconstructed20] = pcares(nirdata,20);
% % standartize
% zvisdata = zscore(visdata);
% znirdata = zscore(nirdata);
% % reconstruct
% % 6PC's
% [zvis_residuals6,zvis_reconstructed6] = pcares(zvisdata,6);
% [znir_residuals6,znir_reconstructed6] = pcares(znirdata,6);
% % 10PC's
% [zvis_residuals10,zvis_reconstructed10] = pcares(zvisdata,10);
% [znir_residuals10,znir_reconstructed10] = pcares(znirdata,10);
% %
%******************************************************
% use reconstruction function with #Eig choice by IND *
%******************************************************
% original data
[vis_residualsout,vis_reconstructedout] = pcares(visdata,minindvis*2);
[nir_residualsout,nir_reconstructedout] = pcares(nirdata,minindnir*2);
%
%***********************************
% assign results to function output
%***********************************
pcavisdata = NaN(length(starsun.t),length(starsun.w));
pcavisdata(inanind==1,vis_ind) = vis_reconstructedout;
%figure;plot(starsun.w,pcavisdata)
pcanirdata = NaN(length(starsun.t),length(starsun.w));
pcanirdata(inanind==1,nir_ind) = nir_reconstructedout;
% put everything in one data array
pcadata = NaN(length(starsun.t),length(starsun.w));
pcadata(inanind==1,vis_ind) = vis_reconstructedout;
pcadata(inanind==1,nir_ind) = nir_reconstructedout;
pcvis = PC_vis;
pcnir = PC_nir;
eigvis= (diag(S_vis));
eignir= (diag(S_nir));
pcanote = strcat('reconstruction made with PC-VIS (#) = ', num2str(minindvis),' and with PC-NIR (#) = ', num2str(minindnir),' calculations are based on covariance matrix SVD');

return;


