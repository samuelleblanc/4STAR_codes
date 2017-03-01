% For an older version of this code, see ASAATSHiGEARAODclosure_old.m.
% Yohei, 2009/01/14

%***************************************
% set parameters
%***************************************
% minimum altitude difference (m)
minaltdiff=1000; 
maxcov=Inf; % maximum coefficient of variation (std/mean)

% save plot
saveplot=0;

timesall=[];
for flightnumber=[2:14 16:25]; % flight 15 skipped; no AATS data due to clouds
    method=2;
    if method==1;
        [vtimes, valt, comment]=ASvertprofs(flightnumber, 'spiral');
    elseif method==2;
        [vtimes, valt, comment]=ASvertprofs(flightnumber);
        vtimesidx=sort([strmatch('spiral',comment); strmatch('hairpin',comment)]);
        vtimes=vtimes(vtimesidx,:);
        valt=valt(vtimesidx,:);
        comment=comment(vtimesidx,:);
    end;
    for i=1:size(vtimes,1);
        times=vtimes(i,:); % this is adjusted later to reflect the exact timings of the HiGEAR measurements.
        if times(1) > 191.736 & times(2) < 191.742
            times(1)=191.7385;
        elseif times(1)> 188.7716 & times(2) < 188.785
            times(1)=188.7722048611111;
        elseif times(1) < 97.9210 & times(2) > 97.9328
            times(2)=97.93159;
        end;
        timesall=[timesall;times];
    end;
end;
times=timesall;

%***************************************
% do the core calculation
%***************************************
AScalculateAATSHiGEARAOD;

%***************************************
% select rows
%***************************************
% ok=find(all(aod_b_cov<=maxcov,2)==1 ... % variability per mean at the lowest layer
%     & f.altdiff>=minaltdiff ... % altitude gain/loss
%     & isfinite(sum(aatsod,2))==1 & isfinite(sum(higearod,2))==1 ...
%     & higearod(:,2)./higeardryod(:,2)<10 ... % high f(RH)
%     & f.maxscaG<1000); % high scattering, like during [192.8937  192.9007]

ok=find(all(aod_b_cov<=maxcov,2)==1 ... % variability per mean at the lowest layer
    & f.altdiff>=minaltdiff ... % altitude gain/loss
    & isfinite(sum(a.layeraodh,2))==1 & isfinite(sum(higear.layeraod,2))==1 ...
    & f.maxscaG<1000); % high scattering, like during [192.8937  192.9007]

ok=find(all(aod_b_cov<=maxcov,2)==1 ... % variability per mean at the lowest layer
    & f.altdiff>=minaltdiff ... % altitude gain/loss
    & isfinite(sum(a.layeraodh,2))==1 & isfinite(sum(higear.layeraod,2))==1); 

ok=find(f.altdiff>=minaltdiff ... % altitude gain/loss
    & isfinite(sum(a.layeraodh,2))==1 & isfinite(sum(higear.layeraod,2))==1); 

%***************************************
% consistency check for debugging
%***************************************
if ~isempty(find(all(isfinite(higear.layeraod),2)==0 & f.higearnos>0))
    error('inconsistency in the HiGEAR data');
end;

%***************************************
% plot
%***************************************
sl=1.03;co=0.02;

xl=[0.005 5];
xl=[0.001 10];
ms1=24;
ms1=12;
ms2=12;
lw1=.5;
lw2=.5;
figure;
fig1=axes;
fig2=axes;
clear ph;
for w=1:3;
    xx=a.layeraodh(ok,w);
    yy=higear.layeraod(ok,w);
    if w==1;
        clr='b';
    elseif w==2;
        clr=[0 0.5 0];
        xxg=xx;
        yyg=yy;
    elseif w==3;
        clr='r';
    end;
    % AATS-14 instrument uncertainty
    xxe=a.layeraodh_unc(ok,w);
    %     xxe=sqrt(a.layeraodh_unc(ok,w).^2+ (aod_b_cov(ok,w).*xx).^2);
    %     xxe=sqrt(a.layeraodh_unc(ok,w).^2+aod_b_rms(ok,w).^2); !!! wrong!
    xxa=[xx+xxe xx-xxe xx]';
    xxa(find(xxa<xl(1)))=xl(1);
    xxa(3,:)=NaN;
    xxa=xxa(:);
    yya=repmat(yy,1,3)';
    yya=yya(:);
    % AATS-14 spatial variability
    %     xxe=aod_b_cov(ok,w);
