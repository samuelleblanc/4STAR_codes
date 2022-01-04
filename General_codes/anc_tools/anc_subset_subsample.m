function nc = anc_subset_subsample(filelist, xsub, N)
% nc = anc_subset_subsample(filelist, xsub,N)
% optional xsub is an array of strings to be excluded from output
% optional N is an integer indicating the number of regular records per day
% to output 1-hr = 24, 1-min = 1440, 1-sec = 86400

% Load each file in filelist.  Remove fields listed in sub
% Use nearest, interp1, and anc_sift to select 

pause(.1);
if ~isavar('filelist')||isempty(filelist)
disp('Please select one or more files having the same DOD.');
[filelist] = getfullname('*.cdf;*.nc');
end
if ~isavar('xsub')
   N = 1440;
   xsub = {};
end
if isavar('xsub')
   if isnumeric(xsub)
      N = xsub;
      xsub = {};
   end
end
if ~isavar('N')
   N = 1440;
end
if ~iscell(filelist)&&isafile(filelist)
   [pname, fname, ext] = fileparts(filelist);
    nc = anc_load(filelist);
    nc.vatts = rmfield(nc.vatts,xsub);
    nc.vdata = rmfield(nc.vdata, xsub);
    nc.ncdef.vars = rmfield(nc.ncdef.vars, xsub);
    if ~isfield(nc,'quiet') nc.quiet = true; end
    nc = anc_check(nc); % fixes ids
    nc = anc_subsample(nc,N);
else
    nc = anc_load(filelist{1});
    nc.vatts = rmfield(nc.vatts,xsub);
    nc.vdata = rmfield(nc.vdata, xsub);
    nc.ncdef.vars = rmfield(nc.ncdef.vars,xsub);
    if ~isfield(nc,'quiet') nc.quiet = true; end
    nc = anc_check(nc); % fixes ids
    nc = anc_subsample(nc,N);
    [pname, fname, ext] = fileparts(filelist{1});
    for i = 2:length(filelist);
        [pname, fname, ext] = fileparts(filelist{i});
        disp(['Processing ', fname, ext,' : ', num2str(i), ' of ', num2str(length(filelist))]);
        %    do_somethin_to_it([pname dirlist(i).name], [outdir dirlist(i).name]);
        nc = anc_cat(nc,anc_subset_subsample(filelist{i},xsub,N));
        disp(['Done processing ', fname,ext]);
        
    end;
    disp(' ')
    disp(['Finished processing selected files in ' pname])
    disp(' ')
end
return