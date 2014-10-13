%% PURPOSE:
%   To support star_radcals_nonlinear and build a polynomial based
%   estimate of the well depth vs. radiance values
%
% CALLING SEQUENCE:
%   pols=makepoly_nresp(nonlin)
%
% INPUT:
%   - nonlin: structure with lamp information, spectrometer, welldepth, and
%   response functions
% 
% OUTPUT:
%  - pols structure in the form of polynomials
%  - figures of polynomials
%
% DEPENDENCIES:
%  none
%
% NEEDED FILES:
%  none
%
% EXAMPLE:
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, NASA Ames, date unknown, 2014
%
% -------------------------------------------------------------------------

%% Start of function
function pols=makepoly_nresp(nonlin);

%% combine the responses and well depth from the different lamps
pols.WD_reconstruct=(0.0:0.05:1.0);
for spc = {'vis','nir'}
    spc=char(spc);
    n=length(nonlin.Lamps_1.(spc).wells(1,:));
    for nm_=1:n
       pols.(spc).well(:,nm_)=[nonlin.Lamps_1.(spc).wells(:,nm_);nonlin.Lamps_2.(spc).wells(:,nm_);...
                    nonlin.Lamps_3.(spc).wells(:,nm_);nonlin.Lamps_6.(spc).wells(:,nm_);...
                    nonlin.Lamps_9.(spc).wells(:,nm_);nonlin.Lamps_12.(spc).wells(:,nm_);...
                    ]; 
       pols.(spc).nresp(:,nm_)=[nonlin.Lamps_1.(spc).nresp(:,nm_);nonlin.Lamps_2.(spc).nresp(:,nm_);...
                    nonlin.Lamps_3.(spc).nresp(:,nm_);nonlin.Lamps_6.(spc).nresp(:,nm_);...
                    nonlin.Lamps_9.(spc).nresp(:,nm_);nonlin.Lamps_12.(spc).nresp(:,nm_);...
                    ]; 
       [p,s]=polyfit(pols.(spc).well(:,nm_),pols.(spc).nresp(:,nm_),2);
       pols.(spc).ceof(:,nm_)=p;         
       % reconstruct the polynomials for each nm
       pols.(spc).nresp_reconstruct(:,nm_)=polyval(p,pols.WD_reconstruct,s);
    end
%    plot(nonlin.Lamps_1.vis.wells(:,nm_), nonlin.Lamps_1.vis.nresp(:,nm_),'o-',...
%    nonlin.Lamps_2.vis.wells(:,nm_), nonlin.Lamps_2.vis.nresp(:,nm_),'o-',...
%    nonlin.Lamps_3.vis.wells(:,nm_), nonlin.Lamps_3.vis.nresp(:,nm_),'o-',...
%    nonlin.Lamps_6.vis.wells(:,nm_), nonlin.Lamps_6.vis.nresp(:,nm_),'o-',...
%    nonlin.Lamps_9.vis.wells(:,nm_), nonlin.Lamps_9.vis.nresp(:,nm_),'o-',...
%    nonlin.Lamps_12.vis.wells(:,nm_), nonlin.Lamps_12.vis.nresp(:,nm_),'o-');   
end

%% now plot the corresponding reconstructed polynomials
figure(6);
subplot(1,2,1);
lines=plot(pols.WD_reconstruct,pols.vis.nresp_reconstruct(:,300:10:1040));
hold on;
plot(pols.vis.well(:,300:10:1040),pols.vis.nresp(:,300:10:1040),'o');
hold off;
xlabel('Well Depth');
ylabel('Normalized Responsitivity');
title('Polynomial fitted responsitivity for vis per pixel');
ylim([0.9,1.1]);xlim([0,1]);
grid on;

subplot(1,2,2);
lines=plot(pols.WD_reconstruct,pols.nir.nresp_reconstruct(:,10:10:500));
hold on;
plot(pols.nir.well(:,10:10:500),pols.nir.nresp(:,10:10:500),'o');
hold off;
xlabel('Well Depth');
ylabel('Normalized Responsitivity');
title('Polynomial fitted responsitivity for nir per pixel');
ylim([0.9 1.1]);xlim([0,1]);
grid on;
return