%         xxe=horicovh(ok,w);
    %     xxs=[xx.*xxe xx./xxe xx]';
%     xxs=[xx.*(1+xxe) xx.*(1-xxe) xx]';
    xxs=[aod_low(ok,w) aod_upp(ok,w) xx]';
    xxs(find(xxs<xl(1)))=xl(1);
    xxs(3,:)=NaN;
    xxs=xxs(:);
    yys=yya*0.95;
    % HiGEAR instrument uncertainty
    xxh=repmat(xx,1,3)';
    xxh=xxh(:);
%     yyd=higear.layeraod_unc(ok,w);
%     yyh=[yy+yyd yy-yyd repmat(NaN,size(yy))]';
    yyh=[yy+higear.layeraod_unchi(ok,w) yy-higear.layeraod_unclo(ok,w) repmat(NaN,size(yy))]';
    yyh(find(yyh<xl(1)))=xl(1);
    yyh=yyh(:);
    axes(fig1);
    ph(:,w)=plot(xxa,yya, '-', ...
        xxh,yyh, '-', ...
        xxs,yys, '-', ...
        xx, yy, '.', ...
        'markeredgecolor', clr, 'color', clr, 'markersize', ms1, 'linewidth',lw1);
    set(ph(end-1), 'color',ones(1,3)*0.5,'visible','on');
    set(ph(end), 'marker','o','markersize',3,'linewidth',1);
    hold on;
    axis square;
    axes(fig2);
    ph2(:,w)=loglog(xx, higear.ratio2aats(ok,w), '.', ...
        'markeredgecolor', clr, 'color', clr, 'markersize', ms2, 'linewidth',lw2);
    hold on;
end;
for i=1:length(ok);
    axes(fig1);
    th(i)=text(xxg(i), yyg(i), num2str(times(ok(i),1)), 'fontsize',8, 'HorizontalAlignment','center');
    axes(fig2);
    %     th2(i)=text(xxg(i), yyg(i)./xxg(i), num2str(alltimes(ok(i),1)), 'fontsize',8, 'HorizontalAlignment','center');
end;
axes(fig1);
ggla;
% grid on;
axis([xl xl]);
if xl(1)>0;
    set(gca,'xscale','log','yscale','log');
