% Function
%    function [aero] = aeronet_read_lev(fname)
%
% Input:
%    fname - string with full path and file name.
%
% Output:
%    aero - a Matlab object with all info from input file.
%
% Header (5 lines): 
%    
%    Level 2.0. Quality Assured Data.<p>The following data are pre and ...
%        post field calibrated, automatically cloud cleared and manually inspected.
%    
%    Version 3 Direct Sun Algorithm
%    
%    Location=Ji_Parana,long=-61.800,lat=-10.860,elev=100,Nmeas=7,PI=Brent ...
%             Holben,Email=brent@aeronet.gsfc.nasa.gov
%    
%    AOD Level 2.0,All Points,UNITS can be found at,,, http:// ...
%        aeronet.gsfc.nasa.gov/data_menu.html
%    
%    Date(dd-mm-yy),Time(hh:mm:ss),Julian_Day,AOT_1640,AOT_1020,AOT_870, ...
%        AOT_675,AOT_667,AOT_555,AOT_551,AOT_532,AOT_531,AOT_500, ...
%        AOT_490,AOT_443,AOT_440,AOT_412,AOT_380,AOT_340,Water(cm),% ...
%        TripletVar_1640,%TripletVar_1020,%TripletVar_870,% ...
%        TripletVar_675,%TripletVar_667,%TripletVar_555,%TripletVar_551, ...
%        %TripletVar_532,%TripletVar_531,%TripletVar_500,% ...
%        TripletVar_490,%TripletVar_443,%TripletVar_440,%TripletVar_412, ...
%        %TripletVar_380,%TripletVar_340,%WaterError,440-870Angstrom, ...
%        380-500Angstrom,440-675Angstrom,500-870Angstrom,340- ...
%        440Angstrom,440-675Angstrom(Polar),...
%        Last_Processing_Date(dd/mm/yyyy), ...
%        Solar_Zenith_Angle,SunphotometerNumber,AOT_1640- ...
%        ExactWavelength(nm),AOT_1020-ExactWavelength(nm),AOT_870- ...
%        ExactWavelength(nm),AOT_675-ExactWavelength(nm),AOT_667- ...
%        ExactWavelength(nm),AOT_555-ExactWavelength(nm),AOT_551- ...
%        ExactWavelength(nm),AOT_532-ExactWavelength(nm),AOT_531- ...
%        ExactWavelength(nm),AOT_500-ExactWavelength(nm),AOT_490- ...
%        ExactWavelength(nm),AOT_443-ExactWavelength(nm),AOT_440- ...
%        ExactWavelength(nm),AOT_412-ExactWavelength(nm),AOT_380- ...
%        ExactWavelength(nm),AOT_340-ExactWavelength(nm),Water(cm)- ...
%        ExactWavelength(nm)
%
% Modification History:
%   - Samuel LeBlanc (v1.0): - migrated to aeronet v3 direct sun files
%                            - added versioning (version_set)
function [aero] = aeronet_read_lev_v3(fname)
version_set('v1.0')
tic
fid=fopen(fname,'r');

[aero.path, aero.file, aero.ext]=fileparts(fname);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ HEADER 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

head{1}=fgetl(fid);
% level from line 1
C=textscan(head{1},'%s %*[^\n]','delimiter','<p>');
if contains(C{1}{1},'Version 3')
    v3 = true;
    aero.version=head{1};
    fseek(fid,0,'bof');
    for i=1:7
        head{i}=fgetl(fid);
        if any(strfind(head{i},'AOD_')) % stop when it is the column header
            colhead = head{i};
            break
        end
    end
    % level of AERONET
    C=split(head{3},': ');
    aero.level=C{2};
    % get PI info
    C = textscan(head{5},['Contact: PI=%s PI Email=%s'],'delimiter',';');
    aero.PI=C{1}{1};
    aero.email=C{2}{1};
    % get location
    aero.location=head{2};
      
    %% Wavelengths from column header
    C=textscan(colhead,'%s','delimiter',',');
    aero.ncols=size(C{1},1);
    aero.nwlen=0;
    aero.tipvar_i = 0;
    aero.angstrom_i = 0;
    aero.exact_i = 0;
    for i=1:size(C{1},1)
      tmp=textscan(C{1}{i},'AOD_%fnm');
      if (~isempty(tmp{1}))
          aero.nwlen=aero.nwlen+1;
          aero.wlen(aero.nwlen)=tmp{1};
          aero.anywlen(aero.nwlen)=0;
          aero.allwlen(aero.nwlen)=0;
      end
      if aero.tipvar_i<1
          tmp = textscan(C{1}{i},'Triplet_Variability_%s');
          if (~isempty(tmp{1})), aero.tipvar_i = i; end
      end
      if aero.angstrom_i<1
          tmp = textscan(C{1}{i},'%f-%f_Angstrom_Exponent');
          if (~isempty(tmp{1})), aero.angstrom_i = i; end
      end
      if aero.exact_i<1
          tmp = textscan(C{1}{i},'Exact_Wavelengths_of_AOD(um)_%fnm');
          if (~isempty(tmp{1})), aero.exact_i = i; end
      end
    end
    tmp_nwlen = find(diff(aero.wlen)<0);
    aero.nwlen_before_WV = tmp_nwlen(end)+1;
    
    % Latitude, Longitude Elevation
    ilat = find(not(cellfun('isempty',strfind(C{1},'Latitude'))));
    ilon = find(not(cellfun('isempty',strfind(C{1},'Longitude'))));
    iele = find(not(cellfun('isempty',strfind(C{1},'Elev'))));
    iname = find(not(cellfun('isempty',strfind(C{1},'Name'))));
    inum = find(not(cellfun('isempty',strfind(C{1},'Instru'))));
