function [a2,a1,a0,ang,curvature]=polyfitaod(lambda,aod)
% fits aod(lambda) in a log-log sense.  
% Evaluate aod as exp(polyval([a2,a1,a0],log(lambda))) 

% control input
if size(lambda,2)~=size(aod,2);
    if size(lambda,1)==size(aod,2) & size(lambda,2)==1;
        lambda=lambda';
    else
        error('lambda must have the same number of columns as aod.');
    end;
end;
n=size(aod,1);
cc=ones(size(aod));
cc(find(aod<=0 | isfinite(aod)==0))=0;

% fit to each spectrum
p=repmat(NaN,n,3);
for i=1:n
    cc1=find(cc(i,:)==1);
    if length(cc1)>2 % modified from ~isempty(cc1) on 2011/05/24
        [p(i,:),S] = polyfit(log(lambda(cc1)),log(aod(i,cc1)),2);
    end    
end
a2=p(:,1);
a1=p(:,2);
a0=p(:,3);

% calculate modified Angstrom exponent and curvature
if nargout>=4;
    [ang,Ap,curvature]=polyfit2ang(lambda,a2,a1);
end;
