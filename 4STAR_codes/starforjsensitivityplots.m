% Create plots of 4STAR FORJ sensitivity, over angles and over time
% See also ARquickplots.m for running this code in a routine.
%
% Yohei, 2014/12/23

% load VIS_FORJ, NIR_FORJ
load(fullfile(starpaths, [daystr 'starforj.mat'])); % run starforj.m first.

% take dAZ/dt and related variables
dAZdt=[diff(AZstep/(-50))./diff(t)/86400; 0]; % rotation rate
ddAZdt=[diff(dAZdt)./diff(t)/86400; 0]; % the differential in the rotation rate

% eliminate time periods with near zero counts
maxzerocountrate=0.24;
maxzerostd=1000; % 1;
col=520:560; % 407; % column (407 corresponds to 500 nm)
rate1=rate;
idx1=repmat((1:size(rate,1))',1,2)+repmat([-1 1]*4,size(rate,1),1);
idx1(idx1<1)=1;
idx1(idx1>size(rate,1))=size(rate,1);
rate1std=stdvec(sum(rate(:,col),2), idx1);
nearzero=find(sum(rate1(:,col),2)<maxzerocountrate | rate1std>maxzerostd);
rate1(nearzero,:)=NaN;
clear idx1

% isolate cycles
minrotation=0.25; % tweak this if necessary
if ~isempty(nearzero);
    changes=unique([find(abs(ddAZdt)>minrotation); find(diff(visfilen)>0); nearzero(1); nearzero(diff(nearzero)>1); nearzero(end)]);
else
    changes=unique([find(abs(ddAZdt)>minrotation); find(diff(visfilen)>0)]);
end;
idx=NaN(numel(changes)+1,2);
idx(:,1)=[1;changes+1];
idx(:,2)=[changes;numel(AZstep)];
goodidx=false(size(idx,1),1);
for i=1:size(idx,1);
    yy=sum(rate1(idx(i,1):idx(i,2), col),2);
    if any(isfinite(yy));
        goodidx(i)=true;
    end;
end;
idx=idx(goodidx,:);
pp=size(idx,1);
rotmean=zeros(pp,1); % mean of the rotation rate
rotstd=zeros(pp,1); % std of the rotation rate
for i=1:pp;
    rotmean(i)=nanmean(dAZdt(idx(i,1):idx(i,2)));
    rotstd(i)=nanstd(dAZdt(idx(i,1):idx(i,2)));
end;

% prepare to plot
clr0=jet(7); clrp=repmat(clr0(1:3,:), ceil(pp/3),1);clrm=repmat(clr0(7:-1:5,:), ceil(pp/3),1); clrz=repmat(get(gca,'colororder'), ceil(pp/7),1);% clr=jet(pp);
clr=NaN(pp,3);
clr(abs(rotmean)<=minrotation,:)=clrz(1:numel(find(abs(rotmean)<=minrotation)),:);
clr(rotmean>minrotation,:)=clrp(1:numel(find(rotmean>minrotation)),:);
clr(rotmean<-minrotation,:)=clrm(1:numel(find(rotmean<-minrotation)),:);
bl=0; % degrees over which smoothing is applied
h=NaN(2,pp);
nmy=NaN(pp,2);
savefigure=1;
yl0=[0.98 1.02];
refrate=[];

% plot
figure; % against time; no rotation only
for i=1:pp;
    tt0=t(idx(i,1):idx(i,2)); % time
    if abs(rotmean(i))<=minrotation
        xx0=AZstep(idx(i,1):idx(i,2))/(-50); % AZ angle
        if any(xx0)
            warning('AZ deg not zero - puzzling.');
        end;
        yy=sum(rate1(idx(i,1):idx(i,2), col),2);
        if isempty(refrate);
            refrate=nanmean(yy);
            yla=['Count Rate, avg(' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13) ')=1'];
            lampi=i;
        end;
        yyn=yy./repmat(refrate, size(yy,1),1);
        h(:,i)=plot(tt0, yyn, '.',nanmean(tt0), nanmean(yyn), 'o', 'color',clr(i,:),'linewidth',2);
        nmy(i,1)=nanmean(tt0);
        nmy(i,2)=nanmean(yy);
        set(h(2,i),'markersize',6, 'markeredgecolor', clr(i,:)/2);
        lstr{i}=[datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13)];
        hold on;
    else
        nmy(i,1)=nanmean(tt0);
    end;
end;
if pp>1 && numel(find(abs(rotmean)>minrotation))>1;
    try
        nmy(abs(rotmean)>minrotation,2)=interp1(nmy(abs(rotmean)<=minrotation,1),nmy(abs(rotmean)<=minrotation,2),nmy(abs(rotmean)>minrotation,1));
    catch;keyboard;end;!!!
    plot(nmy(abs(rotmean)>minrotation,1),nmy(abs(rotmean)>minrotation,2)/refrate, 'o','color', [.5 .5 .5],'markersize',6);
end;
plot(xlim,[1 1], '-k');
dateticky('x','keeplimits');
lh=legend(h(1,abs(rotmean)<minrotation),lstr(abs(rotmean)<minrotation));
set(lh,'fontsize',12,'location','best');
ggla;
xlabel('UTC');
ylabel(yla);
ylim0=ylim;
if ylim0<yl0(1) | ylim0(2)>yl0(2);
    set(gca,'ycolor','r');
else
    ylim(yl0);
end;
title([daystr ', at AZ=0 deg']);
grid on;
if savefigure;
    starsas(['star' daystr 'FORJsensitivitytseries.fig, starforjsensitivityplots.m']);
end;

