function [s,sn]=varvec(vector, index, w);

% take the variance of the elements in "vector" (can be a matrix
% with dimension pv*qv) between the start and end indices (1 - pv)
% specified by the p*2 matrix "index". Set w to NaN, and the sum of the
% vector will be returned (see sumvec.m). See also stdvec.m and sumvec.m. 
% the first part of this code serves as sumvec.m.

if nargin<3;
    w=0;
elseif isnan(w)==0 & w~=0 & w~=1 
    error('w must be 0 or 1.');
end;
if isempty(index);
    s=zeros(0,size(vector,2));
    sn=zeros(0,size(vector,2));
    return;
else
    index0=index;
    [index,unii,unij]=unique(index0,'rows');
end;

% truncate the vector
mi=min(index(:));
ma=max(index(:));
vector=vector(mi:ma,:);
index=index-mi+1;

% control the dimension
isf=isfinite(vector);
%vector(find(isf==0))=0;
vector(~isf)=0;
[pv, qv]=size(vector);
[p,q]=size(index);
ok0=incl(index(:,1), [1 pv]);
ok1=incl(index(:,1), [2 pv]);
ok2=incl(index(:,2), [1 pv]);
if q~=2;
    if p==2;
        index=index';
        [p,q]=size(index);
    else
        error('index must have two columns.');
    end;
end;

% calculate the sum
cs=cumsum(vector);
v2s=repmat(NaN,p,qv);
v2e=repmat(NaN,p,qv);
v2s(ok0,:)=0;
v2s(ok1,:)=cs(index(ok1,1)-1, :);
v2e(ok2,:)=cs(index(ok2,2), :);
s=v2e-v2s;

% calculate the number of samples
csisf=cumsum(isf);
isf2s=repmat(NaN,p,qv);
isf2e=repmat(NaN,p,qv);
isf2s(ok0,:)=0;
isf2s(ok1,:)=csisf(index(ok1,1)-1,:);
isf2e(ok2,:)=csisf(index(ok2,2), :);
sn=isf2e-isf2s;

% quit if the sum is requested
if isnan(w)==1; % See sumvec.m.
    unij=uint32(unij);
    s=s(unij,:);
    sn=sn(unij,:);
    return;
end;

% calculate the residual
% % % smean=(s./repmat(sn,1,qv))'; % mean
% % % smean=smean(:)';
% % % % resid=vector - repmat(smean,pv,1); % residual
% % % resid=repmat(vector,1,p) - repmat(smean,pv,1); % residual
% % % 
% % % % calculate the sum of the residual squared
% % % cs=cumsum(resid.*conj(resid));
% % % baseidx=(0:qv*p-1).*pv;
% % % addthis1=repmat(index(ok0,1)'-1,qv,1);
% % % addthis2=repmat(index(ok2,2)',qv,1);
% % % index1b=baseidx+addthis1(:)';
% % % index2b=baseidx+addthis2(:)';
% % % cs1b=zeros(size(index1b));
% % % nz=find(addthis1(:)'>0);
% % % cs1b(nz)=cs(index1b(nz));
% % % s=cs(index2b)-cs1b;
% % % s=reshape(s,qv,p)';

smean=s./sn;
c=real(smean);
d=imag(smean);
clear s;
a=real(vector);
b=imag(vector);
% calculate the sum
for k=1:4;
    if k==1;
        vectorc=a.^2;
    elseif k==2;
        vectorc=b.^2;
    elseif k==3;
        vectorc=a;
    elseif k==4;
        vectorc=b;
    end;
    cs=cumsum(vectorc);
    v2s=repmat(NaN,p,qv);
    v2e=repmat(NaN,p,qv);
    v2s(ok0,:)=0;
    v2s(ok1,:)=cs(index(ok1,1)-1, :);
    v2e(ok2,:)=cs(index(ok2,2), :);
    s=v2e-v2s;
    if k==1;
        sa2=s;
    elseif k==2;
        sb2=s;
    elseif k==3;
        sa=s;
    elseif k==4;
        sb=s;
    end;
end;
s1=sa2+sb2-2*c.*sa-2*d.*sb;
s2=(c.^2+d.^2).*sn;
nearzero=find(abs((s1+s2)./s1)<1e-6 | abs(s1+s2)<1e-12);
s=s1+s2;
s(nearzero)=0;

% calculate the variance
if w==0;
    s=s./(sn-1);
elseif w==1;
    s=s./sn;
end;
s(~isfinite(s))=NaN;

% return output
s=s(unij,:);
sn=sn(unij,:);