else 
    %% For v2
    v3 = false;
    fseek(fid,0,'bof');
    for i=1:5
        head{i}=fgetl(fid);
    end
    aero.level=C{1}{1};

    % version from line 2
    aero.version=head{2};
    
    % Location from line 3
    C=textscan(head{3},['Location=%s long=%f lat=%f elev=%f ' ...
                'Nmeas=%f PI=%s Email=%s'],'delimiter',',');
    aero.location=C{1}{1};
    aero.long=C{2};
    aero.lat=C{3};
    aero.elev=C{4};
    aero.Nmeas=C{5};
    aero.PI=C{6}{1};
    aero.email=C{7}{1};
    
    %% Wavelengths from line 5
    C=textscan(head{5},'%s','delimiter',',');
    aero.ncols=size(C{1},1);
    aero.nwlen=0;
    for i=1:size(C{1},1)
      tmp=textscan(C{1}{i},'AOT_%s');
      if (~isempty(tmp{1}))
        [num, ok]=str2num(tmp{1}{1});
        if ok
          aero.nwlen=aero.nwlen+1;
          aero.wlen(aero.nwlen)=num;
          aero.anywlen(aero.nwlen)=0;
          aero.allwlen(aero.nwlen)=0;
        end
      end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% READ DATA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(['aeronet_read_lev:: reading from file... ']);

% initialize with large size to speedy up memory allocation
cursize=2^15;
M(1:cursize, 1:aero.ncols)=NaN;

i=0;
while ~feof(fid);
  % read just one line, and remove characters
  arow=strrep(fgetl(fid),'N/A','NaN');
  arow=strrep(arow,'/','');
  arow=strrep(arow,':','');

  % read line as float
  clear tmp;
  if v3
    tmp=textscan(arow,'%s','delimiter',',');
  else
    tmp=textscan(arow,'%f','delimiter',',');
  end
  if (numel(tmp{1})~=aero.ncols)
    disp(['aeronet_read_lev:: WARN:: Number of columns in line #' ...
          num2str(i) ' is ' num2str(numel(tmp{1})) ...
          ' but header has ' num2str(aero.ncols) ' columns!!!']);
    disp(['aeronet_read_lev:: WARN:: Skipping this line:\n' arow])
  else
    i=i+1;
    if (mod(i,5000)==0)
      disp(['aeronet_read_lev:: lines read so far: ' num2str(i)]);
    end
    % if initial size not large enough, make it twice is large
    if (i>cursize)
      cursize=2*cursize;
      M(i:cursize,1:aero.ncols)=NaN;
    end
    if v3 
      mtmp = cellfun(@str2num,tmp{1},'un',0);
      mtmp(cellfun(@isempty, mtmp)) = {nan};
      M(i,:)=[mtmp{:}];
      try
          M(i,M(i,:)<-990.0) = nan;
      catch
         nul = nan; 
      end
    else
      M(i,:)=tmp{1};
    end
  end
end
aero.ntimes=i;
fclose(fid);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CONVERT TO MATLAB DATA TYPE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if v3
   aero.lat = str2num(tmp{1}{ilat}); %instrument latitude
   aero.long = str2num(tmp{1}{ilon}); %instrument longitude
   aero.elev = str2num(tmp{1}{iele}); %instrument elevation
   aero.location = tmp{1}{iname}; %instrument location name
end

