function star = select_skyscan_wl(star);
% Allows wavelengths to be loaded from mat file capturing retrieval output
% or selected manually.
% Returns logical field star.wl_ and indices star.wl_ii = find(star.wl_)
done = false;
% last_wl_path = getnamedpath('last_wl');
% if isafile([last_wl_path,'last_wl.mat'])
%    in_mat = load([last_wl_path, 'last_wl.mat']);
%    if isfield(in_mat,'Wavelength')
%       star.wl_ii = interp1(star.w, [1:length(star.w)],in_mat.Wavelength,'nearest');
%       star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
%    elseif isfield(in_mat,'wl_ii')&&isfield(in_mat,'wl_')&&(length(in_mat.wl_)==length(star.w))
%       star.wl_ii = in_mat.wl_ii;
%       star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;
%    end
% end

man = menu({'Current wavelengths [nm]: ';sprintf('%4.0f ',1000.*star.w(star.wl_ii)) ;'Select other wavelengths?'},'Manually','From file...','Done');
if man==1
   figure_(1000);
   plot(star.w, star.skyresp,'k.',star.w(star.wl_), star.skyresp(star.wl_),'ro');
   xlabel('wavelength');
   ylabel('responsivity');
   legend('all 4STAR','selected for retrieval');zoom('on')
   while ~done
      tog = menu('Zoom in to select pixels then select "toggle", "reset", or "done".','Toggle','Reset','Done');
      if tog==1
         v = axis;
         v_ = star.w>=v(1) & star.w<=v(2) & star.skyresp >= v(3) & star.skyresp<=v(4);
         star.wl_(v_) = ~star.wl_(v_);
         %           xl = xlim;
         %          xl_ = star.w>=xl(1) & star.w<=xl(2);
         %          star.wl_(xl_) = ~star.wl_(xl_);
      elseif tog==2
         star.wl_ = false(size(star.w));
         star.wl_(star.aeronetcols) = true;
      else
         done = true;
      end
      plot(star.w, star.skyresp,'k.',star.w(star.wl_), star.skyresp(star.wl_),'ro');
      xlabel('wavelength');
      ylabel('responsivity');
      legend('all 4STAR','Pixels selected for retrieval');zoom('on');
   end % with wavelength selection
   star.wl_ii = find(star.wl_);
   cla;
   %    done = false;
elseif man==2 % Select an existing file as source of (additional?) wavelengths
   clear in_mat
   while ~exist('in_mat','var')
      last_wl_path = getfullname('*.mat','last_wl','Select skyscan mat file (eg ANET AIP retreival output) to load wavelengths from.')
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
end

% in_mat = load([last_wl_path, 'last_wl.mat']);
% Now we have to make sure that skymask captures the new selected WLs
% This may be mostly legacy code since now we require identical WLs at all
% SA.  Would be good to be able to relax this constraint to use NIR for AOD
% and not require sky radiances from NIR
skyrad = star.skyrad(:,star.wl_);
skymask = ones(size(skyrad));
wl_ii = star.wl_ii;
% sky_wl returns the actual WL as opposed to the pixel indices.
if ~isfield(star,'sky_wl')
   star.sky_wl = star.w(star.wl_);
   good_sky = false(size(star.good_sky*star.wl_ii));
   good_sky(star.good_sky,:) = true;
   skymask(~good_sky) = NaN;
   
else
   if length(star.sky_wl)~=sum(star.wl_) || ~all(star.sky_wl==star.w(star.wl_))
      sky_wl_ii = interp1(star.w, [1:length(star.w)],star.sky_wl,'nearest');% old
      [~, sky_ii,sky_ij] = intersect(sky_wl_ii,star.wl_ii);
      [~,ii_new] = setxor(star.wl_ii,sky_wl_ii);
      skymask(:,sky_ij) = star.skymask(:,sky_ii);
      skymask(:,ii_new) = any(star.skymask,2)*ones([1,length(ii_new)]);
      
      if size(star.good_sky,2)==1        
         good_sky = star.good_sky*ones([1,length(sky_ii)]);
      else 
         good_sky(:,sky_ij) = star.good_sky(:,sky_ii);
         good_sky(:,ii_new) = any(star.good_sky,2)*ones([1,length(ii_new)]);         
      end
      star.sky_wl = star.w(star.wl_);
   else
      skymask = star.skymask;
      good_sky = star.good_sky;
   end
end
star.good_sky = good_sky;
star.skymask = skymask;

return