% See also ASAATSHiGEARAODclosure.m.
!!! SYNCHRONIZE THE CODES BELOW WITH aod2ang_comparepolyandlinear.m.

%********************
% get the data
%********************
% run the code for layer AOD closure
ASAATSHiGEARAODclosure;
higear.lambda=[450 550 700]/1000;

% calculate Angstrom exponents from AATS in multiple methods
a.angh=sca2angstrom(a.layeraodh, higear.lambda);
% cc=[3 7];
% a.angmidvisible=sca2angstrom(a.layeraod(:,cc), aats.lambda(:,cc));
cc=[3:7]; % [3 5 7]
sca=a.layeraod(:,cc);
a.angmidvisible_linear=repmat(NaN,size(sca,1),1);
for i=1:size(sca,1);
    okcc=find(isfinite(sca(i,:))==1 & sca(i,:)>0);
%     if ~isempty(ok);
    if length(okcc)==length(cc);
        b=regress(log(sca(i,okcc))',[log(aats.lambda(cc(okcc)))' ones(size(cc(okcc)))'], 0.05);
        a.angmidvisible_linear(i)=-b(1);
    end;
end;
a.ang=-2.*a.layera210(:,1)*log(aats.lambda)-repmat(a.layera210(:,2),size(aats.lambda));
a.anghp=-2.*a.layera210(:,1)*log(higear.lambda)-repmat(a.layera210(:,2),size(higear.lambda));

% calculate Angstrom exponents from HiGEAR 
higear.ang=sca2angstrom(higear.layeraod, higear.lambda);
higear.angBG=sca2angstrom(higear.layeraod(:,1:2), higear.lambda(1:2));
higear.layerdryaodsmf500=higear.layerdryaodsmf(:,1)+(higear.layerdryaodsmf(:,1)-higear.layerdryaodsmf(:,2))./(log10(higear.lambda(1))-log10(higear.lambda(2))).*(log10(0.5)-log10(higear.lambda(1)));
higear.layerdryssa=(higear.layerdryaod-higear.layerabsaod)./higear.layerdryaod;
higear.layerambssa=(higear.layeraod-higear.layerabsaod)./higear.layeraod;

% distinguish profiles in and out of the 3%+0.02 bounds
okin=find(higear.layeraod(ok,2)>=a.layeraodh(ok,2)/sl-co & higear.layeraod(ok,2)<=a.layeraodh(ok,2)*sl+co);
okin=ok(okin);
okout=find(higear.layeraod(ok,2)<a.layeraodh(ok,2)/sl-co | higear.layeraod(ok,2)>a.layeraodh(ok,2)*sl+co);
okout=ok(okout);

% data from ASAeronetcomparison.m
% ofmfall=[    0.5084    0.6861    0.8155    0.6543    0.5372
%     0.4967    0.6198    0.9090    0.7803    0.6491
%     0.6595    0.7047    0.8967    0.8043    0.6813
%     0.9174    0.8069    0.9473    0.8991    0.8185
%     0.8356    0.7714    0.9446    0.8984    0.7285];
norminput=[0.855741528	0.518937868
0.701517269	0.554098208
0.725502452	0.659466179
0.918104923	0.908230666
0.835064618	0.83540416]; % input from Norm's updated calculation AATSlayerAOD_2008.xls.
higearaeronet.layerdryaodsmf=ofmfall(:,3:5);
higearaeronet.layerdryaodsmf500=higearaeronet.layerdryaodsmf(:,1)+(higearaeronet.layerdryaodsmf(:,1)-higearaeronet.layerdryaodsmf(:,2))./(log10(higear.lambda(1))-log10(higear.lambda(2))).*(log10(0.5)-log10(higear.lambda(1)));
aatsaeronet.fmf500=ofmfall(:,2);
aatsaeronet.fmf500=norminput(:,1);
aeronet.fmf=ofmfall(:,1);
aeronet.fmf=norminput(:,2);

%********************
% plot
%********************
% compare them
figure;
markersize=a.layeraod(:,5)*1000;
markersize(find(markersize<1 | isfinite(markersize)==0))=1;
scatter(a.angh(ok), higear.ang(ok), markersize(ok), log10(higear.ratio2aats(ok,2)), 'filled');
axis tight;
ax=axis;
xl=[floor(min(ax)/0.1)*0.1 ceil(max(ax)/0.1)*0.1 ];
axis([xl xl]);
hold on;
plot(xl, xl, '-k');
grid on;
ch=colorbar;

% compare linear fit and second order polinomial
figure;
[b,bint,r,rint,stats]=regress(a.angmidvisible_linear(ok), [a.ang(ok,5) ones(size(ok))],0.05);
rms=sqrt(nanmean((a.angmidvisible_linear(ok)-a.ang(ok,5)).^2));
ph=plot(a.ang(ok,5), a.angmidvisible_linear(ok), '.', ...
    [-10 10], [-10 10]*b(1)+b(2), '-');
axis([-1 3.3 -1 3]);
grid;
ggla;
legend(ph(2),['y=' num2str(b(1),'%0.2f') '+' num2str(b(2),'%0.2f') ', R^2=' num2str(stats(1),'%0.2f') ', rms = ' num2str(rms, '%0.2f')]);
xlabel('Angstrom at 519 nm from second-order polinomial fit')
ylabel('Angstrom from Linear Fit over 451 - 675 nm');

% an x-y comparison of AATS-14 (from polynomial) and HiGEAR Angstrom
figure;
xl=[0 2.5];
shin=scatter(a.anghp(okin,2), higear.ang(okin), 96, ones(size(okin)), 'filled');
hold on;
shout=scatter(a.anghp(okout,2), higear.ang(okout), 48, ones(size(okout)));
set(shout, 'linewidth',2);
ggla;
grid on;
plot(xl, xl, '-k');
xlabel([char(197) ' of AATS-14 Layer AOD or Full-column AERONET AOD']);
% xlabel('AATS-14 Layer AOD Angstrom Exponent');
ylabel([char(197) ' of In situ Derived Layer AOD']);
set(shin, 'markeredgecolor','k','markerfacecolor','k');
set(shout, 'markeredgecolor','k');
axis([xl xl]);
% ylim([0 1.02]);
[lh,objh,outh,outm]=legend([shin(1) shout(1)], ['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
set(lh,'fontsize',12);
ASsas(['ASAATSHiGEARAODAngstromComp' num2str(errorbarsver) '.fig, ASAATSHiGEARAODAngstromClosure.m']);

% % % % an x-y comparison of AATS-14 and HiGEAR Angstrom
% % % figure;
% % % shin=scatter(a.angh(okin), higear.ang(okin), 96, ones(size(okin)), 'filled');
% % % hold on;
% % % shout=scatter(a.angh(okout), higear.ang(okout), 48, ones(size(okout)));
% % % set(shout, 'linewidth',2);
% % % ggla;
% % % grid on;
% % % plot(xlim , xlim, '-k');
% % % xlabel('AATS-14 Layer AOD Angstrom Exponent');
% % % ylabel('In situ Derived Layer AOD Angstrom Exponent');
% % % set(shin, 'markeredgecolor','k','markerfacecolor','k');
% % % set(shout, 'markeredgecolor','k');
% % % [lh,objh,outh,outm]=legend([shin(1) shout(1)], ['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',3);
% % % ASsas('ASAATSHiGEARAODAngstromComp.fig, ASAATSHiGEARAODAngstromClosure.m');

% HiGEAR column Angstrom vs. HiGEAR SMF, for the ok vertical profiles
figure;
xl=[0 2.5];
% shin=scatter(a.anghp(okin,2), higear.layerdryaodsmf500(okin), 96, ones(size(okin)), 'filled');
shin=scatter(higear.ang(okin), higear.layerdryaodsmf500(okin), 96, ones(size(okin)), 'filled');
hold on;
% shout=scatter(a.anghp(okout,2), higear.layerdryaodsmf500(okout), 48, ones(size(okout)));
shout=scatter(higear.ang(okout), higear.layerdryaodsmf500(okout), 96, ones(size(okout)));
ph=plot(a.anghp(okin,2),a.layeraodfmf500(okin),'ob',a.anghp(okout,2),a.layeraodfmf500(okout),'ob');
set(ph(1),'markerfacecolor','b');
set(shout, 'linewidth',1,'marker','h');
set(shin,'marker','h');
ggla;
grid on;
xlabel([char(197) ' of Layer AOD']);
ylabel('Fine-Mode or Submicron-Mode Fraction');
set(shin, 'markeredgecolor','k','markerfacecolor','k');
set(shout, 'markeredgecolor','k');
axis([xl 0 1.2]);
xl2=0:0.1:3;
plot(xl2, 0.0075*xl2.^2+0.3106*xl2+0.2244, '-r', ...
    xl2, 0.0814*xl2.^2+0.1203*xl2+0.3497, '-r', ...
    xl2,-0.0512*xl2.^2+0.5089*xl2+0.02, '-g');
[lh,objh,outh,outm]=legend([ph(1) ph(2) shin(1) shout(1)], ['AATS-14, AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'AATS-14, Outlier',['In situ, AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'In situ, Outlier',4);
ASsas(['ASHiGEARAODAngstromSMF' num2str(errorbarsver) '.fig, ASAATSHiGEARAODAngstromClosure.m']);

% difference (using polynomial)
figure;
xx=a.layeraodh(:,2); % used to be a.layeraod(:,4), a.layeraod(:,5)
okin=flipud(okin);
okout=flipud(okout);
shin=scatter(xx(okin), higear.ang(okin)-a.anghp(okin,2), 96, a.anghp(okin,2), 'filled');
hold on;
shout=scatter(xx(okout), higear.ang(okout)-a.anghp(okout,2), 48, a.anghp(okout,2));
phin=plot(NaN,NaN,'.','markersize',sqrt(96)*2,'markeredgecolor','k','markerfacecolor','k');
phout=plot(NaN,NaN,'o','markersize',sqrt(48),'markeredgecolor','k','linewidth',2);
set(shout, 'linewidth',2);
ggla;
grid on;
set(gca,'xscale','log');
xlim([0.001 3]);
plot(xlim , [0 0], '-k');
xlabel(['AATS-14 Layer AOD at 550 nm']);
ylabel('In situ-AATS Difference in Angstrom');
caxis([1 2]);
ch=colorbar;
yl=get(ch,'ylabel');
[lh,objh,outh,outm]=legend([phin phout], ['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
set(ch,'linewidth',1,'fontsize',16);
set(yl,'string', 'AATS-14 Modified Angstrom Exponent at 550 nm','fontsize',16);
ASsas(['ASAATSHiGEARAODAngstromClosure550nm' num2str(errorbarsver) '.fig, ASAATSHiGEARAODAngstromClosure.m']);

% difference
figure;
xx=a.layeraodh(:,2); % used to be a.layeraod(:,4), a.layeraod(:,5)
okin=flipud(okin);
okout=flipud(okout);
shin=scatter(xx(okin), higear.ang(okin)-a.angh(okin), 96, a.angh(okin), 'filled');
hold on;
shout=scatter(xx(okout), higear.ang(okout)-a.angh(okout), 48, a.angh(okout));
phin=plot(NaN,NaN,'.','markersize',sqrt(96)*2,'markeredgecolor','k','markerfacecolor','k');
phout=plot(NaN,NaN,'o','markersize',sqrt(48),'markeredgecolor','k','linewidth',2);
set(shout, 'linewidth',2);
ggla;
grid on;
set(gca,'xscale','log');
xlim([0.005 3.05]);
plot(xlim , [0 0], '-k');
xlabel(['AATS-14 Layer AOD at 550 nm']);
ylabel('HiGEAR-AATS Difference in Angstrom_{450 - 700 nm}');
caxis([1 2]);
ch=colorbar;
yl=get(ch,'ylabel');
[lh,objh,outh,outm]=legend([phin phout], ['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
set(ch,'linewidth',1,'fontsize',16);
set(yl,'string', 'AATS-14 Angstrom_{450-700nm}','fontsize',16);
ASsas(['ASAATSHiGEARAODAngstromClosure' num2str(aats.lambda(wl)*1000) 'nm.fig, ASAATSHiGEARAODAngstromClosure.m']);

% estimate the error in extrapolating to short wavelengths
higear.layeraod354=higear.layeraod(:,1).*(450/354).^higear.ang;
higear.layeraod354BG=higear.layeraod(:,1).*(450/354).^higear.angBG;
figure;
xl=[1e-4 10];
sl=1.03;co=0.02;
xlxx=10.^(log10(xl(1)):0.1:log10(xl(2)));
loglog(a.layeraod(ok,1), higear.layeraod354(ok), '.',...
    xl,xl,'-k', ...
    xlxx, xlxx*sl+co, '--k', ...
    xlxx, xlxx/sl-co, '--k', ...
    'markersize',24);
%     a.layeraod(:,1), higear.layeraod354BG, 'r.',...
ggla;
grid on;
axis([xl xl]);
xlabel('AATS Layer AOD measured at 354 nm');
ylabel('HiGEAR Layer AOD extrapolated to 354 nm');
ASsas('ASAATSHiGEARAOD354nmClosure.fig, ASAATSHiGEARAODAngstromClosure.m');

% determine the degree of agreement 
% sl=1.25;co=0.02;
upperb=[a.layeraod(ok,1)*sl+co];
lowerb=[a.layeraod(ok,1)/sl-co];
% lowerb=a.layeraodh(ok,1).*(2-sl)-co;
uppsa=upperb-higear.layeraod354(ok,:);
lowsa=higear.layeraod354(ok,:)-lowerb;
ok2=find(uppsa>=0 & lowsa>=0);
ng2=find(uppsa<0 | lowsa<0);
length(ok2)
disp([num2str(round(length(ok2)/(size(ok,1))*1000)/10) ' percent of the ' num2str(size(ok,1)) ' HiGEAR AOD agree within ' num2str((sl-1)*100) ' percent +/- ' num2str(co) ' of AATS AOD.']);
% % % hold on;

% AATS-14 Fine-mode fraction vs. HiGEAR Submicron-mode fraction
% figure;
% plot(higear.layerdryaodsmf500(ok), a.layeraodfmf500(ok),'.', ...
%     [0 1],[0 1], '-k', ...
%     'markersize',12);
% ggla;
% grid on;
% xlabel('HiGEAR Layer Submicron-Mode Fraction');
% ylabel('AATS-14 Layer Fine-Mode Fraction');
% legend('500 nm',0);
% ASsas('ASAATSLayerFMFHiGEARLayerSMF.fig, ASAATSHiGEARAODAngstromClosure.m');
% figure;
% plot(a.layeraodfmfh(ok,1),higear.layerdryaodsmf(ok,1), '.b', ...
%     a.layeraodfmfh(ok,2),higear.layerdryaodsmf(ok,2), '.g', ...
%     a.layeraodfmfh(ok,3),higear.layerdryaodsmf(ok,3), '.r', ...
%     [0 1],[0 1], '-k', ...
%     'markersize',12);
% ggla;
% grid on;
% xlabel('AATS-14 Layer Fine-Mode Fraction');
% ylabel('HiGEAR Layer Submicron-Mode Fraction');
% legend('450 nm','550 nm','700 nm',0);
% 
% % AATS-14 Fine-mode fraction vs. HiGEAR Submicron-mode fraction, sized by
% % AOD
% figure;
% legendstr={};xstr='';
% % for i=2:3;
% for i=1;
%     yy=higear.layerdryaodsmf500;
%     yystr='HiGEAR Layer Submicron-Mode Fraction';
%     ss=higear.layeraod(:,2)*1000;
%     ssstr='HiGEAR layer AOD at 550 nm';
%     %     ss=a.layeraod(:,4)*1000;
%     %     ssstr='AATS-14 layer AOD at 499 nm';
%     cc=ones(size(higear.layeraod,1),1);
%     ccstr='';
%     cc=higear.layerdryssa;
%     ccstr='layer dry SSA';
%     cc=a.layeraodAf500;
%     ccstr='Af';
%     if i==1;
%         xx=a.layeraodfmf500;
%         xl='AATS-14 or AERONET Fine-Mode Fraction at 500 nm';
%         xs='AATSLayerFMF';
%         clr='b';
%         marker='o';
%         plot([0 1.2],[0 1.2], '-k');
%         cc=ones(size(higear.layeraod,1),1);
%         ccstr='';
%     elseif i==2;
%         xx=a.layeraodAng500;
%         xl='AATS-14 Layer Angstrom Exponent at 500 nm';
%         xs='AATSLayerAng';
%         clr='b';
%         marker='o';
%     elseif i==3;
%         xx=higear.ang;
%         xl='HiGEAR Layer Angstrom Exponent';
%         xs='HiGEARLayerAng';
%         clr='k';
%         marker='h';
%     end;
%     hold on;
%     shout(i)=scattery(xx(okout), '', ...
%         yy(okout), yystr, ...
%         ss(okout), ssstr, ...
%         cc(okout), ccstr);
%     shin(i)=scattery(xx(okin), '', ...
%         yy(okin), yystr, ...
%         ss(okin), ssstr, ...
%         cc(okin), ccstr);
%     if length(unique(cc))==1;
%         set([shout(i) shin(i)],'markeredgecolor',clr,'marker',marker);
%         set(shin(i), 'markerfacecolor', clr);
%     end;
%     xstr=[xstr xs];
% %     legendstr=[legendstr {xl} {[xl ', layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')']}];
%     legendstr=[legendstr {xl} {[xl ', layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')']}];
% %     if i==1;
% %         hold on;
% %         plot(ofmfall(:,1), ofmfall(:,4), 'sr','linewidth',2);
% %         legendstr=[legendstr {'AERONET'}];
% %     end;
% end;
% ggla;
% grid on;
% xlabel(xl);
% shs=[shout' shin']';
% if i==1;
%     lh=legend(shs([2 1]),['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
% else
%     lh=legend(shs(:),legendstr,4);
% end;
% % lh=legend([shout shin],'500 nm',['500 nm, layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],0);
% set(lh,'fontsize',8);    
% axis tight
% ASsas(['AS' xstr 'HiGEARLayerSMFsizedAOD.fig, ASAATSHiGEARAODAngstromClosure.m']);

% AATS-14 Fine-mode fraction vs. HiGEAR Submicron-mode fraction
% [a2,a1,a0,ang,curvature]=polyfitaod(aats.lambda(9:13),a.layeraod(:,9:13));

figure;
legendstr={};xstr='';
yy=higear.layerdryaodsmf500;
yystr='HiGEAR Layer Submicron-Mode Fraction';
xx=a.layeraodfmf500(:);
% xx=a.layeraodfmf500subtr(:);
xl='AATS-14 Layer Fine-Mode Fraction at 500 nm';
xs='AATSLayerFMF';
clr='k';
marker='o';
plot([0 1.200001],[0 1.200001], '-k');
ss=repmat(48, size(xx));
ssstr='';
% ss=a.layeraod(:,4)*1000;
% ssstr='AATS Layer AOD at 499 nm';
cc=ones(size(higear.layeraod,1),1);
ccstr='';
% cc=ang(:,end);
% ccstr='Ang at 2.1 um';
cc=a.layeraod(:,13)./a.layeraod(:,4);
ccstr='Layer AOD Ratio, 2139 nm / 499 nm';
cc=a.layeraod(:,10)./a.layeraod(:,4);
cc(find(a.layeraod(:,10)<0.04))=NaN;
okout2=okout(find(a.layeraod(okout,10)<0.04));
okin2=okin(find(a.layeraod(okin,10)<0.04));
ccstr='Layer AOD Ratio, 1019 nm / 499 nm';
cax=[0 0.5];
% cc=higear.layerdryssa(:,2);
% cc=a.ang(:,13)-a.ang(:,4);
% ccstr='Layer AOD Ang Diff, 2139 nm - 499 nm';
% cax=[0 0.5];
% cc=a.ang(:,4);
% ccstr='Ang at 0.499 um';
% cax=[1 2];
hold on;
shout2(i)=plot(xx(okout2), yy(okout2), 'o', ...
    'color', [.5 .5 .5], 'linewidth',2,'markersize',7);
shin2(i)=plot(xx(okin2), yy(okin2), '.', ...
    'color', [.5 .5 .5], 'linewidth',2,'markersize',29);
shout(i)=scattery(xx(okout), '', ...
    yy(okout), yystr, ...
    repmat(48,size(okout)), ssstr, ...
    cc(okout), ccstr, ...
    'marker','o');
shin(i)=scattery(xx(okin), '', ...
    yy(okin), yystr, ...
    repmat(96,size(okin)), ssstr, ...
    cc(okin), ccstr, ...
    'marker','filled');
shsdu(1)=scattery(xx(okout(1)), '',yy(okout(1)), '',48,'', 1,'', 'marker','o');
shsdu(2)=scattery(xx(okin(1)), '',yy(okin(1)), '',48,'', 1,'', 'marker','filled');
set(shsdu(2),'markerfacecolor','k');
set(shsdu,'visible','off');
if isempty(ccstr);
    set([shout(i) shin(i)],'markeredgecolor',clr,'marker',marker,'markerfacecolor','none');
    set(shin(i), 'markerfacecolor', clr);
else
    caxis(cax);
    colorbarlabeled(ccstr);
end;
xstr=[xstr xs];
%     legendstr=[legendstr {xl} {[xl ', layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')']}];
legendstr=[legendstr {xl} {[xl ', layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')']}];
ggla;
grid on;
xlabel(xl);
shs=[shout' shin']';
if i==1;
%     lh=legend(shsdu([2 1]),['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
    lh=legend(shsdu([2 1]),['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
else
%     lh=legend(shsdu(:),legendstr,4);
end;
% lh=legend([shout shin],'500 nm',['500 nm, layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],0);
% set(lh,'fontsize',8);
axis tight
if exist('higearaeronet')
    hold on;
    plot(aeronet.fmf, higearaeronet.layerdryaodsmf500, 'sr','linewidth',2);
    legendstr=[legendstr {'AERONET'}];
end;
ylabel('In situ Derived Layer Submicron-Mode Fraction');
disp(['RMS = ' num2str(sqrt(mean((xx(okin)-yy(okin)).^2)))]);
ASsas(['AS' xstr 'HiGEARLayerSMFcolor' num2str(errorbarsver) 'b.fig, ASAATSHiGEARAODAngstromClosure.m']);


% difference (SMF-FMF)
figure;
xx=a.layeraodh(:,2); % used to be a.layeraod(:,4), a.layeraod(:,5)
sa=higear.layerdryaodsmf500-a.layeraodfmf500(:);
% sa=higear.layerdryaodsmf500-a.layeraodfmf500subtr(:);
cc=a.layeraodfmf500;
cc=higear.layerdryssa(:,2);
cc=higear.layerambssa(:,2);
ccstr='Column SSA at 550 nm';
okin=flipud(okin);
okout=flipud(okout);
shin=scatter(xx(okin), sa(okin), 96, cc(okin), 'filled');
hold on;
shout=scatter(xx(okout), sa(okout), 48, cc(okout));
phin=plot(NaN,NaN,'.','markersize',sqrt(96)*2,'markeredgecolor','k','markerfacecolor','k');
phout=plot(NaN,NaN,'o','markersize',sqrt(48),'markeredgecolor','k','linewidth',2);
set(shout, 'linewidth',2);
ggla;
grid on;
set(gca,'xscale','log');
xlim([0.001 3]);
plot(xlim , [0 0], '-k');
xlabel(['AATS-14 Layer AOD at 550 nm']);
ylabel('In situ SMF - AATS FMF');
% caxis([0.5 1]);
% ch=colorbar;
% yl=get(ch,'ylabel');
ch=colorbarlabeled(ccstr);
[lh,objh,outh,outm]=legend([phin phout], ['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',0);
% set(ch,'linewidth',1,'fontsize',16);
% set(yl,'string', 'AATS-14 Layer Fine-Mode Fraction at 500 nm','fontsize',16);
ASsas(['ASAATSHiGEARAODSMFFMFComparison550nm' num2str(errorbarsver) formalizefieldname(ccstr) '.fig, ASAATSHiGEARAODAngstromClosure.m']);

% Add AERONET (after running ASAeronetcomparison)
% higear.layerdryaodsmf=layerdryaodsmfall
% higear.layerdryaodsmf500=higear.layerdryaodsmf(:,1)+(higear.layerdryaodsmf(:,1)-higear.layerdryaodsmf(:,2))./(log10(higear.lambda(1))-log10(higear.lambda(2))).*(log10(0.5)-log10(higear.lambda(1)));
% figure;plot(ofmfall(:,1),higear.layerdryaodsmf500(:,1),'sr','linewidth',2)

% AATS-14 Fine-mode fraction vs. HiGEAR Submicron-mode fraction
figure;
legendstr={};xstr='';
yy=higear.layerdryaodsmf500;
yystr='HiGEAR Layer Submicron-Mode Fraction';
xx=a.layeraod(:,4);
xxstr='AATS-14 Layer AOD at 499.4 nm';
xs='AATSLayerFMF';
clr='k';
marker='o';
cc=ones(size(higear.layeraod,1),1);
ccstr='';
shout(i)=scattery(xx(okout), xxstr, ...
    yy(okout)-xx(okout), yystr, ...
    repmat(48, size(okout)), '', ...
    cc(okout), ccstr);
hold on;
shin(i)=scattery(xx(okin), xxstr, ...
    yy(okin)-xx(okin), yystr, ...
    repmat(48, size(okin)), '', ...
    cc(okin), ccstr);
ylabel('HiGEAR SMF - AATS-14 FMF');
set([shout(i) shin(i)],'markeredgecolor',clr,'marker',marker,'markerfacecolor','none');
set(shin(i), 'markerfacecolor', clr);
xstr=[xstr xs];
%     legendstr=[legendstr {xl} {[xl ', layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')']}];
legendstr=[legendstr {xl} {[xl ', layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')']}];
ggla;
grid on;
xlabel(xl);
shs=[shout' shin']';
if i==1;
    lh=legend(shs([2 1]),['AOD_{550nm} within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],'Outlier',4);
else
    lh=legend(shs(:),legendstr,4);
end;
% lh=legend([shout shin],'500 nm',['500 nm, layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],0);
set(lh,'fontsize',8);
axis tight
ASsas(['AS' xstr 'HiGEARLayerSMFdiffAOD.fig, ASAATSHiGEARAODAngstromClosure.m']);

% figure;
% for w=1:3;
%     sh(w)=scattery(a.layeraodfmfh(okout,w), '', ...
%         higear.layerdryaodsmf(okout,w), '', ...
%         a.layeraodh(okout,w)*1000, 'AOD', ...
%         ones(size(okout)), '');
%     hold on;
%     sh2(w)=scattery(a.layeraodfmfh(okin,w), '', ...
%         higear.layerdryaodsmf(okin,w), '', ...
%         a.layeraodh(okin,w)*1000, 'AOD', ...
%         ones(size(okin)), '');
% end;
% set([sh(1) sh2(1)],'markeredgecolor','b');
% set([sh(2) sh2(2)],'markeredgecolor','g');
% set([sh(3) sh2(3)],'markeredgecolor','r');
% set(sh2(1), 'markerfacecolor', 'b');
% set(sh2(2), 'markerfacecolor', 'g');
% set(sh2(3), 'markerfacecolor', 'r');
% plot([0 1],[0 1], '-k');
% ggla;
% grid on;
% xlabel('AATS-14 Layer Fine-Mode Fraction');
% ylabel('HiGEAR Layer Submicron-Mode Fraction');
% lh=legend([sh sh2],'450 nm','550 nm','700 nm',['450 nm, layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],['550 nm, layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],['700 nm, layer AOD agree within \pm(' num2str((sl-1)*100) '%+' num2str(co) ')'],0);
% set(lh,'fontsize',8);
% axis tight

% Ang and Ang_fine
figure;
scattery(a.layeraodAng500, 'Ang', ...
    a.layeraodAf500, 'Af', ...
    a.layeraod(:,4)*1000,'layer AOD', ...
    a.layeraodfmf500, 'FMF');

figure;
scattery(a.layeraodAng500(okin), 'Ang', ...
    a.layeraodAf500(okin), 'Af', ...
    a.layeraod(okin,4)*1000,'layer AOD', ...
    higear.layerdryssa(okin), 'dry SSA', ...
    'clim',[0.9 1]);
for i=1:length(okin);
    th(i)=text(a.layeraodAng500(okin(i)), a.layeraodAf500(okin(i)), ...
        [num2str(a.layera210(okin(i),1)) ', ' num2str(a.layera210(okin(i),2)) ', ' num2str(a.layera210(okin(i),3))]);
end;
set(th,'fontsize',8);



% FMF and SSA550nm
figure;
shin=scattery(a.layeraodfmf500(okin), 'AATS-14 layer FMF',higear.layerdryssa(okin,2), 'HiGEAR Layer Dry SSA at 550 nm',higear.layerdryaod(okin)*1000, 'HiGEAR layer dry AOD')
set(shin,'markerfacecolor','k');
hold on
shout=scattery(a.layeraodfmf500(okout), 'AATS-14 layer FMF',higear.layerdryssa(okout,2), 'HiGEAR Layer Dry SSA at 550 nm',higear.layerdryaod(okout)*1000, 'HiGEAR layer dry AOD');
plot([1 1],ylim, '-k');
ASsas(['ASAATSLayerFMFHiGEARSSAsizedAOD.fig, ASAATSHiGEARAODAngstromClosure.m']);

% FMF and AAE
figure;
shin=scattery(a.layeraodfmf500(okin), 'AATS-14 layer FMF',higear.aang(okin), 'HiGEAR Angstrom_{abs}',higear.layerdryaod(okin)*1000, 'HiGEAR layer dry AOD')
set(shin,'markerfacecolor','k');
hold on
shout=scattery(a.layeraodfmf500(okout), 'AATS-14 layer FMF',higear.aang(okout), 'HiGEAR Angstrom_{abs}',higear.layerdryaod(okout)*1000, 'HiGEAR layer dry AOD');
plot([1 1],ylim, '-k');
ASsas(['ASAATSLayerFMFHiGEARAngAbssizedAOD.fig, ASAATSHiGEARAODAngstromClosure.m']);


% FMF, AAE and SSA550nm
figure;
shin=scattery(a.layeraodfmf500(okin), 'AATS-14 layer FMF',higear.aang(okin), 'HiGEAR Angstrom_{abs}',higear.layerdryaod(okin)*1000, 'HiGEAR layer dry AOD',higear.layerdryssa(okin,2), 'HiGEAR Layer Dry SSA at 550 nm')
gg=findobj(gca,'marker','o');
for i=1:length(gg);
    clr=get(gg(i),'markeredgecolor');
    set(gg(i),'markerfacecolor', clr);
end;
hold on
shout=scattery(a.layeraodfmf500(okout), 'AATS-14 layer FMF',higear.aang(okout), 'HiGEAR Angstrom_{abs}',higear.layerdryaod(okout)*1000, 'HiGEAR layer dry AOD',higear.layerdryssa(okout,2), 'HiGEAR Layer Dry SSA at 550 nm');
plot([1 1],ylim, '-k');
ASsas(['ASAATSLayerFMFHiGEARAngAbssizedAODcolorHiGEARdrySSA550nm.fig, ASAATSHiGEARAODAngstromClosure.m']);