figure; % against angle; rotation only
for i=1:pp;
    if abs(rotmean(i))>minrotation
        tt0=t(idx(i,1):idx(i,2)); % time
        xx0=AZstep(idx(i,1):idx(i,2))/(-50); % AZ angle
        xx=mod(xx0,360); % AZ angle mod 360
        yy=sum(rate1(idx(i,1):idx(i,2), col),2);
        yyn=yy./repmat(refrate, size(yy,1),1);
        if numel(xx0)>1 && bl>0
            yynsm=boxxfilt(xx0,yyn,bl);
        else
            yynsm=yyn;
        end;
        br=find(abs(diff(xx))>180);
        if isempty(br);
            xx2=xx;
            yynsm2=yynsm;
        else
            xx2=xx(br(end)+1:end);yynsm2=yynsm(br(end)+1:end);
            bstart=1;
            for bb=1:numel(br);
                xx2=[xx(bstart:br(bb)); NaN; xx2];
                yynsm2=[yynsm(bstart:br(bb)); NaN; yynsm2];
                bstart=br(bb)+1;
            end;
        end;
        h(:,i)=plot(xx2, yynsm2, '-', xx, yyn, '.','color',clr(i,:),'linewidth',2);
        lstr{i}=[num2str(rotmean(i), '%+0.2f') ' deg/s, ' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13)];
        hold on;
    end;
end;
lh=legend(h(1,abs(rotmean)>minrotation),lstr(abs(rotmean)>minrotation));
plot(xlim,[1 1],'-k');
set(lh,'fontsize',12,'location','northwest');
ggla;
set(gca,'xtick',0:30:360,'xlim',[-5 365]);
xlabel('AZ deg mod 360');
ylabel(yla);
title(daystr);
grid on;
if savefigure;
    starsas(['star' daystr 'FORJsensitivityvAZdegmod360.fig, starforjsensitivityplots.m']);
end;

if pp>1 && numel(find(abs(rotmean)>minrotation))>1;
    figure; % against angle; for time segments with rotation only; adjusted for the changes in lamp intensity
    for i=1:pp;
        if abs(rotmean(i))>minrotation
            tt0=t(idx(i,1):idx(i,2)); % time
            xx0=AZstep(idx(i,1):idx(i,2))/(-50); % AZ angle
            xx=mod(xx0,360); % AZ angle mod 360
            yy=sum(rate1(idx(i,1):idx(i,2), col),2);
            yyn=yy./nmy(i,2);
            if numel(xx0)>1 && bl>0
                yynsm=boxxfilt(xx0,yyn,bl);
            else
                yynsm=yyn;
            end;
            br=find(abs(diff(xx))>180);
            if isempty(br);
                xx2=xx;
                yynsm2=yynsm;
            else
                xx2=xx(br(end)+1:end);yynsm2=yynsm(br(end)+1:end);
                bstart=1;
                for bb=1:numel(br);
                    xx2=[xx(bstart:br(bb)); NaN; xx2];
                    yynsm2=[yynsm(bstart:br(bb)); NaN; yynsm2];
                    bstart=br(bb)+1;
                end;
            end;
            h(:,i)=plot(xx2, yynsm2, '-', xx, yyn, '.','color',clr(i,:),'linewidth',2);
            nmy(i,1)=nanmean(tt0);
            lstr{i}=[num2str(rotmean(i), '%+0.2f') ' deg/s, ' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13)];
            hold on;
        end;
    end;
    lh=legend(h(1,abs(rotmean)>minrotation),lstr(abs(rotmean)>minrotation));
    set(lh,'fontsize',12,'location','northwest');
    ggla;
    set(gca,'xtick',0:30:360,'xlim',[-5 365]);
    plot(xlim,[1 1],'-k');
    xlabel('AZ deg mod 360');
    ylabel(yla);
    ylim0=ylim;
    if ylim0<yl0(1) | ylim0(2)>yl0(2);
        set(gca,'ycolor','r');
    else
        ylim(yl0);
    end;
    title([daystr ', adj''d to lamp intensity at avg(' datestr(t(idx(lampi,1)),13) '-' datestr(t(idx(lampi,2)),13) ')']);
    grid on;
    if savefigure;
        starsas(['star' daystr 'FORJsensitivityvAZdegmod360lampadjusted.fig, starforjsensitivityplots.m']);
    end;
end;
% carpet plots - take long
plotcarpet=false;
if plotcarpet
    refrate=[];
    for i=1:pp;
        if abs(rotmean(i))>minrotation
            figure; % carpet
            xx0=AZstep(idx(i,1):idx(i,2))/(-50); % AZ angle
            xx=mod(xx0,360); % AZ angle mod 360
            yy=rate1(idx(i,1):idx(i,2), :);
            yy=yy./nmy(i,2);
            if isempty(refrate);
                refrate=nanmean(yy);
                yla=['Count Rate, avg(' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13) ')=1'];
            end;
            yyn=yy./repmat(refrate, size(yy,1),1);
            if bl>0
            yynsm=boxxfilt(xx0,yyn,bl);
            else
                yynsm=yyn;
            end;
            ph=contourf(w,xx0,yynsm,0.98:0.01:1.02,'linestyle','none');
            gglwa;
            ylabel('AZ deg');
            ch=colorbarlabeled(yla);
            title([daystr ', at avg(' datestr(t(idx(lampi,1)),13) '-' datestr(t(idx(lampi,2)),13) ') lamp intensity']);
            if savefigure;
                starttstr=datestr(t(idx(i,1)),30);
                stoptstr=datestr(t(idx(i,2)),30);
                starsas(['star' starttstr stoptstr(10:end) 'FORJsensitivityvAZdeglampadjustedcarpet.fig, starforjsensitivityplots.m']);
                close;
            end;
        end;
    end;
end;