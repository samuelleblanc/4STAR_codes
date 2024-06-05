function cimel = rd_cimel_aip(end_date, start_date, site, data_type)
%This should read any of the Aeronet Inversion files.  Not fully tested...


if ~isavar('end_date')||isempty(end_date)
   end_date = ceil(now);
end
if ~isavar('start_date')||isempty(start_date)
   start_date = end_date-1;
end
if end_date==start_date
   start_date = end_date - 1;
end
if ~isavar('site')||isempty(site)
   site = 'ARM_SGP';
end
if ~isavar('data_type')||isempty(data_type)
   data_type = 'PPL00=1';
end

V = datevec(start_date); year = num2str(V(1));month=num2str(V(2));day=num2str(V(3));
V = datevec(end_date); year2 = num2str(V(1));month2=num2str(V(2));day2=num2str(V(3));
blop = [data_type,'&AVG=10&if_no_html=1'];
% site=Cart_Site&year=2000&month=6&day=1&year2=2000&month2=6&day2=14
httpUrl = 'https://aeronet.gsfc.nasa.gov/cgi-bin/print_web_data_raw_sky_v3?';
% data = 'site=ARM_SGP&year=2024&month=4&day=24&year2=2024&month2=4&day2=28&PPL00=1&AVG=10&if_no_html=1';
data2 = sprintf('site=%s&year=%s&month=%s&day=%s&year2=%s&month2=%s&day2=%s&%s',site, year, month, day, year2,month2,day2,blop);
blah =  webwrite(httpUrl,data2);
blah = strrep(blah,',<br>',''); blah = strrep(blah,'<br>','');
blah = strrep(blah,'</body></html>','');


tmp = []; done = false; header_rows = 0;
while ~done
   [tmp, blah] = getl(blah);
   if (~isempty(strfind(tmp,'Date('))&&~isempty(strfind(tmp,'Time(')))||isempty(blah)
      done = true;
   else
      header_rows = header_rows +1;
      if findstr(tmp,'long=')&findstr(tmp,'lat=')&findstr(tmp,'Email')
         tmp = strrep(tmp,'Locations=','Location=');
         loc_line = tmp;
      end
   end
end
if ~isempty(strfind(tmp,'Date('))&&~isempty(strfind(tmp,'Time('))
   label_line = tmp;
end
if isavar('label_line')
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
[first_line,blah] = getl(blah);

fmt_str = '%s %s %s'; % Two strings in a row for date, time
for L = 4:length(label)
   bloop = textscan(first_line,[fmt_str, ' %f *[^\n]'],'delimiter',',');
   if isempty(bloop{end}) || ~isempty(findstr(label{L},'Date')) ||  ~isempty(findstr(label{L},'Time'))||~isempty(findstr(label{L},'Sky_Scan'))||~isempty(findstr(label{L},'AERONET_Site'))
      fmt_str = [fmt_str, ' %s'];
   else
      fmt_str = [fmt_str, ' %f'];
   end
end


txt = textscan([first_line,blah],fmt_str,'delimiter',',','treatAsEmpty','N/A');
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
else
   cimel = [];
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