function [slope, intercept, std_about_regression, std_of_slope, r2]=regressm(x,y)

% applies least square linear regression to y (a matrix) against x (either
% a vertical vector with as many elements as the rows of y, or a matrix in
% the same size as y), to yield slope and intercept. This code yields the
% same results as regress, without the need to iterate through columns.
% Developed for generating Langley plots (see starLangley.m).
% Yohei, 2012/05/12, 2012/06/25

% control the input
if size(x,2)==1;
    x=repmat(x,1,size(y,2));
end;
ng=find(isfinite(y)==0 | isfinite(x)==0);
x(ng)=NaN;
y(ng)=NaN;
n=sum(isfinite(y));

% do the calculation
ybar=nansum(y)./n; % averaqe yy
sxx=nansum(x.^2)-nansum(x).^2./n;
syy=nansum(y.^2)-nansum(y).^2./n;
sxy=nansum(x.*y)-nansum(x).*ybar;
slope=sxy./sxx;
intercept=ybar-slope.*nansum(x)./n;
std_about_regression=sqrt((syy-slope.^2.*sxx)./(n-2));
std_of_slope=sqrt(std_about_regression.^2./sxx);
r2=sxy.^2./sxx./syy;

% OLD codes, column by column, use less memory.
% qq=size(data,2);
% b=repmat(NaN,2,qq);
% stats=repmat(NaN,qq,4);
% for ii=1:qq;
%     rows=find(data(:,ii)>0 & isfinite(m(:,ii))==1);
%     yy=data(rows,ii);
%     xx=m(rows,ii);
%     if exist('mbins')==1;
%         yy=binfcn('geomean', xx, yy, mbins);
%         xx=mean(mbins,2);
%     end;
%     if ~isempty(rows);
%         !!! merge the two schemes, also don't use regress. not even polyfit? faster if calculated manually?
%         if exist('stdev_mult')==1;
%             [p,S] = polyfit (xx,log(yy),1);
%             [y_fit,delta] = polyval(p,xx,S);
%             a=log(yy)-y_fit;
%             %Thompson-tau %THROWS DATA POINTS IF OUT OF STDEV_MULT -MK
%             while max(abs(a))>stdev_mult*std(a)
%                 i=find(abs(a)<max (abs(a)));
%                 xx=xx(i);
%                 yy=yy(i);
%                 [p,S] = polyfit (xx,log(yy),1)
%                 [y_fit,delta] = polyval(p,xx,S);
%                 a=log(yy)-y_fit;
%             end
%         else
%             [b(:,ii),bint,r,rint,stats(i,:)]=regress(log(yy), [xx ones(size(xx))], 0.05);
%         end;
%     end;
% end;
% b(~isfinite(b))=NaN;
% data0=exp(b(2,:));
% od=-b(1,:);