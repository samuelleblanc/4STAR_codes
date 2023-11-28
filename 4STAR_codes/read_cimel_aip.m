function cimel = read_cimel_aip(filename);
%This should read any of the Aeronet files.  Not fully tested...
if ~exist('filename', 'var')
   filename = getfullname('*.*','cimel');
elseif ~exist(filename,'file')
   filename = getfullname(filename,'cimel');
end
[pname, fname,ext] = fileparts(filename);
fname = [fname,ext];
% Version 2 files contained a line starting with Location= with aeronet
% site name, lat, lon, alt.
% Version 3 files lack this line but still have a label line that needs to
% be parsed.
fid = fopen(filename);

if fid>0
   cimel.fname = fname;
   cimel.pname = pname;
   done = false; header_rows = 0;
   while ~done
      tmp = fgetl(fid);
      if (~isempty(strfind(tmp,'Date('))&&~isempty(strfind(tmp,'Time(')))||feof(fid)
         done = true;
      else
         header_rows = header_rows +1;
         if findstr(tmp,'long=')&findstr(tmp,'lat=')&findstr(tmp,'Email')
            tmp = strrep(tmp,'Locations=','Location=');
            loc_line = tmp;
         end
         
      end
   end
   if ~feof(fid)
      if ~isempty(strfind(tmp,'Date('))&&~isempty(strfind(tmp,'Time('))
         label_line = tmp;
      end
   end
   cimel.label_line = label_line;
   labels = textscan(label_line,'%s','delimiter',',');
   labels_ = labels{:};
   for lab = length(labels_):-1:1
      tmp = labels_{lab};
      tmp_ = sscanf(tmp,'%f');
      if ~isempty(tmp_)
         tmp = sprintf('%g',tmp_);
      end
      tmp = strrep(tmp,'angs','Angs');
      tmp = legalizename(tmp);
      label(lab) = {tmp};
   end
   %    AERONET_Site,Date(dd:mm:yyyy),Time(hh:mm:ss),Instrument_Number,Nominal_Wavelength(nm),Exact_Wavelength(um),Solar_Zenith_Angle(Degrees),Sky_Scan_Type,-6.000000,-5.000000,-4.000000,-3.500000,-3.000000,-2.500000,-2.000000,0.000000,2.000000,2.500000,3.000000,3.500000,4.000000,5.000000,6.000000,6.000000,8.000000,10.000000,12.000000,14.000000,16.000000,20.000000,25.000000,30.000000,35.000000,40.000000,45.000000,50.000000,55.000000,60.000000,65.000000,70.000000,80.000000,90.000000,100.000000,110.000000,120.000000,130.000000,140.000000,150.000000,
   %    ARM_Graciosa,03:01:2019,11:11:49,620,1020,1.019500,72.852854,Principal Plane,22.964095,26.117485,30.513681,33.500126,36.746262,40.419034,44.778131,-999.000000,35.503456,30.495131,26.191682,22.444714,19.272775,14.394296,10.981215,10.975812,6.958128,4.688068,3.421272,2.579824,2.048140,1.405496,0.938538,0.651891,0.476204,0.346751,0.272777,0.212674,0.180310,0.143324,0.120207,0.097090,0.087843,0.078597,0.078597,0.087843,0.115584,0.152570,0.254284,0.522438
   reseek = ftell(fid); first_line = fgetl(fid);
   fseek(fid,reseek,-1);
   fmt_str = '%s %s %s'; % Two strings in a row for date, time
   for L = 4:length(label)
      bloop = textscan(first_line,[fmt_str, ' %f *[^\n]'],'delimiter',',');
      if isempty(bloop{end}) || ~isempty(findstr(label{L},'Date')) ||  ~isempty(findstr(label{L},'Time'))
         fmt_str = [fmt_str, ' %s'];
      else
         fmt_str = [fmt_str, ' %f'];
      end
   end
   
   if header_rows > 0
      txt = textscan(fid,fmt_str,'delimiter',',','treatAsEmpty','N/A');
      if length(txt)~=length(label);
         disp('Mismatch between number of labels and number of columns')
         return
      else
         cimel.anet_site = unique(txt{1}); 
         txt(1) = [];label(1) = [];
         this = txt{1};
         txt(1) = [];label(1) = [];
         that = txt{1};
         txt(1) = [];label(1) = [];
         for d = length(this):-1:1
            dates{d} = [this{d},' ',that{d}];
         end
%          try
%              cimel.time = datenum(dates);
%          catch
             try
                 cimel.time = datenum(dates,'dd:mm:yyyy HH:MM:SS');
             catch
                 cimel.time = datenum(dates,'dd-mm-yyyy HH:MM:SS');
             end
%          end
         
         while length(label)>0
            if isnumeric(txt{1})&&~all(isNaN(txt{1}))
               cimel.(label{1}) = txt{1};
            elseif ~isempty(findstr(lower(label{1}),'date'))
               cimel.(label{1}) = datenum(txt{1},'dd:mm:yyyy');
               %             elseif isempty(findstr(lower(label{1}),'data_type'))
               %                cimel.(label{1}) = txt{1};
               %             else
            elseif ~isempty(strfind(label{1},'Sky_Scan_Type'))
               cimel.(label{1}) = unique(txt{1});
            end
            txt(1) = [];
            label(1) = [];
         end
      end
   end
   fclose(fid);
end
return;

function newname = legalizename(oldname)
% Replaces illegal characters in names of structure elements.
newname = oldname;
if ((newname(1)>47)&(newname(1)<58))
   newname = ['pos',newname];
end
if newname(1) == '-'
   newname = ['neg',newname ];
end
newname = strrep(newname,'%','pct_');
newname = strrep(newname,'(','_');
newname = strrep(newname,')','_');
newname = strrep(newname,'[','_');
newname = strrep(newname,']','_');
newname = strrep(newname,'{','_');
newname = strrep(newname,'}','_');
newname = strrep(newname,' ','_');
newname = strrep(newname,'-','_');
newname = strrep(newname,':','_');
newname = strrep(newname,'/','_');
newname = strrep(newname,'+','_');
newname = strrep(newname,'>=','_gte_');
newname = strrep(newname,'<=','_lte_');
newname = strrep(newname,'>','_gt_');
newname = strrep(newname,'<','_lt_');
newname = strrep(newname,'=','_eq_');
newname = strrep(newname,'.','d');
if newname(1) == '_'
   newname = ['underbar',newname ];
end

return