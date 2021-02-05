function plot_acaods
% Code to plot 4STAR ACAOD flight ict files:

first = getfullname('4STAR*.ict','acaod');

acaod_folder = getnamedpath('acaod');

dlist = dir([getnamedpath('acaod'),'4STAR*.ict']);

done = false;
f = 1;
while ~done
    star_acaod = rd_ict([dlist(f).folder, filesep,dlist(f).name]);
    if isfield(star_acaod, 'flag_acaod')
    nomiss = star_acaod.Longitude>-900 & star_acaod.Latitude>-900&star_acaod.AOD0501>-900;
    ACAOD = star_acaod.qual_flag==0 & star_acaod.flag_acaod==1;
    figure_(15); plot(star_acaod.Longitude(nomiss), star_acaod.Latitude(nomiss),'k-'); hold('on')
    scatter(star_acaod.Longitude(nomiss), star_acaod.Latitude(nomiss),12,serial2doy(star_acaod.time(nomiss)));
    xlabel('Lon'); ylabel('Lat');
    title(['4STAR ACAOD ',datestr(star_acaod.time(1),'yyyy-mm-dd'), sprintf([' %d of %d',f, length(dlist)])]);
    sa = gca; 
%     sa.XAxis.Direction = 'reverse'; 
    xl = xlim; 
    hold('off')
    figure_(16); 
    sb(1) = subplot(2,1,1);
    plot(star_acaod.time(star_acaod.qual_flag==0&star_acaod.AOD0501>-900), ...
        star_acaod.GPS_Alt(star_acaod.qual_flag==0&star_acaod.AOD0501>-900), 'o-',...
       star_acaod.time(ACAOD), star_acaod.GPS_Alt(ACAOD),'r*'); 
    legend('Alt'); dynamicDateTicks; zoom('on');
    title(['4STAR ACAOD ',datestr(star_acaod.time(1),'yyyy-mm-dd'), sprintf([' %d of %d',f, length(dlist)])]);
    sb(2) = subplot(2,1,2);
    
    if sum(ACAOD)>0
        plot(star_acaod.time(nomiss), star_acaod.AOD0501(nomiss),'o-',...
            star_acaod.time(nomiss&ACAOD), star_acaod.AOD0501(nomiss&ACAOD),'r*'); dynamicDateTicks
        legend('ACAOD 501 nm'); zoom('on');
        linkaxes(sb,'x');logy; ylim([1e-2, 1])
    else
        cla(sb(2));
    end
    mn = menu({[sprintf('Showing file %d of %d: ',f, length(dlist)), ' Zoom as desired.'];...
        [' When finished select as below:']},'Next','Previous','Save','Done/Exit');
    if mn==1
        f = f + 1;
    elseif mn ==2
        f = f-1;
    elseif mn == 3
        [~,fname,~] =fileparts(dlist(f).name);
        outfile = [dlist(f).folder,filesep,fname,'.fig'];
        n = 1;
        while isafile(outfile)
            n = n+1;
           outfile = [dlist(f).folder,filesep,fname,'_',num2str(n),'.fig'];
        end
       saveas(gcf, outfile);
       saveas(gcf, strrep(outfile,'.fig','.png'));
    elseif mn == 4
        done = true;
    end
    else
        f = f +1;
    end
    if f == 0; f = length(dlist); end
    if f > length(dlist); f = 1; end; 
end
    