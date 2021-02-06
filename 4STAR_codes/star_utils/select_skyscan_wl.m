function star = select_skyscan_wl(star)
% Allows wavelengths to be loaded from mat file capturing retrieval output
% or selected manually.
% Returns logical field star.wl_, indices star.wl_ii = find(star.wl_), and
% starmask (size of radsky with 1 and NaN)
% Also selects order of polynomial used to fit AOD

% Modifications:
% CJF, v1.1, 2020-07-09, added ability to set polynomial 
% CJF, v1.2, 2020-11-23, adding rfit_aod_basis, not checked yet
% CJF, v1.2, 2021-02-04, adding xfit_aod deprecating rfit_aod_basis
version_set('1.3');
if ~isavar('star')||~isstruct(star)&&isafile(star)
    star = load(getfullname('*STAR*_SKY*.mat','star_skysky_mats','Select a 4STAR sky mat file.'));
    if isfield(star,'s'); star = star.s; end
end

%skymask = star.skymask (:,star.wl_);
done = false;
suns = find(star.Str==1&star.Zn==0);
wl = 1000.*star.w;
if ~isempty(suns); suns = suns(1);end
w_fit_ii = star.w_isubset_for_polyfit; % w_ii = [225,star.w_isubset_for_polyfit];
% w_fit_ii(star.w(w_fit_ii)>1.1) = [];w_fit_ii(star.w(w_fit_ii)>.9) = [];

if length(star.wl_ii)<8
    WL_str = ['Wavelengths [nm]: ',sprintf('%4.1f,',wl(star.wl_ii))];
else
    WL_str = ['Wavelengths [nm]: ',sprintf('%3.0f,',wl(star.wl_ii(1:2))),...
        '...',sprintf('%3.0f,',wl(star.wl_ii(end-1:end)))];WL_str(end) = [];
end

man = menu({'Current wavelengths [nm]: ';WL_str ;'Select other wavelengths?'},'Manually','From file...','Done');
ORD = 3;
if man==1
    block = load(getfullname('xfit_wl_block.mat','block','Select block file indicating contiguous pixels.'));
    if isfield(block,'block') block = block.block; end;
    wl_ = false(size(star.w));
    for b = 1:size(block,1)
        wl_(block(b,3):block(b,4)) = true;
    end
    w_fit_ii = find(wl_);
    while ~done 
        
        lte0 = star.tau_aero_subtract_all(suns,w_fit_ii)<=0;  w_fit_ii(lte0) = [];
        [aod_fit] = tau_xfit(star.w,star.tau_aero_subtract_all(suns,:),block);  
        w_fit_ii(star.w(w_fit_ii)>.950 &star.w(w_fit_ii)<1.100) = [];

        tau_tot = star.tau_tot_vertical(suns,:); 
        nix = single((tau_tot<=0)|~isfinite(tau_tot)); nix(nix>0) = NaN;
        tau_tot_nix = tau_tot + nix; clear nix
        tau_sub = star.tau_aero_subtract_all(suns,:);
        nix = single((tau_sub<=0)|~isfinite(tau_sub)); nix(nix>0) = NaN; 
        tau_sub_nix = tau_sub + nix; clear nix
        tau_noray_vert = star.tau_tot_vert -star.tau_ray;
        
        figure_(1111);
        sb(2) = subplot(2,1,2);
        semilogy(wl, star.skyresp,'.',wl(star.wl_), star.skyresp(star.wl_),'ro');
        legend('all 4STAR','selected for retrieval');zoom('on')
        xlabel('wavelength');
        ylabel('responsivity');
        sb(1) = subplot(2,1,1);        
        ll = semilogy([NaN,wl(w_fit_ii)],[NaN,tau_sub_nix(w_fit_ii)], 'kx',[NaN,wl(star.wl_)],[NaN,tau_sub_nix(star.wl_)], 'ro', ...
            wl, tau_tot_nix,'-',wl, tau_sub_nix,'-', wl, aod_fit, 'm-');
        ylabel('OD');ylim([0.5.*min(aod_fit),2]);
        lg = legend('used in fit','selected for retrieval');zoom('on');
        linkaxes(sb,'x');xlim([335,1700]);
        
        opt = menu('Select pixels to be used for the fit line and pixels for the retrieval: ',...
            'Include in fit','Exclude from fit', 'Use for retrieval','Do NOT use for retrieval','Done');
        v1 = axis(sb(1)); v2 = axis(sb(2));
        v_ = wl>=v1(1) & wl<=v1(2) & tau_sub>=v1(3)&tau_sub<=v1(4)& star.skyresp >= v2(3) & star.skyresp<=v2(4) ;
        if opt==1
            w_fit_ii  = unique([w_fit_ii ,find(v_)]);
            block = return_wl_block(w_fit_ii,star.w);
        elseif opt==2
            w_fit_ii = setdiff(w_fit_ii,find(v_));% removes find(v_) from w_fit_ii
            block = return_wl_block(w_fit_ii,star.w);
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
        ll = semilogy(wl(star.wl_),tau_sub_nix(star.wl_), 'k.',wl(w_in(N_out)),tau_sub_nix(w_in(N_out)), 'ro');
        ylabel('tau'); xlabel('wavelength'); title(['Pixel spacing = ',num2str(N), ' Number of pixels = ',num2str(length(N_out))]);
        lg = legend('Retrieval pixels');zoom('on');
        hold('on');semilogy(wl, tau_sub_nix,'-',wl(w_in(N_out)),tau_sub_nix(w_in(N_out)), 'o');hold('off')
        xlim([335,1700]);ylim([0.5.*min(aod_fit),2]);
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
        in_mat = load([last_wl_path, fname,ext]); 
        if isstruct(in_mat)&&isfield(in_mat,'s') in_mat = in_mat.s; end        
    end
%     good_last_wl = false;
    if isfield(in_mat,'Wavelength')
        star.wl_ii = interp1(star.w, [1:length(star.w)],in_mat.Wavelength,'nearest');
        star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
%         good_last_wl = true;
    elseif isfield(in_mat,'wl_ii')&&isfield(in_mat,'wl_')&&(length(in_mat.wl_)==length(star.w))
        star.wl_ii = in_mat.wl_ii;
        star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
%         good_last_wl = true;
    end
    star.skymask(:,~star.wl_) = NaN; 
    star.skymask(star.good_sky,star.wl_) = 1; 
    if isfield(in_mat,'w')&&isfield(in_mat,'w_fit_ii')
        star.w_isubset_for_polyfit = in_mat.w_fit_ii;
%         good_last_wl = true;
    elseif isfield(in_mat,'w')&&isfield(in_mat,'w_isubset_for_polyfit')
        star.w_isubset_for_polyfit = in_mat.w_isubset_for_polyfit;
%         good_last_wl = true;        
    end
end
star.sky_wl = star.w(star.wl_);
star.aeronetcols = star.wl_ii;


return