function star = select_skyscan_wl(star)
% Allows wavelengths to be loaded from mat file capturing retrieval output
% or selected manually.
% Returns logical field star.wl_, indices star.wl_ii = find(star.wl_), and
% starmask (size of radsky with 1 and NaN)
if ~isavar('star')||~isstruct(star)&&isafile(star)
    star = load(getfullname('*STAR*_SKY*.mat','star_skysky_mats','Select a 4STAR sky mat file.'));
    if isfield(star,'s'); star = star.s; end
end

%skymask = star.skymask (:,star.wl_);
done = false;
suns = find(star.Str==1&star.Zn==0);
if ~isempty(suns); suns = suns(1);end
w_fit_ii = star.w_isubset_for_polyfit; % w_ii = [225,star.w_isubset_for_polyfit];
% w_fit_ii(star.w(w_fit_ii)>1.1) = [];w_fit_ii(star.w(w_fit_ii)>.9) = [];

if length(star.wl_ii)<8
    WL_str = ['Wavelengths [nm]: ',sprintf('%4.1f,',1000.*star.w(star.wl_ii))];
else
    WL_str = ['Wavelengths [nm]: ',sprintf('%3.0f,',1000.*star.w(star.wl_ii(1:2))),...
        '...',sprintf('%3.0f,',1000.*star.w(star.wl_ii(end-1:end)))];WL_str(end) = [];
end

man = menu({'Current wavelengths [nm]: ';WL_str ;'Select other wavelengths?'},'Manually','From file...','Done');
if man==1
    while ~done
        PP_ = polyfit(log(star.w(w_fit_ii)), real(log(star.tau_aero_subtract_all(suns,w_fit_ii))),3);
        tau_line = exp(polyval(PP_,log(star.w)));
        tau_aero = star.tau_tot_vertical(suns,:); tau_sub = star.tau_aero_subtract_all(suns,:);
        figure_(1111);
        sb(2) = subplot(2,1,2);
        loglog(star.w, star.skyresp,'.',star.w(star.wl_), star.skyresp(star.wl_),'ro');
        legend('all 4STAR','selected for retrieval');zoom('on')
        xlabel('wavelength');
        ylabel('responsivity');
        sb(1) = subplot(2,1,1);
        ll = loglog([NaN,star.w(w_fit_ii)],[NaN,tau_sub(w_fit_ii)], 'kx',[NaN,star.w(star.wl_)],[NaN,tau_sub(star.wl_)], 'ro', star.w, tau_aero,'-',star.w, tau_sub,'-', star.w, tau_line, 'm-');
        ylabel('OD');ylim([0.9.*min(tau_line),1.1.*max(tau_line)]);
        lg = legend('used in fit','selected for retrieval');zoom('on');
        linkaxes(sb,'x');xlim([.335,1.7]);
        
        opt = menu('Select pixels to be used for the fit line and pixels for the retrieval: ',...
            'Include in fit','Exclude from fit', 'Use for retrieval','Do NOT use for retrieval','Done');
        v1 = axis(sb(1)); v2 = axis(sb(2));
        v_ = star.w>=v1(1) & star.w<=v1(2) & tau_sub>=v1(3)&tau_sub<=v1(4)& star.skyresp >= v2(3) & star.skyresp<=v2(4) ;
        if opt==1
            w_fit_ii  = unique([w_fit_ii ,find(v_)]);
        elseif opt==2
            w_fit_ii = setdiff(w_fit_ii,find(v_));% removes find(v_) from w_fit_ii
        elseif opt==3
            star.wl_(v_) = true;             
            star.skymask(star.good_sky,v_)= 1; 
        elseif opt==4
            star.wl_(v_) = false; 
            star.skymask(:,v_) = NaN;
        else
            done = true;
        end
    end % with wavelength selection
    star.w_isubset_for_polyfit = w_fit_ii; star.wl_ii = find(star.wl_); star.sky_wl = star.w(star.wl_);
    close(1111)
    done = false; N = 1;
    w_in = find(star.wl_);

    while ~done
        N_out = [N:N:length(w_in)];
        figure_(1111);
        ll = loglog(star.w(star.wl_),tau_sub(star.wl_), 'k.',star.w(w_in(N_out)),tau_sub(w_in(N_out)), 'ro');
        ylabel('tau'); xlabel('wavelength'); title(['Pixel spacing = ',num2str(N), ' Number of pixels = ',num2str(length(N_out))]);
        lg = legend('used in fit');zoom('on');
        hold('on');loglog(star.w, tau_sub,'-',star.w(w_in(N_out)),tau_sub(w_in(N_out)), 'ro');hold('off')
        xlim([.335,1.7]);ylim([0.9.*min(tau_line),1.1.*max(tau_line)]);
         mn = menu('Adjust pixel spacing of retrieval wavelengths?','+','-','Done');
        if mn==1
            N = min([N+1,floor(length(w_in)./2)]);
        elseif mn == 2
            N = max([1,N-1]);
        else
            done = true;
        end
    end
    star.wl_ = false(size(star.wl_)); 
    star.wl_(w_in(N_out)) = true; star.wl_ii = find(star.wl_);
    star.skymask(:,~star.wl_) = NaN;
    star.skymask(star.good_sky,star.wl_) = 1;
    
    
