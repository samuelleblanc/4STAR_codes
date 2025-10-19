function [new_Co, w, viscols, nircols] = star_ref2anet(star)
% star = star_ref2anet(star)
% Select a starsun file and reference against collocated AERONET AODs
% Returns the entire selected starsun file in "star" plus new Co
% calibrations in field c0_anet
% Connor, 2025/05/17
%---------------------------------------------------------------------
version_set('1.0');

if  ~isavar('star')||isempty(star)
    sp = set_starpaths;
    star = load(getfullname([sp.starsun,'*starsun*.mat'],'starsun'));
end
bad_tel = star.Lat==0|star.Lon==0|star.Alt==0;
star.Lat(bad_tel) = NaN; star.Lon(bad_tel) = NaN; star.Alt(bad_tel)=NaN;
star.rate(star.rate<=0) = NaN;
done = false;
vis_i = interp1(star.w(star.viscols), star.viscols,[340, 380, 440, 500, 675, 870]./1000, 'nearest');
nir_i = interp1(star.w(star.nircols), star.nircols,[1020, 1640]./1000, 'nearest');
figure_(123);
sb(1) = subplot(4,1,1); plot(star.t, star.Alt,'o'); dynamicDateTicks; legend('Alt')
sb(2) = subplot(4,1,2); plot(star.t, star.Lat,'gx'); dynamicDateTicks; legend('Lat')
sb(3) = subplot(4,1,3); plot(star.t, star.Lon,'r+'); dynamicDateTicks; legend('Lon')
sb(4) = subplot(4,1,4); plot(star.t, star.rate(:,vis_i(4)),'*'); dynamicDateTicks; legend('Lon')
linkaxes(sb,'x')

    mn = menu('Select desired time range to process. ','When done selecting, click HERE', 'QUIT, I''m finished.');
    if mn ~=1
        done = true;
    else
        xl = xlim; xl_ = star.t>xl(1) & star.t<xl(2); xl_i = find(xl_);
        Lat = nanmean(star.Lat(xl_)); Lon = nanmean(star.Lon(xl_));
        % NASA_Ames, -122.056969,37.419986
        % Monterey,-121.854867,36.592550
        % Marina, -121.787993,36.806284
        % Marina_Airport_CA -121.763243,36.673889
        % NRL_CEOBS_MBAYCAUSA, -121.840389,36.905678

        site_names = {'NASA_Ames','Monterey','Marina','Marina_Airport_CA','NRL_CEOBS_MBAYCAUSA'};
        site_coords = [-122.056969,37.419986; -121.854867,36.592550; -121.787993,36.806284; -121.763243,36.673889;  -121.840389,36.905678];
        dists = geodist(Lat, Lon, site_coords(:,2), site_coords(:,1))./1000;
        [dist,ind] = min(dists);
        anet_site = site_names{ind}; anet_site = 'Marina_Airport_CA';
        cimel = wget_cimel_aod_v3(min(star.t), max(star.t), anet_site, 'TOT15');
        Tr_340 = exp(-cimel.AOD_340nm_Total.*cimel.Optical_Air_Mass);
        Tr_380 = exp(-cimel.AOD_380nm_Total.*cimel.Optical_Air_Mass);
        Tr_440 = exp(-cimel.AOD_440nm_Total.*cimel.Optical_Air_Mass);
        Tr_500 = exp(-cimel.AOD_500nm_Total.*cimel.Optical_Air_Mass);
        Tr_675 = exp(-cimel.AOD_675nm_Total.*cimel.Optical_Air_Mass);
        Tr_870 = exp(-cimel.AOD_870nm_Total.*cimel.Optical_Air_Mass);
        Tr_1020 = exp(-cimel.AOD_1020nm_Total.*cimel.Optical_Air_Mass);
        Tr_1640 = exp(-cimel.AOD_1640nm_Total.*cimel.Optical_Air_Mass);

        [sinc, cins] = nearest(star.t(xl_i), cimel.time);

        tz = double(floor(star.Lon./15)./24);
        [sza, saz,~,~,~,~,am] = sunae(star.Lat, star.Lon, star.t);
        esr = gueymard_ESR; star.esr = interp1(esr(:,1), esr(:,3), 1000.*star.w,'linear');

        Cos = NaN(length(sinc), length(star.c0));
        Cos(:,vis_i(1)) = star.rate(xl_i(sinc),vis_i(1))./Tr_340(cins); Co =Cos(:,vis_i(1));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,vis_i(1)) = Co;

        Cos(:,vis_i(2)) = star.rate(xl_i(sinc),vis_i(2))./Tr_380(cins); Co =Cos(:,vis_i(2));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,vis_i(2)) = Co;

        Cos(:,vis_i(3)) = star.rate(xl_i(sinc),vis_i(3))./Tr_440(cins); Co =Cos(:,vis_i(3));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,vis_i(3)) = Co;

        Cos(:,vis_i(4)) = star.rate(xl_i(sinc),vis_i(4))./Tr_500(cins); Co =Cos(:,vis_i(4));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,vis_i(4)) = Co;

        Cos(:,vis_i(5)) = star.rate(xl_i(sinc),vis_i(5))./Tr_675(cins); Co =Cos(:,vis_i(5));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,vis_i(5)) = Co;

        Cos(:,vis_i(6)) = star.rate(xl_i(sinc),vis_i(6))./Tr_870(cins); Co =Cos(:,vis_i(6));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,vis_i(6)) = Co;

        Cos(:,nir_i(1)) = star.rate(xl_i(sinc),nir_i(1))./Tr_1020(cins); Co =Cos(:,nir_i(1));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>2) = NaN;
        Cos(:,nir_i(1)) = Co;

        Cos(:,nir_i(2)) = star.rate(xl_i(sinc),nir_i(2))./Tr_1640(cins); Co =Cos(:,nir_i(2));
        mn = nanmean(Co); AD = abs(Co-mn); fac = AD./nanmean(AD); Co(fac>1) = NaN;
        Cos(:,nir_i(2)) = Co;

        % figure; plot(star.t(sinc), Cos(:,nir_i(1))./ Cos(:,nir_i(2)),'ro');

        new_Co = NaN(size(star.c0));
        resp_a_vis = nanmean(Cos(:,star.viscols))./star.esr(star.viscols);
        ok = find(~isnan(resp_a_vis));
        resp_a_vis(ok+1) = resp_a_vis(ok);resp_a_vis(ok-1) = resp_a_vis(ok);
        resp_b_vis = star.skyresp(star.viscols);  % using skyresp as a placeholder for a lab-measured sun resp.
        resp_c_vis = patch_ab(star.w(star.viscols), resp_a_vis, star.w(star.viscols), resp_b_vis);

        resp_a_nir = nanmean(Cos(:,star.nircols))./star.esr(star.nircols);
        ok = find(~isnan(resp_a_nir));
        resp_a_nir(ok+1) = resp_a_nir(ok);resp_a_nir(ok-1) = resp_a_nir(ok);
        resp_b_nir = star.skyresp(star.nircols); % using skyresp as a placeholder for a lab-measured sun resp.
        resp_c_nir = patch_ab(star.w(star.nircols), resp_a_nir, star.w(star.nircols), resp_b_nir);

        new_Co(star.viscols) = resp_c_vis.*star.esr(star.viscols);
        new_Co(star.nircols) = resp_c_nir.*star.esr(star.nircols);

        Tr = star.rate./new_Co;
        TOT = -real(log(Tr)./star.m_aero);
        AOT = TOT - star.tau_ray;

        figure; plot(star.t, [AOT(:,vis_i), AOT(:,nir_i(1))],'.', cimel.time, ...
            [cimel.AOD_340nm_AOD, cimel.AOD_380nm_AOD, cimel.AOD_440nm_AOD, cimel.AOD_500nm_AOD,cimel.AOD_675nm_AOD, cimel.AOD_870nm_AOD,cimel.AOD_1020nm_AOD],'x');
        dynamicDateTicks; xlim(xl)
        legend('*340','*380','*440','*500','*675','*870','*1020','Cimel 340','Cimel 380','Cimel 440','Cimel 500','Cimel 675','Cimel 870','Cimel 1020')

        plot(star.t, AOT(:,vis_i(1:3)),'.', cimel.time(cins), [cimel.AOD_340nm_AOD(cins),cimel.AOD_380nm_AOD(cins),cimel.AOD_440nm_AOD(cins)],'x');
        dynamicDateTicks; xlim(xl)
        legend('*340','*380','*440','Cimel 340','Cimel 380','Cimel 440')

        plot(star.t, AOT(:,vis_i(4:6)),'.', cimel.time(cins), [cimel.AOD_500nm_AOD(cins),cimel.AOD_675nm_AOD(cins),cimel.AOD_870nm_AOD(cins)],'x');
        dynamicDateTicks;xlim(xl)
        legend('*500','*675','*870','Cimel 500','Cimel 675','Cimel 870')

        plot(star.t, AOT(:,nir_i),'.', cimel.time(cins), [cimel.AOD_1020nm_AOD(cins),cimel.AOD_1640nm_AOD(cins)],'x');
        dynamicDateTicks;
        legend('*1020','*1640','Cimel 1020','Cimel 1640')

        star.c0_anet = new_Co; visc0 = new_Co(star.viscols); nirc0 = new_Co(star.nircols);

        additionalnotes={'Calibration by reference to Cimel. '};
        filesuffix = input('Enter a concise file suffix: ','s')
        daystr=[datestr(mean(star.t(sinc)),'yyyymmdd')]; %leg{i_avg(end)}(end-7:end);
        visfilename=fullfile(getnamedpath('stardat'), [daystr '_VIS_C0_' filesuffix '.dat']);
        nirfilename=fullfile(getnamedpath('stardat'), [daystr '_NIR_C0_' filesuffix '.dat']);

        vissource_alt={[]}; %cellstr(char(vis_names{i_avg}));
        nirsource_alt=[]; % cellstr(char(nir_names{i_avg}));
        vissource = '(SEE Original files for sources)';
        nirsource = '(SEE Original files for sources)';

        starsavec0(visfilename, vissource, [additionalnotes; vissource_alt], star.w(star.viscols), visc0, NaN(size(visc0)));
        starsavec0(nirfilename, nirsource, [additionalnotes; nirsource_alt], star.w(star.nircols), nirc0, NaN(size(nirc0)));
    end

w = star.w; viscols = star.viscols; nircols = star.nircols;
end