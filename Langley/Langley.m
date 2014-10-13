function [data0, od, residual, h]=Langley(m,data,stdev_mult,col_for_plot)

% applies linear regression to the logarithm of data (a matrix) against
% airmass (m, a vertical vector with as many elements as the rows of
% data), to yield data0 (intercept at m=0) and optical depth (slope * -1).
% If data has one column and if stdev_mult is given as a scalar or a
% horizontal vector, STD-based screening is carried out. Default for
% stdev_mult is [] which leads to no screening. Specify a column(s) as
% col_for_plot, and a Langley plot is generated.
%
% Example
% daystr='20120722';
% load(fullfile(starpaths, '20120722Langleystarsun.mat'), 't', 'w', 'rateaero', 'm_aero');
% langley=[datenum('21:14:10') datenum('23:28:10')]-datenum('00:00:00')+datenum([daystr(1:4) '-' daystr(5:6) '-' daystr(7:8)]);
% ok=incl(t,langley);
% stdev_mult=2:0.1:3;
% [data0, od, residual]=Langley(m_aero(ok),rateaero(ok,407),stdev_mult,1);
% ok2=ok(isfinite(residual(:,1))==1);
% cols=[225   258   347   408   432   539   627   761   869   969];
% [c0new, od, residual2]=Langley(m_aero(ok2),rateaero(ok2,:), [], cols);
% 
% Note the regression is expressed as y=exp(repmat(log(data0),numel(m),1)-m*od)
% 
% Yohei, 2012/05/12, 2013/01/08
% SL, v1.0, 2014/10/13, added version_set for version control of this m
% script
version_set('1.0');

% regulate input and output
qq=size(data,2);
if nargin>=3 && ~isempty(stdev_mult);
    if qq~=1;
        error('data must be a vertical vector when stdev_mult is given.');
    elseif ~all(diff(stdev_mult)>0)
        error('stdev_mult must monotonically increase.');
    end;
    qq=size(stdev_mult,2);
else
    stdev_mult=[];
end;
if nargin<4;
    col_for_plot=[];
    h=[];
end;

% run regression
if isempty(stdev_mult)
    [slope, intercept, std_about_regression, std_of_slope, r2]=regressm(m,log(data));
    od=slope*-1;
    data0=exp(intercept);
    if nargout>=3;
        y_fit=m*slope+repmat(intercept,size(m));
        residual=log(data)-y_fit;
    end;
else
    od=NaN(1,qq);
    data0=NaN(1,qq);
    residual1=NaN(numel(m),qq);
    rows=find(data>0);
    [p,S] = polyfit (m(rows),log(data(rows)),1);
    [y_fit,delta] = polyval(p,m(rows),S);
    residual=log(data(rows))-y_fit;
    for ii=qq:-1:1;
        while max(abs(residual))>stdev_mult(ii)*std(residual)
            i=find(abs(residual)<max (abs(residual)));
            rows=rows(i);
            [p,S] = polyfit (m(rows),log(data(rows)),1);
            [y_fit,delta] = polyval(p,m(rows),S);
            residual=log(data(rows))-y_fit;
        end
        od(ii)=-p(1);
        data0(ii)=exp(p(2));
        residual1(rows,ii)=residual;
    end;
    residual=residual1;
end;

% plot if requested
if ~isempty(col_for_plot);
    figure;
    h=semilogy(m, data(:,col_for_plot), '.');
    hold on;
    if isempty(stdev_mult)
        h(:,2)=plot([0 max(m)], [data0(col_for_plot)' exp(log(data0(col_for_plot))'-od(col_for_plot)'*max(m))], '-');
        lstr=[];
    else
        set(h,'color', [.5 .5 .5]);
        y=repmat(data,1,qq);
        y(~isfinite(residual))=NaN;
        sh2=plot(repmat(m,1,qq), fliplr(y), '.');
        h=[flipud(sh2);h];
        clear sh2;
        h(1:end-1,2)=plot([0 max(m)], [data0' exp(log(data0)'-od'*max(m))], '-');
        col_for_plot=1:qq;
    end;
    for ii=1:numel(col_for_plot);
        set(h(ii,2),'color', get(h(ii,1),'color'));
        lstr{ii}=[num2str(-1*od(col_for_plot(ii)), '%+0.4f') 'x+' num2str(data0(col_for_plot(ii)), '%0.2f')];
        if isempty(stdev_mult)
        else
            lstr{ii}=[num2str(stdev_mult(ii), '%0.1f') 'x (n=' num2str(sum(isfinite(y(:,ii)))) '), ' lstr{ii}];
        end;
    end;
    if isempty(stdev_mult)
        ylim([min(min(data(:,col_for_plot))) max([max(data(:,col_for_plot)) max(data0(col_for_plot))])]);
        lh=legend(h(:,2), lstr);
    else
        ylim([min(y(:)) max([max(y(:)) data0])]);
        lstr{ii+1}='no screening';
        lh=legend(h(:,1), lstr);
    end;
    set(lh,'fontsize',12,'location','southwest');
    ggla;
    grid on;
    hold off;
end;