elseif man==2 % Select an existing file as source of (additional?) wavelengths
    clear in_mat
    while ~exist('in_mat','var')
        last_wl_path = getfullname('*.mat','last_wl','Select skyscan mat file (eg ANET AIP retrieval output) to load wavelengths from.');
        [last_wl_path, fname,ext] = fileparts(last_wl_path); last_wl_path = [last_wl_path,filesep];
        in_mat = load([last_wl_path, fname,ext]); save([last_wl_path,'last_wl.mat'],'-struct','in_mat');
    end
    if isfield(in_mat,'Wavelength')
        star.wl_ii = interp1(star.w, [1:length(star.w)],in_mat.Wavelength,'nearest');
        star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
    elseif isfield(in_mat,'wl_ii')&&isfield(in_mat,'wl_')&&(length(in_mat.wl_)==length(star.w))
        star.wl_ii = in_mat.wl_ii;
        star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
    end
    star.skymask(:,~star.wl_) = NaN; 
    star.skymask(star.good_sky,star.wl_) = 1; 
    if isfield(in_mat,'w')&&isfield(in_mat,'w_fit_ii')
        star.w_isubset_for_polyfit = in_mat.w_fit_ii;
    end
end
star.sky_wl = star.w(star.wl_);
star.aeronetcols = star.wl_ii;
% in_mat = load([last_wl_path, 'last_wl.mat']);
% Now we have to make sure that skymask captures the new selected WLs
% This may be mostly legacy code since now we require identical WLs at all
% SA.  Would be good to be able to relax this constraint to use NIR for AOD
% and not require sky radiances from NIR

% skymask = star.skymask(:,star.wl_);
% if size(star.wl_ii,1)>size(star.wl_ii,2); star.wl_ii = star.wl_ii';end
% 
% % sky_wl returns the actual WL as opposed to the pixel indices.
% if ~isfield(star,'sky_wl')
%     star.sky_wl = star.w(star.wl_);
%     good_sky = false(size(star.good_sky*star.wl_ii));
%     good_sky(star.good_sky,:) = true;
%     skymask(~good_sky) = NaN;    
% else
%     if length(star.sky_wl)~=sum(star.wl_) || ~all(star.sky_wl==star.w(star.wl_))
%         sky_wl_ii = interp1(star.w, [1:length(star.w)],star.sky_wl,'nearest');% old
%         [~, sky_ii,sky_ij] = intersect(sky_wl_ii,star.wl_ii);
%         [~,ii_new] = setxor(star.wl_ii,sky_wl_ii);
%         skymask(:,sky_ij) = star.skymask(:,sky_ii);
%         skymask(:,ii_new) = any(star.skymask,2)*ones([1,length(ii_new)]);
%         
%         if size(star.good_sky,2)==1
%             good_sky = star.good_sky*ones([1,length(sky_ii)]);
%         else
%             good_sky(:,sky_ij) = star.good_sky(:,sky_ii);
%             good_sky(:,ii_new) = any(star.good_sky,2)*ones([1,length(ii_new)]);
%         end
%         star.sky_wl = star.w(star.wl_);
%         star.wl_ii = find(star.wl_);
%     end
% end
% star.good_sky = good_sky;
% star.skymask = skymask;

return