% memory allocation
aero.jd(1:aero.ntimes,1)=NaN;
aero.aot(1:aero.ntimes,1:aero.nwlen)=NaN;
aero.water(1:aero.ntimes,1:2)=NaN;
aero.triplet(1:aero.ntimes,1:aero.nwlen)=NaN;
aero.angstrom(1:aero.ntimes,1:6)=NaN;
aero.zen(1:aero.ntimes,1)=NaN;

% process each column 
disp(['aeronet_read_lev:: converting to matlab structure... ']);
jini=1;
% Date and Time
% num2str() will convert with right alignment
% then we replace empty spaces with zeros
if v3
   jini = 2; 
end
dates=num2str(M(1:aero.ntimes,jini),'%08d'); dates(dates==' ')='0';
times=num2str(M(1:aero.ntimes,jini+1),'%06d'); times(times==' ')='0';
aero.jd(1:aero.ntimes,1)=datenum([dates times],'ddmmyyyyHHMMSS');
jini=jini+2;
% Day of year
jini=jini+1;
if v3, jini = jini+1; end %fractional day of year
% AOT, nwlen values
if v3
   aero.aot(1:aero.ntimes,1:aero.nwlen_before_WV+1)=M(1:aero.ntimes,jini:jini+aero.nwlen_before_WV);
   jini=jini+aero.nwlen_before_WV;
else
   aero.aot(1:aero.ntimes,:)=M(1:aero.ntimes,jini:jini+aero.nwlen-1);
   jini=jini+aero.nwlen;
end
% water(cm)
aero.water(1:aero.ntimes,1)=M(1:aero.ntimes,jini);
jini=jini+1;
if v3
    dnwlen = aero.nwlen - aero.nwlen_before_WV;
    aero.aot(1:aero.ntimes,aero.nwlen_before_WV+1:aero.nwlen)=M(1:aero.ntimes,jini:jini+dnwlen-1);
    jini = jini+dnwlen;
end
% triplets, nwlen values
if v3
  jini = aero.tipvar_i;
  aero.triplet(1:aero.ntimes,1:aero.nwlen_before_WV+1)=M(1:aero.ntimes,jini:jini+aero.nwlen_before_WV);
  jini=jini+aero.nwlen_before_WV;
else
  aero.triplet(1:aero.ntimes,:)=M(1:aero.ntimes,jini:jini+aero.nwlen-1);
  jini=jini+aero.nwlen;
end
% water error(cm)
aero.water(1:aero.ntimes,2)=M(1:aero.ntimes,jini);
jini=jini+1;

if v3 
    aero.triplet(1:aero.ntimes,aero.nwlen_before_WV+1:aero.nwlen)=M(1:aero.ntimes,jini:jini+dnwlen-1);
    jini = jini+dnwlen;
end
% angstrom, 6 values
if v3, jini=aero.angstrom_i; end
aero.angstrom(1:aero.ntimes,:)=M(1:aero.ntimes,jini:jini+6-1);
jini=jini+6;
% processing date
jini=jini+1;
% zenith angle
if v3, jini=77; end
aero.zen(1:aero.ntimes,1)=M(1:aero.ntimes,jini);
jini=jini+1;

% if user downloaded file with instrument information...
if (aero.ncols==63)
  % intrument
  if v3
      aero.cimel(1:aero.ntimes,1) = M(1:aero.ntimes,iname); % instrument number
  else
    aero.cimel(1:aero.ntimes,1)=M(1:aero.ntimes,jini);
    jini=jini+1;
  end
  % exact wavelength, nwlen values
  if v3
      jini = aero.exact_i;
      aero.wlenexact(1:aero.ntimes,1:aero.nwlen_before_WV+1)=M(1:aero.ntimes,jini:jini+aero.nwlen_before_WV);
      jini=jini+1;
      aero.wlenexact(1:aero.ntimes,aero.nwlen_before_WV+1:aero.nwlen)=M(1:aero.ntimes,jini:jini+dnwlen-1);
      jini = jini+dnwlen;
  else
      aero.wlenexact(1:aero.ntimes,:)=M(1:aero.ntimes,jini:jini+aero.nwlen-1);
      jini=jini+aero.nwlen;
      % water wave length 
      aero.water(1:aero.ntimes,3)=M(1:aero.ntimes,jini);  
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VERIFY WAVELENGTHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:aero.nwlen
  % in at least 1 measurment
  if any(~isnan(aero.aot(:,i)))
    aero.anywlen(i)=1;
  end
  % in all measurements
  if ~any(isnan(aero.aot(:,i)))
    aero.allwlen(i)=1;
  end
end
disp(['aeronet_read_lev:: done! ']);
toc
%