end;
yt=get(gca,'ytick')*1.000000001;
yt(end)=yt(end)*0.999999;
% set(gca,'ytick',yt,'yticklabel',num2str(yt'));
set(gca,'ytick',yt,'yticklabelmode','auto');
xt=get(gca,'xtick');
xt=yt;
set(gca,'xtick',xt,'xticklabel',strtrim(num2str(xt')));
set(gca,'xtick',xt*1.00000000001,'xticklabelmode','auto');
% if min(min(higear.layeraod(ok,:)))>0.005;
%     ylim([0.005 xl(2)]);
% end;
xlabel('AATS-14 Layer AOD');
ylabel('In situ (Neph+PSAP) Derived Layer AOD');
lh=legend(ph(end,:), '450 nm','550 nm','700 nm');
set(lh,'color','w');
% pos=get(lh,'position');
% set(lh,'position',[0.45 0.75 pos(3:4)]);
axes(fig2);
% ggla;
grid on;
yl2=[0.01 100];
if min(min(higear.ratio2aats(ok,:)))>0.1 & max(max(higear.ratio2aats(ok,:)))<50;
    yl2=[0.1 50];
end;
axis([xl yl2]);
% yt=[yl2(1):0.1:1  2:yl2(2)];
xt=[0.001 0.01 0.1 1 10];
xtl={'0.001' '' '0.1' '' '10'};
% set(gca,'xtick', xt, 'ytick',yt, 'yticklabel', num2str(yt'));
pos2=[0.65-0.45 0.23+0.43 0.25-0.05 0.3-0.1];
pos2=[0.66 0.23 0.14 0.2];
set(fig2,'position' ,pos2, ...
    'xcolor',[.5 .5 .5], ...
    'ycolor',[.5 .5 .5], ...
    'xtick',xt, 'xticklabel',xtl, ...
    'color','w','fontsize',10);
xlabel('AATS Layer AOD');
ylabel('In-situ/AATS Ratio','VerticalAlignment','middle');
chi=get(gcf,'children');
set(gcf,'children',flipud(chi));
axes(fig1);
xlxx=10.^(log10(xl(1)):0.1:log10(xl(2)));
plot(xlxx, xlxx, '-k', ...
    xlxx, xlxx*sl+co, '--k', ...
    xlxx, xlxx/sl-co, '--k')
axes(fig2);
xt=10.^[-3:3];set(gca,'xtick',xt,'xticklabel',num2str(xt'));
yt=unique(sort([xt yl2]));set(gca,'ytick',yt,'yticklabel',num2str(yt'));
plot(xlxx, ones(size(xlxx)), '-k', ...
    xlxx, (xlxx*sl+co)./xlxx, '--k', ...
    xlxx, (xlxx/sl-co)./xlxx, '--k')
set(th,'visible','off');
set(gca,'ytick',yt,'yticklabel',num2str(yt'));
set(lh,'position', [0.23 0.7638 0.1074 0.1429]);
% set(lh,'position', [0.62 0.1638 0.1074 0.1429]);
chi=get(gcf,'children');
set(gcf,'children',chi([3 1 2]));
    logax=axis;
    hi=[logax(2)-logax(1) logax(4)-logax(3)];
    set(lh,'position', [0.28 0.7638 0.0874 0.1429]);
%     set(gca,'position',pos+[0-0.25 0 -0.755+0.773/hi(2)*hi(1) 0])
errorbarsver=14;
if saveplot==1;
    ASsas(['ASAATSHiGEARAODclosure_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'errorbarsver' num2str(errorbarsver) '.fig, ASAATSHiGEARAODclosure.m']);
end;

axes(fig1);
axis normal;
axis([0.001 2.5 0.003 2.2]);
set(gca,'position',[0.15 0.15 .6 0.773]);
set(lh,'position',[0.5647    0.1653    0.1704    0.1516]);
if saveplot==1;
    ASsas(['ASAATSHiGEARAODclosure_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'errorbarsver' num2str(errorbarsver) '_expanded.fig, ASAATSHiGEARAODclosure.m']);
end;

% ratio
w=2; % 550 nm only
clr=[0 0.5 0];
figure;
xx=a.layeraodh(ok,w);
yy=higear.ratio2aats(ok,w);
% AATS-14 spatial variability
xxe=aod_b_cov(ok,w);
xxe=horicovh(ok,w);
xxs=[xx.*(1+xxe) xx.*(1-xxe) xx]';
xxs(find(xxs<xl(1)))=xl(1);
xxs(3,:)=NaN;
xxs=xxs(:);
yys=repmat(yy,1,3)';
yys=yys(:);
xxeok=find(isfinite(xxe)==1);
xxeng=find(isfinite(xxe)==0);
ph2r=loglog(xxs,yys,'-', ...
    xx(xxeng), yy(xxeng), '.', ...
    xx(xxeok), yy(xxeok), 'o', ...
    'markeredgecolor', clr, 'color', clr, 'markersize', 6, 'linewidth',1);
set(ph2r(2), 'markeredgecolor',ones(1,3)*0.5);
% set(ph2r(3), 'markersize',6,'linewidth',2);
hold on;
!!! to be worked out
herrorbar(xx(xxeok), yy(xxeok), xx(xxeok).*xxe(xxeok));
set(gca,'xscale','log','yscale','log')
!!!
plot(xlxx, ones(size(xlxx)), '-k', ...
    xlxx, (xlxx*sl+co)./xlxx, '--k', ...
    xlxx, (xlxx/sl-co)./xlxx, '--k')
xlim([0.001 3])
set(gca,'xtick',[0.001000001 0.01000001 0.10000001 1.000001 2.9999999]);
ggla;
xlabel('AATS-14 Layer AOD');
ylabel('Layer AOD Ratio, In situ / AATS-14');
if saveplot==1;
    ASsas(['ASAATSHiGEARAODclosure_altallowance' num2str(altallowance) 'method' num2str(method) 'errorbarsver' num2str(errorbarsver) 'aodratio.fig, ASAATSHiGEARAODclosure.m']);
end;

for kk=1:2;
    figure;
    if kk==1;
        b=higear.layeraod_unchi;
        yl='Instrument Upper Uncertainty at 550 nm';
    elseif kk==2;
        b=higear.layeraod_unclo;
        yl='Instrument Lower Uncertainty at 550 nm';
    end;
    llh=loglog(a.layeraodh(:,2), a.layeraodh_unc(:,2), 'o', ...
        a.layeraodh(:,2), b(:,2), 'h', ...
        a.layeraodh(:,2), sqrt(a.layeraodh_unc(:,2).^2+b(:,2).^2), '.');
    set(llh(1:2), 'markersize',3);
    set(llh(3), 'markersize',24);
    hold on;
    xl=xlim;
    slcolist=[0.03 0.02; 0.17 0.01; 0.49 0];
    for i=1:size(slcolist,1);
        plot(xl, slcolist(i,1)*xl+slcolist(i,2), '--');
        text(xl(1)*1.1, slcolist(i,1)*xl(1)*1.15+slcolist(i,2), [num2str(slcolist(i,1)) '*x+' num2str(slcolist(i,2))]);
    end;
    ylabel(yl);
    ggla;
    xlabel('AATS-14 Layer AOD interpolated to 550 nm');
    legend('AATS-14 Layer AOD','In situ Layer AOD', 'Root sum square of the above');
    if saveplot==1;
        if kk==1
            ASsas(['ASAATSHiGEARAODinstrumentupperunc_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'errorbarsver' num2str(errorbarsver) '.fig, ASAATSHiGEARAODclosure.m']);
        elseif kk==2;
            ASsas(['ASAATSHiGEARAODinstrumentlowerunc_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'errorbarsver' num2str(errorbarsver) '.fig, ASAATSHiGEARAODclosure.m']);
        end;
    end;
end;
% axes(fig1);
% ssp(2,2,1);
% set(th,'visible','off');
% gg=findobj(gca,'marker','.');
% set(gg,'markersize',12);
% ggla
% yla=get(gca,'ylabel');set(yla,'verticalalignment','cap')
% set(gca,'xtick',10.^[-4:1]);xt=get(gca,'xtick');set(gca,'xticklabel',num2str(xt'));
% set(gca,'ytick',10.^[-4:1]);yt=get(gca,'ytick');set(gca,'yticklabel',num2str(yt'));
% axes(fig2);
% gg=findobj(gca,'marker','.');
% set(gg,'markersize',12);
% ssp(2,2,2);
% ggla;
% yla=get(gca,'ylabel');set(yla,'verticalalignment','cap')
% lh=findobj(gcf,'tag','legend');
% set(lh,'location','southeast','fontsize',10);
% set(gca,'xcolor','k','ycolor','k');
% ASsas(['ASAATSHiGEARAODclosure_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'mini.fig, ASAATSHiGEARAODclosure.m']);

% determine the degree of agreement 
sl=1.03;co=0.02;
upperb=[a.layeraodh(ok,:)*sl+co];
lowerb=[a.layeraodh(ok,:)/sl-co];
lowerb=a.layeraodh(ok,:).*(2-sl)-co;
uppsa=upperb-higear.layeraod(ok,:);
lowsa=higear.layeraod(ok,:)-lowerb;
ok2=find(uppsa>=0 & lowsa>=0);
ng2=find(uppsa<0 | lowsa<0);
length(ok2)
disp([num2str(round(length(ok2)/(3*size(ok,1))*1000)/10) ' percent of the ' num2str(size(ok,1)) ' HiGEAR AOD agree within ' num2str((sl-1)*100) ' percent +/- ' num2str(co) ' of AATS AOD.']);
% % % hold on;
% % % % delete(ph2)
% % % xx2=10.^(log10(xl(1)):0.1:log10(xl(2)));
% % % uu=xx2*sl+co;
% % % ll=xx2/sl-co;
% % % yl=ylim;
% % % ll(find(ll<=yl(1)))=yl(1)*0.99;
% % % axes(fig1);
% % % ph2=plot(xl, xl, '-k',xx2, uu, '--k', xx2, ll , '--k');
% % % axes(fig2);
% % % xx2=10.^(log10(xl(1)):0.1:log10(xl(2)));
% % % uu=(xx2*sl+co)./xx2;
% % % ll=(xx2/sl-co)./xx2;
% % % hold on;
% % % plot(xl, [1 1], '-k', xx2, uu, '--k', xx2, ll, '--k');

% clear teall;
% tt=findobj(gcf,'type','text');
% for i=1:length(tt);
%     te=get(tt(i),'string');
%     teall0=str2num(te);
%     if ~isnan(teall0);
%         teall(i)=teall0;
%     end;
% end;

figure;
loglog(a.layeraodh_unc(ok,1), aod_b_rms(ok,1), '.b', ...
    a.layeraodh_unc(ok,2), aod_b_rms(ok,2), '.g', ...
    a.layeraodh_unc(ok,3), aod_b_rms(ok,3), '.r', ...
    [1e-8 100],[1e-8 100], '-k', ...
    'markersize',ms1);
grid on;
axis([1e-3 10 1e-5 10]);
ggla;
xlabel('AATS-14 Layer AOD Unc. intrinsic to the instrument');
ylabel({'Spatial Variability'; '(RMS diff. from the layer+top AOD)'});
if saveplot==1;
    ASsas(['ASAATSHiGEARAODclosure_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'LayerAODInstrumentUncRMS.fig, ASAATSHiGEARAODclosure.m']);
end;

figure;
loglog(a.layeraodh(ok,1), aod_b_rms(ok,1), '.b', ...
    a.layeraodh(ok,2), aod_b_rms(ok,2), '.g', ...
    a.layeraodh(ok,3), aod_b_rms(ok,3), '.r', ...
    [1e-8 100],[1e-8 100], '-k', ...
    [1e-8 100],([0.01:0.01:0.09 0.1:0.1:0.9])'*[1e-8 100], '--k', ...
    'markersize',ms1);
grid on;
axis([1e-3 10 1e-5 10]);
ggla;
xlabel('AATS-14 Layer AOD');
ylabel('RMS diff. from the layer+top AOD');
if saveplot==1;
    ASsas(['ASAATSHiGEARAODclosure_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'LayerAODRMS.fig, ASAATSHiGEARAODclosure.m']);
end;

figure;
loglog(aod_b_cov(ok,1).*a.layeraodh(ok,1), aod_b_rms(ok,1), '.b', ...
    aod_b_cov(ok,2).*a.layeraodh(ok,2), aod_b_rms(ok,2), '.g', ...
    aod_b_cov(ok,3).*a.layeraodh(ok,3), aod_b_rms(ok,3), '.r', ...
    [1e-8 100],[1e-8 100], '-k', 'markersize',ms1);
grid on;
axis([1e-5 10 1e-5 10]);
ggla;
xlabel('Standard Deviation');
ylabel('RMS diff. from the layer+top AOD');
if saveplot==1;
    ASsas(['ASAATSHiGEARAODclosure_maxcov' num2str(maxcov) '_altallowance' num2str(altallowance) 'method' num2str(method) 'STDvsRMS.fig, ASAATSHiGEARAODclosure.m']);
end;


