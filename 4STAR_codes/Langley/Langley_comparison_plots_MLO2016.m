%Langley_comparison_plots_MLO2016.m

% for j=1:length(Junelangleytest.goodlangleys)
%     eval(['c0Jun_all(:,j)=Junelangleytest.c0new_',Junelangleytest.goodlangleys{j},'(1,:);']) %2-sigma c0s
%     
% end

figure; subplot(2,1,1);
plot(1000*w(1:length(viscols)),c0new_meanJul(1:length(viscols))./c0new_meanJul(1:length(viscols)),'--','color','b','linewidth',3); hold on
plot(1000*w(1:length(viscols)),c0new_mean(1:length(viscols))./c0new_meanJul(1:length(viscols)),'-','color','k','linewidth',3)
plot(1000*w(1:length(viscols)),c0new_mean11MLO2(1:length(viscols))./c0new_meanJul(1:length(viscols)),'--','color',[0.5 0.5 0.5],'linewidth',2)
set(gca,'fontsize',14); title('C0 VIS mean normalized to July mean'); xlabel('\lambda')
% ylim([0 800]); 
xlim([100 1000]); %ylim([
subplot(2,1,2)
plot(1000*w((length(viscols)+1):end),c0new_meanJul((length(viscols)+1):end)./c0new_meanJul((length(viscols)+1):end),'--','color','b','linewidth',3); hold on
plot(1000*w((length(viscols)+1):end),c0new_mean((length(viscols)+1):end)./c0new_meanJul((length(viscols)+1):end),'-','color','k','linewidth',3)
plot(1000*w((length(viscols)+1):end),c0new_mean11MLO2((length(viscols)+1):end)./c0new_meanJul((length(viscols)+1):end),'--','color',[0.5 0.5 0.5],'linewidth',2)
set(gca,'fontsize',14); title('C0 NIR mean normalized to July mean'); xlabel('\lambda')
legend('MLO July 2016','MLO Nov 2016, avg of first half','MLO Nov 2016, avg of second half')
ylim([-inf 1.4])


figure; subplot(2,1,1);
plot(1000*w(1:length(viscols)),c0new_mean(1:length(viscols))./c0new_meanJul(1:length(viscols)),'-','color','k','linewidth',3); hold on
grid on
set(gca,'fontsize',14); title('ratio between C0 VIS mean (Nov 2016, final)/(July 2016, final)'); xlabel('\lambda')
% ylim([0 800]); 
xlim([100 1000]); ylim([0.9 1.1])
subplot(2,1,2)
plot(1000*w((length(viscols)+1):end),c0new_mean((length(viscols)+1):end)./c0new_meanJul((length(viscols)+1):end),'-','color','k','linewidth',3); hold on
grid on
set(gca,'fontsize',14); title('ratio between C0 NIR mean (Nov 2016, final)/(July 2016, final)'); xlabel('\lambda')

ylim([0.95 1.02])
oldSettings = fillPage(gcf,'margins',[0 0 0 0],'papersize',[14 9]);
starsas('MLOs2016_c0s_avgspectrum_MLOratios.fig')
print -dpdf MLOs2016_c0s_avgspectrum_MLOratios.pdf
