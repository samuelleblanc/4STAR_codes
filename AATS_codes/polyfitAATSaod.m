function [a2,a1,a0]=polyfitAATSaod(aod)

lambda=aatslambda;
n=size(aod,1);
wvluse_alpha=[1 1 1 1 1 1 1 1 1 0 1 1 0]; %added 7/11/08 JML to permit exclusion of certain wvls in calculating alpha
wvluse_alpha=[1 1 1 1 1 1 1 1 1 1 1 1 1]; %2009/11/12 Yohei. I can't recall why I previously removed the 1 um and 2.1 um channels. They are back.
cc=repmat(wvluse_alpha,n,1);
cc(find(aod<=0 | isfinite(aod)==0))=0;
p=repmat(NaN,n,3);
for i=1:n
    cc1=find(cc(i,:)==1);
    if ~isempty(cc1)
        [p(i,:),S] = polyfit(log(lambda(cc1)),log(aod(i,cc1)),2);
    end    
end
a2=p(:,1);
a1=p(:,2);
a0=p(:,3);


% degree=2;
% wvluse_alpha=[1 1 1 1 1 1 1 1 1 1 1 1 0]; %added 7/11/08 JML to permit exclusion of certain wvls in calculating alpha
% % interpolate tau_aero for non-windows channels and compute first and second derivative of spectrum
% for i=1:n(1)
%     wvl_use=(tau_aero(:,i)>0)' & wvluse_alpha==1;  %modified 7/11/08 to omit certain wvl; catch the AOD(lambda) which are < 0 and don't use for Angstrom fit
%     %wvl_use=(tau_aero(:,i)>0)';        %catch the AOD(lambda) which are < 0 and don't use for Angstrom fit
%     x=log(lambda(wvl_use==1));
%     y=log(tau_aero(wvl_use==1,i))';
%     if ~isempty(x)
%         [p,S] = polyfit(x,y,degree);
%         switch degree
%           case 1
%              a0(i)=p(2); 
%              alpha(i)=-p(1);
%              gamma(i)=0;
%           case 2  
%              a0(i)=p(3); 
%              alpha(i)=-p(2);
%              gamma(i)=-p(1); 
%         end  
%     else
%         a0(i)=NaN;
%         alpha(i)=NaN;
%         gamma(i)=NaN;
%     end    
% end