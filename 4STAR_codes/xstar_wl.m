function wl = xstar_wl(s)
% returns wavelength for supplied nSTAR spectrometer
% wl is returned increasing with wavelength

if isfield(s,'filename')
   if iscell(s.filename)
      fname = s.filename{1};
   else
      fname = s.filename;
   end
end
[~, fname] = fileparts(fname);

if ~isempty(strfind(fname, '2STAR'))
   wl = get_2STAR_VIS_wl(s.t(1));
elseif ~isempty(strfind(fname, '4STARB'))
   if ~isempty(strfind(fname, 'VIS'))&&isfield(s,'raw')&&(size(s.raw,2)==1044)
      % This is 4STARB VIS
      wl = get_4STARB_VIS_wl(s.t(1));
   elseif ~isempty(strfind(fname, 'NIR'))&&isfield(s,'raw')&&(size(s.raw,2)==512)
      % This is 4STARB NIR
      wl = get_4STARB_NIR_wl(s.t(1));
   end
   
elseif ~isempty(strfind(fname, '4STAR'))
   if ~isempty(strfind(fname, 'VIS'))&&isfield(s,'raw')&&(size(s.raw,2)==1044)
      % This is 4STAR VIS
      wl = get_4STAR_VIS_wl(s.t(1));
   elseif ~isempty(strfind(fname, 'NIR'))&&isfield(s,'raw')&&(size(s.raw,2)==512)
      % This is 4STAR NIR
      wl = get_4STAR_NIR_wl(s.t(1));
   end
else
   yyyy = strtok(fname, '_');
   yyyy = datenum(yyyy, 'yyyymmdd');
   if yyyy>datenum(2006,1,1)&&yyyy<datenum(2016,7,2)
      if ~isempty(strfind(fname, 'VIS'))&&isfield(s,'raw')&&(size(s.raw,2)==1044)
         % This is 4STAR VIS
         wl = get_4STAR_VIS_wl(s.t(1));
      elseif ~isempty(strfind(fname, 'NIR'))&&isfield(s,'raw')&&(size(s.raw,2)==512)
         % This is 4STAR NIR
         wl = get_4STAR_NIR_wl(s.t(1));
      end
   end
end

return