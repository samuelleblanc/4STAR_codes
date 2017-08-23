function star = select_skyscan_wl(star);
% We need to be a bit careful now that we're trying to use this iteratively
% with select_skyscan_SA because that changes the dimensionality of
% good_sky
done = false;
man = menu('Select other wavelengths?','Manually','From file...');
if man==1
   figure_(1000);
   plot(star.w, star.skyresp,'k.',star.w(star.wl_), star.skyresp(star.wl_),'ro');
   xlabel('wavelength');
   ylabel('responsivity');
   legend('all 4STAR','selected for retrieval');zoom('on')
   while ~done
      tog = menu('Zoom in to select wavelengths then select "toggle", "reset", or "done".','Toggle','Reset','Done');
      if tog==1
         xl = xlim;
         xl_ = star.w>=xl(1) & star.w<=xl(2);
         star.wl_(xl_) = ~star.wl_(xl_);
      elseif tog==2
         star.wl_ = false(size(star.w));
         star.wl_(star.aeronetcols) = true;
      else
         done = true;
      end
      plot(star.w, star.skyresp,'k.',star.w(star.wl_), star.skyresp(star.wl_),'ro');
      xlabel('wavelength');
      ylabel('responsivity');
      legend('all 4STAR','selected for retrieval');zoom('on');
   end % with wavelength selection
   %          if ~exist('wl_ii','var')
   %             wl_ii = find(star.wl_);
   %             star.wl_ii = wl_ii;
   %             skyrad = star.skyrad(:,star.wl_);
   %             good_sky = false(size(star.good_sky*wl_ii));
   %             good_sky(star.good_sky,:) = true;
   %             skymask = ones(size(skyrad));
   %             skymask(~good_sky) = NaN;
   %          end
   cla;
%    done = false;
elseif man==2 % Select an existing file as source of (additional?) wavelengths
   while ~exist('in_mat','var')||~isfield(in_mat,'Wavelength')
   in_mat = load(getfullname('*.mat','anetaip','Select an ANET AIP retreival output mat file to obtain wavelengths from.'));
   end
   star.wl_ii = interp1(star.w, [1:length(star.w)],in_mat.Wavelength,'nearest');
   star.wl_ = false(size(star.w)); star.wl_(star.wl_ii) = true;   
end
star.wl_ii = find(star.wl_);
return