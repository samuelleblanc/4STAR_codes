% load VIS_FORJ, NIR_FORJ
load(fullfile(starpaths, [daystr 'starforj.mat'])); % run starforj.m first.

% take dAZ/dt and related variables
dAZdt=[diff(AZstep/50)./diff(t)/86400; 0]; % rotation rate
ddAZdt=[diff(dAZdt)./diff(t)/86400; 0]; % the differential in the rotation rate

% isolate cycles
minrotation=0.2; % tweak this if necessary
change_of_rate=find(abs(ddAZdt)>minrotation);
idx(:,1)=[1;change_of_rate+1];
idx(:,2)=[change_of_rate;numel(AZstep)];
pp=size(idx,1);
rotmean=zeros(pp,1); % mean of the rotation rate
rotstd=zeros(pp,1); % std of the rotation rate
for i=1:pp;
    rotmean(i)=nanmean(dAZdt(idx(i,1):idx(i,2)));
    rotstd(i)=nanstd(dAZdt(idx(i,1):idx(i,2)));
end;

% prepare to plot
clr=get(gca,'colororder');% clr=jet(pp);
col=407; % column (407 corresponds to 500 nm)
bl=10; % degrees over which smoothing is applied
h=NaN(2,pp);
nmy=NaN(pp,2);

% plot
figure; % against time; no rotation only
refrate=[];
for i=1:pp;
    if abs(rotmean(i))<=minrotation
        tt0=t(idx(i,1):idx(i,2)); % time
        xx0=AZstep(idx(i,1):idx(i,2))/50; % AZ angle
        if any(xx0)
            warning('AZ deg not zero - puzzling.');
        end;
        yy=rate(idx(i,1):idx(i,2), col);
        if isempty(refrate);
            refrate=nanmean(yy);
            yla=['Count Rate, avg(' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13) ')=1'];
            lampi=i;
        end;
        yyn=yy./repmat(refrate, size(yy,1),1);
        h(:,i)=plot(tt0, yyn, '.',nanmean(tt0), nanmean(yyn), 'o', 'color',clr(i,:),'linewidth',2);
        nmy(i,1)=nanmean(tt0);
        nmy(i,2)=nanmean(yyn);
        set(h(2,i),'markersize',12);
        lstr{i}=[num2str(rotmean(i), '%+0.2f') ' deg/s, ' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13)];
    hold on;
    end;
end;
dateticky('x','keeplimits');
lh=legend(h(1,abs(rotmean)<minrotation),lstr(abs(rotmean)<minrotation));
set(lh,'fontsize',12,'location','best');
ggla;
xlabel('UTC');
ylabel(yla);
title([daystr ', at AZ=0 deg']);
grid on;
if savefigure;
    starsas(['star' daystr 'FORJsensitivitytseries.fig, starforjsensitivityplots.m']);
end;

figure; % against angle; rotation only
refrate=[];
for i=1:pp;
    if abs(rotmean(i))>minrotation
        tt0=t(idx(i,1):idx(i,2)); % time
        xx0=AZstep(idx(i,1):idx(i,2))/50; % AZ angle
        xx=mod(xx0,360); % AZ angle mod 360
        yy=rate(idx(i,1):idx(i,2), col);
        if isempty(refrate);
            refrate=nanmean(yy);
            yla=['Count Rate, avg(' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13) ')=1'];
        end;
        yyn=yy./repmat(refrate, size(yy,1),1);
        yynsm=boxxfilt(xx0,yyn,bl);
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
xlabel('AZ deg mod 360');
ylabel(yla);
title(daystr);
grid on;
if savefigure;
    starsas(['star' daystr 'FORJsensitivityvAZdegmod360.fig, starforjsensitivityplots.m']);
end;

figure;
nmy(abs(rotmean)>minrotation,2)=interp1(nmy(abs(rotmean)<=minrotation,1),nmy(abs(rotmean)<=minrotation,2),nmy(abs(rotmean)>minrotation,1));
refrate=[];
for i=1:pp;
    if abs(rotmean(i))>minrotation
        tt0=t(idx(i,1):idx(i,2)); % time
        xx0=AZstep(idx(i,1):idx(i,2))/50; % AZ angle
        xx=mod(xx0,360); % AZ angle mod 360
        yy=rate(idx(i,1):idx(i,2), col);
        yy=yy./nmy(i,2);
        if isempty(refrate);
            refrate=nanmean(yy);
            yla=['Count Rate, avg(' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13) ')=1'];
        end;
        yyn=yy./repmat(refrate, size(yy,1),1);
        yynsm=boxxfilt(xx0,yyn,bl);
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
set(gca,'xtick',0:30:360,'xlim',[-5 365],'ylim',[0.98 1.02]);
plot(xlim,[1 1],'-k');
xlabel('AZ deg mod 360');
ylabel(yla);
title([daystr ', adj''d to lamp intensity at avg(' datestr(t(idx(lampi,1)),13) '-' datestr(t(idx(lampi,2)),13) ')']);
grid on;
if savefigure;
    starsas(['star' daystr 'FORJsensitivityvAZdegmod360lampadjusted.fig, starforjsensitivityplots.m']);
end;

% carpet plots - take long
refrate=[];
for i=1:pp;
    if abs(rotmean(i))>minrotation
        figure; % carpet
        xx0=AZstep(idx(i,1):idx(i,2))/50; % AZ angle
        xx=mod(xx0,360); % AZ angle mod 360
        yy=rate(idx(i,1):idx(i,2), :);
        yy=yy./nmy(i,2);
        if isempty(refrate);
            refrate=nanmean(yy);
            yla=['Count Rate, avg(' datestr(t(idx(i,1)),13) '-' datestr(t(idx(i,2)),13) ')=1'];
        end;
        yyn=yy./repmat(refrate, size(yy,1),1);
        yynsm=boxxfilt(xx0,yyn,bl);
        ph=contourf(w,xx0,yynsm,0.98:0.01:1.02,'linestyle','none');
        gglwa;
        ylabel('AZ deg');
        ch=colorbarlabeled(yla);
        title([daystr ', adj''d to lamp intensity at avg(' datestr(t(idx(lampi,1)),13) '-' datestr(t(idx(lampi,2)),13) ')']);
        if savefigure;
            starttstr=datestr(t(idx(i,1)),30);
            stoptstr=datestr(t(idx(i,2)),30);
            starsas(['star' starttstr stoptstr(10:end) 'FORJsensitivityvAZdeglampadjustedcarpet.fig, starforjsensitivityplots.m']);
        close;
        end;
    end;
end;
