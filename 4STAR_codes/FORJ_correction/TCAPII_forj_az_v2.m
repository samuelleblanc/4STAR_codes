function forj_vis_out = TCAPII_forj_az(vis)
% v2 attempt to clean up darks and lights, added "lights" boolean
if ~exist('vis','var')||~exist(vis,'file');
    vis = getfullname('*_VIS_FORJ.dat','forj','Select a forj data file.');
end
% TCAPII_forj_vis_and_nir_az  (Look in other TCAPII forj function for
% remnant tests of El rotatation

[pname, fstem,ext] = fileparts(vis);
plot_dir = [pname,filesep,'plots']; 
if ~exist(plot_dir,'dir');
    mkdir(plot_dir);
end
plot_dir = [plot_dir,filesep];
forj_vis =  rd_spc_TCAP_v2(vis);
%%
% Compute Az_deg from AZstep with CW positive
forj_vis.t.Az_deg = -forj_vis.raw.AZstep./50;
% forj_nir.t.Az_deg = -forj_nir.raw.AZstep./50;
recs = [1:length(forj_vis.time)];
dAz = [0;diff(forj_vis.t.Az_deg)];
CW = dAz>0;
CCW = dAz<0;
if sum(CW)~=0 || sum(CCW)~=0
sta = dAz==0; %stationary
bar = mod(forj_vis.t.Az_deg,360);
bar = bar<1 | bar>359; % Logical that identifies the wrap point (in order to set to NaN to avoid end-to-end lines in  plot)
pix_630 = interp1(forj_vis.nm, [1:length(forj_vis.nm)],630,'nearest');
%%

dark = forj_vis.t.shutter==0 & forj_vis.spectra(:,pix_630)<100;
darks_vis = mean(forj_vis.spectra(dark,:));
% darks_nir = mean(forj_nir.spectra(dark,:))
% figure; plot(forj_vis.nm, forj_vis.spectra(~dark,:)-ones([sum(~dark),1])*darks,'-'); zoom('on')

%%
 vis_spec = forj_vis.spectra-ones([length(forj_vis.time),1])*darks_vis;
 lights = forj_vis.t.shutter==1 & vis_spec(:,pix_630)>(0.96*max(vis_spec(:,pix_630)));
% pix 520-560 looks quite good
% mean_spec = mean(vis_spec(~dark,:));
mean_spec = mean(vis_spec(lights,:));
pix = [1:length(forj_vis.nm)];
%%
block = vis_spec./(ones(size(forj_vis.time))*mean_spec);

% block = vis_spec./(ones(size(forj_vis.time))*mean(vis_spec(~dark&sta,:)));
 figure; lines = plot(pix, vis_spec(lights&sta,:)./(ones(size(forj_vis.time(lights&sta)))*mean(vis_spec(lights&sta,:))),'-'); 
%  lines = plot(pix,std(vis_spec(~dark&sta,:))./mean(vis_spec(~dark&sta,:)),'-')
cb=  colorbar; recolor(lines,recs(lights&sta));
set(get(cb,'title'),'string','rec #')
 title({'Variation while stationary'; forj_vis.fname},'interp','none');
 xlabel('pixel number')
 ylabel('%');
 xlim([350,760]);ylim([.95, 1.05]);
 zoom('on')

% 
% %  ok = menu('Zoom in to select desired region','OK')
%  xl = xlim;
%  yl = ylim;
 xl = [350,760]; yl = [.95, 1.05];
 %%
good = all(block(:,pix>xl(1)&pix<xl(2))>yl(1)&block(:,pix>xl(1)&pix<xl(2))<yl(2),2);
mean_spec = mean(vis_spec(good&lights,:));

% lines = plot(pix, vis_spec(good&~dark&sta,:)./(ones(size(forj_vis.time(good&~dark&sta)))*mean(vis_spec(good&~dark&sta,:))),'-'); 
% %  lines = plot(pix,std(vis_spec(~dark&sta,:))./mean(vis_spec(~dark&sta,:)),'-')
% cb=  colorbar; recolor(lines,recs(good&~dark&sta));
% set(get(cb,'title'),'string','rec #')
%  title({'Variation while stationary'; forj_vis.fname},'interp','none');
%  xlabel('pixel number')
%  ylabel('%');
%   xlim([300,800]);
%%

% v(:,1) = (pix>300)&(pix<343);
% v(:,2) = (pix>=343)&(pix<392);
% v(:,3) = (pix>=392)&(pix<540);
% v(:,4) = (pix>=540)&(pix<625);
% v(:,5) = (pix>=625)&(pix<700);
% v(:,6) = (pix>=700)&(pix<800);
% v(:,7) = v(:,1)|v(:,2);
% v(:,8) = v(:,3)|v(:,4)|v(:,5)|v(:,6);
v(:,9) = (pix>=520)&(pix<=560); %Visually determined to have little variability

tots_vis = sum(vis_spec,2); %sum of signal from all pixels as function of time
tots_v(:,9) = sum(vis_spec(:,v(:,9)),2); % sum of pixels in zone 9 vs time
% tots_v(:,8) = sum(vis_spec(:,v(:,8)),2);
% tots_v(:,7) = sum(vis_spec(:,v(:,7)),2);
% tots_v(:,6) = sum(vis_spec(:,v(:,6)),2);
% tots_v(:,5) = sum(vis_spec(:,v(:,5)),2);
% tots_v(:,4) = sum(vis_spec(:,v(:,4)),2);
% tots_v(:,3) = sum(vis_spec(:,v(:,3)),2);
% tots_v(:,2) = sum(vis_spec(:,v(:,2)),2);
% tots_v(:,1) = sum(vis_spec(:,v(:,1)),2);

%%

% figure; plot(pix(v(:,1)), mean_spec(v(:,1)), '.',...
% pix(v(:,2)), mean_spec(v(:,2)), '.',...
% pix(v(:,3)), mean_spec(v(:,3)), '.',...
% pix(v(:,4)), mean_spec(v(:,4)), '.',...
% pix(v(:,5)), mean_spec(v(:,5)), '.',...
% pix(v(:,6)), mean_spec(v(:,6)), '.');
% legend('range 1','range 2', 'range 3', 'range 4', 'range 5', 'range 6');
% hold('on');
% plot(pix, mean_spec, 'k.');
% plot(pix(v(:,1)), mean_spec(v(:,1)), '.',...
% pix(v(:,2)), mean_spec(v(:,2)), '.',...
% pix(v(:,3)), mean_spec(v(:,3)), '.',...
% pix(v(:,4)), mean_spec(v(:,4)), '.',...
% pix(v(:,5)), mean_spec(v(:,5)), '.',...
% pix(v(:,6)), mean_spec(v(:,6)), '.',...
% pix(v(:,9)), mean_spec(v(:,9)),'kx');
% xlim([250,850]);
% xlabel('pixel number')
%%
% figure; plot(pix(v(:,7)), mean_spec(v(:,7)), '.',...
% pix(v(:,8)), mean_spec(v(:,8)), '.',...
% pix(v(:,9)), mean_spec(v(:,9)), '.');
% legend('ranges 1 & 2','ranges 3-6', 'mid range');



%%

mean_tots_vis_stationary = mean(tots_vis(good&lights&(dAz==0)));
mean_tots_vis_CW = mean(tots_vis(good&lights&(dAz>0)));
mean_tots_vis_CCW = mean(tots_vis(good&(lights)&(dAz<0)));

mean_tots_v_stationary = mean(tots_v(good&lights&sta,:));
mean_tots_v_CW = mean(tots_v(good&lights&CW,:));
mean_tots_v_CCW =mean(tots_v(good&lights&CCW,:));

std_tots_vis_stationary = std(tots_vis(good&lights&(dAz==0)));
std_tots_vis_CW = std(tots_vis(good&lights&(dAz>0)));
std_tots_vis_CCW = std(tots_vis(good&(lights)&(dAz<0)));

std_tots_v_stationary = std(tots_v(good&lights&sta,:));
std_tots_v_CW = std(tots_v(good&lights&CW,:));
std_tots_v_CCW =std(tots_v(good&lights&CCW,:));

pct_tots_vis_stationary = 100.*std_tots_vis_stationary ./ mean_tots_vis_stationary;
pct_tots_vis_CW = 100.*std_tots_vis_CW ./ mean_tots_vis_CW;
pct_tots_vis_CCW = 100.*std_tots_vis_CCW ./ mean_tots_vis_CCW;
pct_tots_v_stationary = 100.*std_tots_v_stationary ./ mean_tots_v_stationary;
pct_tots_v_CW = 100.*std_tots_v_CW ./ mean_tots_v_CW;
pct_tots_v_CCW = 100.*std_tots_v_CCW ./ mean_tots_v_CCW;


%%
% fig1 = figure; plot(forj_vis.t.Az_deg((~dark)&(dAz>0)), 100.*(tots_az((~dark)&(dAz>0))./mean_tots_dAz)-100,'-b.',...
%     forj_vis.t.Az_deg((~dark)&(dAz<0)), 100.*(tots_az((~dark)&(dAz<0))./mean_tots_CCW)-100,'-r.');
% legend('CW','CCW');
% title({'Total LED signal dependence on Azimuth axis (FORJ).';forj_vis.fname},'interp','none')
% ylabel('%')
% xlabel('Az degrees (zero is toward nose)');

%  figure; lines = plot(pix, vis_spec(~dark&CW,:)./(ones(size(forj_vis.time(~dark&CW)))*mean_spec),'-'); 
%  colorbar; recolor(lines,recs(~dark&CW));
%  title('Variation during CW rotation')
%  xlim([300,800]);
%  %%
%  figure; lines = plot(pix, vis_spec(~dark&CCW,:)./(ones(size(forj_vis.time(~dark&CCW)))*mean_spec),'-'); 
%  colorbar; recolor(lines,recs(~dark&CCW));
%  title('Variation during CCW rotation')
%  xlim([300,800]);
 %%
% Where did the offset versus 0 come from?
% fig2 = figure; plot(recs((~dark)&(dAz==0)), 100.*(tots_v(~dark&sta,:)./(ones([sum(~dark&sta),1])*mean_tots_v_stationary)-1),'.');
%tots_v(~dark&sta,:)
% fig2 = figure; plot(recs(good&(~dark)&(dAz==0)), 100.*(tots_v(good&~dark&sta,[2 7:9])./(ones([sum(good&~dark&sta),1])*mean(tots_v(good&~dark&sta,[2 7:9])))-1),'.',...
%     recs((good&~dark)&(dAz==0)),100.*(tots_vis(good&~dark&sta)./(ones([sum(good&~dark&sta),1])*mean(tots_vis(good&~dark&sta)))-1) ,'k.');
% legend('range 1&2','range 3-6','mid-range', 'total');
% title({'Percent deviation from mean: ';forj_vis.fname},'interp','none')
% ylabel('%')
% xlabel('record number');
%%
%%
%This plot selects the two spectral regions ( v1&v2 and v3-v6) that appear
%to yield most stable results, least affected by lamp instability
bar = mod(forj_vis.t.Az_deg,360);
bar = bar<1 | bar>359;
tots_bar = tots_v(bar,:);
tots_v(bar,:) = NaN;
fig2 = figure; these = plot(mod(forj_vis.t.Az_deg(good&~dark&CW),360), (tots_v(good&~dark&CW,9)./(ones([sum(good&~dark&CW),1])*mean_tots_v_CW(9))),'-b.',...
    mod(forj_vis.t.Az_deg((good&~dark)&CCW),360), (tots_v(good&~dark&CCW,9)./(ones([sum(good&~dark&CCW),1])*mean_tots_v_CCW(9))),'-r.');
set(these(1),'color',.8.*[0,191./255,191./255]);set(these(2), 'color',.8.*[1,153./255, 200./255]);
legend('CW','CCW');
title({'Total LED signal dependence on Azimuth axis (FORJ).';forj_vis.fname},'interp','none')
ylabel('normalized')
xlabel('Az degrees (zero is toward nose)');
tots_v(bar,:) = tots_bar;
%%
% OK = menu('Save or skip?','Save','Skip')
% if OK==1

% end
%%
forj_vis_out.meas(1).fstem = fstem;
forj_vis_out.meas(1).time = forj_vis.time([1 end]);
forj_vis_out.meas(1).Az_deg_CW = mod(forj_vis.t.Az_deg(good&lights&CW),360);
forj_vis_out.meas(1).corr_CW = 1./(tots_v(good&lights&CW,9)./(ones([sum(good&lights&CW),1])*mean_tots_v_CW(9)));
forj_vis_out.meas(1).Az_deg_CCW = mod(forj_vis.t.Az_deg((good&lights)&CCW),360);
forj_vis_out.meas(1).corr_CCW = 1./(tots_v(good&lights&CCW,9)./(ones([sum(good&lights&CCW),1])*mean_tots_v_CCW(9)));
forj_vis_out.Az_deg = [0:360];
degs = forj_vis_out.Az_deg;
for d = length(degs):-1:1
    d_ = forj_vis_out.meas.Az_deg_CW>=degs(d)&forj_vis_out.meas.Az_deg_CW<(degs(d)+1);
    forj_vis_out.corr_cw(d) = mean(forj_vis_out.meas.corr_CW(d_));
    forj_vis_out.corr_cw_std(d) = std(forj_vis_out.meas.corr_CW(d_));
    d_ = forj_vis_out.meas.Az_deg_CCW>=degs(d)&forj_vis_out.meas.Az_deg_CCW<(degs(d)+1);    
    forj_vis_out.corr_ccw(d) = mean(forj_vis_out.meas.corr_CCW(d_));
    forj_vis_out.corr_ccw_std(d) = std(forj_vis_out.meas.corr_CCW(d_));
end 
ends = [1 length(degs)];
flds = fieldnames(forj_vis_out);
for f = 1:length(flds)
    fld = flds{f};
    if ~strcmp(fld,'meas')&&~strcmp(fld,'time')&&~strcmp(fld,'Az_deg')
        notNaN = ~isNaN([forj_vis_out.(fld)(ends)]);
        if any(notNaN)
            forj_vis_out.(fld)(ends(~notNaN))=forj_vis_out.(fld)(ends(notNaN));
        end
        loneNaNs = xor(isNaN(forj_vis_out.(fld)),isNaN(forj_vis_out.(fld)([2:end 1])));
        if any(loneNaNs)
            forj_vis_out.(fld)(loneNaNs) = interp1(forj_vis_out.Az_deg(~loneNaNs), ...
                forj_vis_out.(fld)(~loneNaNs), forj_vis_out.Az_deg(loneNaNs),'linear','extrap');
        end
            
    end
    
end

forj_vis_out.abs_diff = abs(forj_vis_out.corr_cw - forj_vis_out.corr_ccw)./2 ;
forj_vis_out.corr_std = sqrt(forj_vis_out.corr_cw_std.^2 + forj_vis_out.corr_ccw_std.^2 +forj_vis_out.abs_diff.^2);
forj_vis_out.corr = (forj_vis_out.corr_cw + forj_vis_out.corr_ccw)./2 ;
forj_vis_out.time = forj_vis.time(1);
figure; 
set(gcf,'position',[460    34   809   618]);
ax(1) = subplot(2,1,1);
plot(forj_vis_out.Az_deg, forj_vis_out.corr_cw,'b-',forj_vis_out.Az_deg, forj_vis_out.corr_ccw,'r-',  forj_vis_out.Az_deg, forj_vis_out.corr,'k-');
legend('CW','CCW','mean','location','southwest');
title({'FORJ correction factor vs Azimuth axis: ';forj_vis.fname},'interp','none')
ylabel('correction')

ax(2) = subplot(2,1,2);
plot(forj_vis_out.Az_deg, forj_vis_out.abs_diff,'xr-',forj_vis_out.Az_deg, forj_vis_out.corr_std,'-k');    
lg = legend('abs_diff','std_dev','location','northwest');set(lg,'interp','none');
xlabel('Az degrees (zero is toward nose)');
linkaxes(ax,'x');
xlim([0,360]);
%%

%%
[pname, fstem,ext] = fileparts(forj_vis.fname);
saveas(gcf,[plot_dir,fstem,'.png']);
saveas(gcf,[plot_dir,fstem,'.fig']);
%Sort and Bin the existing measurements in 1 degree increments
%%
else
    disp('No rotation?');
    forj_vis_out = [];
end

return