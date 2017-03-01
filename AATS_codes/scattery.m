function [hh,filename]=scattery(xx,xstr,yy,ystr,ss,sstr,cc,cstr,varargin)

% generates a color scatter plot in the format Yohei likes. See also
% scattery3.m.
% Yohei, 2009/02/25
% Yohei, 2015/08/19, introducing fastscatter.m.

if nargin<7
    cc=ones(size(xx));
    cstr='';
end;
clim=[];
marker='o';
if nargin>8;
    if iscell(varargin) & length(varargin)==1;
        varargin=varargin{:};
    end;
    for i=1:length(varargin)/2;
        if isequal(char(varargin(i*2-1)), 'slim');
            slim=varargin{i*2};
        elseif isequal(char(varargin(i*2-1)), 'marker');
            marker=char(varargin(i*2));
        elseif isequal(char(varargin(i*2-1)), 'clim');
            ms=sqrt(unique(ss(find(isfinite(ss)==1))));
            if length(ms)~=1 & numel(clim)>2;
                error('bins in clim do not work with multiple ss.')
            else
                clim=varargin(i*2);
                if iscell(clim);
                    clim=clim{:};
                end;
            end;
        end;
    end;
end;
if ~exist('slim');
    slim=[1 200];
end;
if ~isempty(clim) & numel(clim)>2;
    if iscell(clim)
        clim=clim{:};
    end;
    cbinsfinite=find(isfinite(clim)==1);
    caxis([min(clim(cbinsfinite)) max(clim(cbinsfinite))]);
    if min(size(clim))==1 & max(size(clim))>2; % a vector; reshape it into a p*2 matrix
        cbins1=clim(1:end-1);
        cbins2=clim(2:end);
        clim=[cbins1(:) cbins2(:)];
        clear cbins1 cbins2;
    end;
    pp=size(clim,1);
    lcf=length(cbinsfinite);
    clr=jet(lcf);
    if cbinsfinite(1)==2;
        clr=[clr(1,:)/10; clr];
    end;
    if cbinsfinite(end)==lcf-1;
        clr=[clr; clr(end,:)/10];
    end;
    clear cbinsfinite
    hh=repmat(NaN,pp,1);
    for i=1:pp;
        ok=find(cc>clim(i,1) & cc<=clim(i,2) & isfinite(xx)==1 & isfinite(yy)==1 & isfinite(ss)==1 & isfinite(cc)==1);
        if ~isempty(ok)
            hh(i)=plot(xx(ok), yy(ok), 'markersize', ms, 'marker', marker, 'markeredgecolor', clr(i,:),'linestyle','none');
        end;
        hold on
    end;
    hold off
else
    ok=find(isfinite(xx)==1 & isfinite(yy)==1 & isfinite(ss)==1 & isfinite(cc)==1);
    sslimited=ss;
    sslimited(find(sslimited<slim(1) | isfinite(sslimited)==0))=slim(1);
    sslimited(find(sslimited>slim(2)))=slim(2);
    hh=scatter(xx(ok), yy(ok), sslimited(ok), cc(ok), marker);
%     hh=fastscatter(xx(ok), yy(ok), sslimited(ok), cc(ok), marker); % Yohei, 2015/08/19
    if ~isempty(clim);
        if iscell(clim)
            clim=clim{:};
        end;
        caxis(clim);
    end;
end;
set(hh(find(isfinite(hh)==1)), 'linewidth',2);
ggla;
xlabel(xstr);
ylabel(ystr);
if ~isempty(sstr);
    th=legend(['Marker sized by ' sstr],0);
    set(th,'fontsize',12);
end;
grid on;
if nargin>8;
    for i=1:length(varargin)/2;
        if isequal(char(varargin(i*2-1)), 'slim');
        elseif isequal(char(varargin(i*2-1)), 'marker');
        elseif isequal(char(varargin(i*2-1)), 'clim');
        else
            set(gca, varargin(i*2-1), varargin(i*2))
        end;
    end;
end;
if ~isempty(cstr);
    ch=colorbarlabeled(cstr);
!!!
    if ~isempty(clim);
        set(ch,'ytick',get(ch,'ylim'), 'yticklabel',num2str(caxis')); 
    end;
!!!
else
    set(hh(find(isfinite(hh)==1)), 'markeredgecolor', 'k');
end;
xstr1=label2filename(xstr);
ystr1=label2filename(ystr);
sstr1=label2filename(sstr);
cstr1=label2filename(cstr);
filename=[xstr1 '_' ystr1 '_' sstr1 '_' cstr1];
set(gcf,'filename',[filename '.fig']); 