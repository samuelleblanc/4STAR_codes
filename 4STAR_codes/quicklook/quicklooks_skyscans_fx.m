function fig_names = quicklooks_skyscans_fx(s,fig_path)
%% Details of the function:
% NAME:
%   quicklooks_skyscans_fx
% 
% PURPOSE:
%   Make figures for skyscan quicklooks, from the star.mat 
% 
% INPUT:
%  - s: a loaded star.mat struct from allstarmat
%  - fig_path: path to save figures at 
% 
% OUTPUT:
%   fig_names: array with full file path of the figures 
%
% DEPENDENCIES:
%  - starwrapper.m
%  - starpaths.m
%  - update_toggle
%
% NEEDED FILES:
%  - *.xs under data_folder
%
% EXAMPLE:
%
%  
%
% MODIFICATION HISTORY:
% Written: Samuel LeBlanc, 2022-04-12, based on starskies_2
% Modified:
% -------------------------------------------------------------------------
%% function routine
version_set('1.0');

if nargin<2;
    fig_path = figp;
end;
fig_names = {};
wvls = [0.40,0.5,0.86,1.2];
%********************
%% check the skyscans and run starwrapper
%********************
if isfield(s,'vis_skya')
    for ia=1:numel(s.vis_skya)
        toggle.verbose = false;
        sa=starwrapper(s.vis_skya(ia), s.nir_skya(ia),update_toggle(toggle));
        sa.SA = scat_ang_degs(sa.sza,sa.sunaz,90-abs(sa.El_deg),sa.Az_deg);
        iw=1; for ww=wvls, [nul,wi(iw)]=min(abs(sa.w-ww)); iw=iw+1; end
        CM = jet(iw-1);
        fig = figure; 
        plot(sa.SA,sa.rate(:,wi),'.','color','k'); set(gca, 'YScale', 'log');
        hold on;
        sun_right = sa.Str==1 & sa.Az_deg>sa.sunaz; 
        sun_left = sa.Str==1 & sa.Az_deg<sa.sunaz; 
        sky_right = sa.Str==2 & sa.Az_deg>sa.sunaz; 
        sky_left = sa.Str==2 & sa.Az_deg<sa.sunaz; 
        ic = 1
        for c=CM'
            sup = plot(sa.SA(sun_right),sa.rate(sun_right,wi(ic)),'^','color',c);
            sum = plot(sa.SA(sun_left),sa.rate(sun_left,wi(ic)),'v','color',c);
            skp = plot(sa.SA(sky_right),sa.rate(sky_right,wi(ic)),'+','color',c);
            skm = plot(sa.SA(sky_left),sa.rate(sky_left,wi(ic)),'o','color',c);
            ic = ic+1;
        end
        grid on
        hold off;
        xlabel('Scattering angle [deg]')
        ylabel('count rates')
        [nul,fname] = fileparts(sa.filename{1});
        title({fname;'Almucantar'},'Interpreter','None')
        legend([sup,sum,skp,skm],{'sun right','sun left','sky right','sky left'})
        colormap(CM)
        lcolorbar(string(wvls*1000.0),'TitleString','Wavelength [nm]')
        fnameout = [sa.instrumentname sa.daystr '_SKYA' sa.filen '_rate2scatteringangle'];
        fig_names = [fig_names;{fullfile(fig_path, [fnameout '.png'])}];
        save_fig(fig,fullfile(fig_path, fnameout),0);
    end
end

if isfield(s,'vis_skyp')
        for ia=1:numel(s.vis_skyp)
        toggle.verbose = false;
        sa=starwrapper(s.vis_skyp(ia), s.nir_skyp(ia),update_toggle(toggle));
        sa.SA = scat_ang_degs(sa.sza,sa.sunaz,90-abs(sa.El_deg),sa.Az_deg);
        iw=1; for ww=wvls, [nul,wi(iw)]=min(abs(sa.w-ww)); iw=iw+1; end
        CM = jet(iw-1);
        fig = figure; 
        plot(sa.SA,sa.rate(:,wi),'.','color','k'); set(gca, 'YScale', 'log');
        hold on;
        sun_right = sa.Str==1 & sa.El_deg>sa.sunel; 
        sun_left = sa.Str==1 & sa.El_deg<sa.sunel; 
        sky_right = sa.Str==2 & sa.El_deg>sa.sunel; 
        sky_left = sa.Str==2 & sa.El_deg<sa.sunel; 
        ic = 1
        for c=CM'
            sup = plot(sa.SA(sun_right),sa.rate(sun_right,wi(ic)),'^','color',c);
            sum = plot(sa.SA(sun_left),sa.rate(sun_left,wi(ic)),'v','color',c);
            skp = plot(sa.SA(sky_right),sa.rate(sky_right,wi(ic)),'+','color',c);
            skm = plot(sa.SA(sky_left),sa.rate(sky_left,wi(ic)),'o','color',c);
            ic = ic+1;
        end
        grid on
        hold off;
        xlabel('Scattering angle [deg]')
        ylabel('count rates')
        [nul,fname] = fileparts(sa.filename{1});
        title({fname;'Principal Plane'},'Interpreter','None')
        legend([sup,sum,skp,skm],{'sun above','sun below','sky above','sky bbelow'})
        colormap(CM)
        lcolorbar(string(wvls*1000.0),'TitleString','Wavelength [nm]')
        fnameout = [sa.instrumentname sa.daystr '_SKYP' sa.filen '_rate2scatteringangle'];
        fig_names = [fig_names;{fullfile(fig_path, [fnameout '.png'])}];
        save_fig(fig,fullfile(fig_path, fnameout),0);
    end
end

return
