function star = handselect_skyscan(star)
% Manually select data points in a sky scan.  This might look a lot like
% starsky_scan
% s = handscreen_skyscan(s)
% apply manual/graphical screen to sky scan to eliminate bad angles.
% this uses the current star struct, not my old one

done = false;
wl_ = false(size(star.w));
wl_(star.aeronetcols) = true;

fini = false;
while ~fini
    
    figure(1000);
    plot(star.w, star.skyresp,'k.',star.w(wl_), star.skyresp(wl_),'ro');
    xlabel('wavelength');
    ylabel('responsivity');
    legend('all 4STAR','selected for retrieval');zoom('on')
    while ~done
        tog = menu('Zoom in to select wavelengths then select "toggle", "reset", or "done".','Toggle','Reset','Done');
        if tog==1
            xl = xlim;
            xl_ = star.w>=xl(1) & star.w<=xl(2);
            wl_(xl_) = ~wl_(xl_);
        elseif tog==2
            wl_ = false(size(star.w));
            wl_(star.aeronetcols) = true;
        else
            done = true;
        end
        plot(star.w, star.skyresp,'k.',star.w(wl_), star.skyresp(wl_),'ro');
        xlabel('wavelength');
        ylabel('responsivity');
        legend('all 4STAR','selected for retrieval');zoom('on')
    end
    good_fields = fieldnames(star);
    for fld = length(good_fields):-1:1
        field = good_fields{fld};
        if isempty(strfind(field,'good'))||strfind(field,'good')~=1
            good_fields(fld) = [];
        end
    end
     for fld = length(good_fields):-1:1
        field = good_fields{fld};
        if all(size(star.t)==size(star.(field)'))
            star.(field) = star.(field)';
        end
     end   
    
    if ~exist('wl_ii','var')
        wl_ii = find(wl_);
        star.wl_ii = wl_ii;
        star.wl_ = wl_;
        skyrad = star.skyrad(:,wl_);
        good_sky = false(size(star.good_sky*wl_ii));
        if sum(star.good_sky)==0
            if isfield(star,'good_almA')
                star.good_sky = star.good_almA|star.good_almB;
            elseif isfield(star,'good_ppl')
                star.good_sky = star.good_ppl;
            end 
        else
            star.good_sky = true(size(star.Str==2));
        end
        good_sky(star.good_sky,:) = true;
        skymask = ones(size(skyrad));
        skymask(~good_sky) = NaN;
    end
    cla;
    done = false;
    
    % good_time_base = star.Str==2&star.El_gnd>0 ;
    % semilogy(DA(star.Str==2&good_time_base&star.good_almA), ...
    %     star.skyrad(star.Str==2&good_time_base&star.good_almA,wl_),'-o',...
    %     DA(star.Str==2&good_time_base&star.good_almB), ...
    %     star.skyrad(star.Str==2&good_time_base&star.good_almB,wl_),'-x');
    
    %     below = ((star.sunel - star.SA)-star.El_gnd)<1;
    
    while ~done
        ang = star.SA;
        x_type = 2;
        %         x_type = menu('Choose x-axis style:','Scattering angle (positive only)','Difference angle (pos and neg)');
        
        if x_type ==2
            if ~star.isPPL
                ang(star.good_almB) = -ang(star.good_almB);
            end
        end
        
        if star.isPPL
            
            !Was for alm
            linesA = semilogy(ang(star.good_ppl), ...
                skyrad(star.good_ppl,:).*skymask(star.good_ppl,:),'.-');
            for la = 1:length(linesA)
                tx = text(ang(star.good_ppl), ...
                    skyrad(star.good_ppl,la).*skymask(star.good_ppl, la),'U','color',...
                    get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
            end
            xlabel('scattering angle [degrees]');
            ylabel('mW/(m^2 sr nm)');
            title('Select or reject points for retrieval','interp','none')
            grid('on'); set(gca,'Yminorgrid','off');
            %         leg_str{1} = sprintf('%2.0f nm',star.w(wl_ii(1))*1000);
            %         for ss = 2:length(wl_ii)
            %             leg_str{ss} = sprintf('%2.0f nm',star.w(wl_ii(ss))*1000);
            %         end
            %         legend(leg_str,'location','northeast');
            %         hold('on')
            %         linesB = semilogy(ang(star.good_almB), ...
            %             skyrad(star.good_almB,:).*skymask(star.good_almB,:),'-');
            %         semilogy(ang(star.good_almB&star.sat_time), skyrad(star.good_almB&star.sat_time,:), 'ro','markerface','k' );
            %         for la = 1:length(linesB)
            %             tx = text(ang(star.good_almB), ...
            %                 skyrad(star.good_almB,la).*skymask(star.good_almB,la),'R','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
            %         end
            %         hold('off')
            %         xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))]);
            
        else
            linesA = semilogy(ang(star.good_almA), ...
                skyrad(star.good_almA,:).*skymask(star.good_almA,:),'.-');
            for la = 1:length(linesA)
                tx = text(ang(star.good_almA), ...
                    skyrad(star.good_almA,la).*skymask(star.good_almA, la),'L','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
            end
            xlabel('scattering angle [degrees]');
            ylabel('mW/(m^2 sr nm)');
            title('Select or reject points for retrieval','interp','none')
            grid('on'); set(gca,'Yminorgrid','off');
            leg_str{1} = sprintf('%2.0f nm',star.w(wl_ii(1))*1000);
            for ss = 2:length(wl_ii)
                leg_str{ss} = sprintf('%2.0f nm',star.w(wl_ii(ss))*1000);
            end
            legend(leg_str,'location','northeast');
            hold('on')
            linesB = semilogy(ang(star.good_almB), ...
                skyrad(star.good_almB,:).*skymask(star.good_almB,:),'-');
%             semilogy(ang(star.good_almB&star.sat_time), skyrad(star.good_almB&star.sat_time,:), 'ro','markerface','k' );
            for la = 1:length(linesB)
                tx = text(ang(star.good_almB), ...
                    skyrad(star.good_almB,la).*skymask(star.good_almB,la),'R','color',get(linesA(la),'color'),'fontname','tahoma','fontsize',7,'fontweight','demi');
            end
            hold('off')
            %         xlim([0,85+star.sza(1)-max(abs(star.pitch))-max(abs(star.roll))]);
        end
        zoom('on');
        
        act = menu('Now zoom in to specific regions and select the desired action, or exit','Include','Exclude','Toggle','ONLY these', 'No change', 'Done/Exit');
        if act==6
            done = true;
        else
            % Now zoom in and include, toggle, or exclude
            
            %         skyrad = star.skyrad(:,wl_);
            %         skymask = zeros(size(skyrad));
            v = axis;
            for wi = 1:length(wl_ii)
                in_bounds =  ang>=v(1)&ang<=v(2)&skyrad(:,wi)>=v(3)&skyrad(:,wi)<=v(4)&star.Str==2;
                if act ==1
                    good_sky(in_bounds,wi) = true;
                elseif act==2
                    good_sky(in_bounds,wi) = false;
                elseif act==3
                    good_sky(in_bounds,wi) = ~good_sky(in_bounds,wi);
                elseif act==4
                    good_sky(:,wi) = false;
                    good_sky(in_bounds,wi) = true;
                end
            end
            skymask(good_sky) = 1;
            skymask(~good_sky) = NaN;
        end        
    end
    star.good_sky = good_sky;
    star.skymask = skymask;
    %%
      if ~isfield(star,'PWV')
            star.PWV = 1.7;
        end
        if ~isfield(star,'O3col')
            star.O3col=0.330;
        end
        if star.O3col>1
            star.O3col = star.O3col./1000;
        end
        if ~isfield(star,'wind_speed')
            star.wind_speed= 7.5;
        end
        % for SEAC4RS
        star.land_fraction = 1;
        % Should replace this with an actual determination based on a land-surface
        % mapping.
        star.rad_scale = 1; % This is an adhoc means of adjusting radiance calibration for whatever reason.
        star.ground_level = star.flight_level/1000; % picking very low "ground level" sufficient for sea level or AMF ground level.
        % Should replace this with an actual determination based on a land-surface mapping.
        % Both gen_sky_inp_4STAR and gen_aip_cimel_need to be modified.
        pname_tagged = 'C:\z_4STAR\work_2aaa__\4STAR_\';
        if isfield(star,'filename')
            [p,skytag,x] = fileparts(star.filename);
            skytag = strrep(skytag,'_VIS_','_');skytag = strrep(skytag,'_NIR_','_');
        end
        tag = [skytag,'.created_',datestr(now, 'yyyymmdd_HHMMSS'),'.'];
        %
        %     desc = input('Add a descriptive tag for this input file (such as "alm_L", alm_R", "superset", "subset", etc.).','s');
        %     tag = strrep(tag, '..', ['.',desc,'.']);
        fname_tagged = ['4STAR_.',tag, 'input'];
        star.pname_tagged = pname_tagged;
        star.fname_tagged = fname_tagged;
        [inp, line_num] = gen_sky_inp_4STAR(star);
        disp(['This selection has been saved to ',fname_tagged]);
    %%
    again = menu('Define another?',['No, I''m done'],'Yes, another');
    if again == 1        
        fini = true;
    else

        % fini = menu('Done with point selection?','Not done','Done');
        % if fini==2
        %     done = true;
        % end
      
    end
    
end

return