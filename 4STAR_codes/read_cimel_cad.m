function cimel = read_cimel_cad(filename);
%This should read any of the Aeronet files.  Not fully tested...
% 2023-08-10: cjf, modified to handle last_processed_date and last_processed_time
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
% Site,Date(dd:mm:yyyy),Time(hh:mm:ss),Day_of_Year,Day_of_Year(Fraction),AOD_Coincident_Input[440nm],AOD_Coincident_Input[675nm],AOD_Coincident_Input[870nm],AOD_Coincident_Input[1020nm],Angstrom_Exponent_440-870nm_from_Coincident_Input_AOD,Average_Solar_Zenith_Angles_for_Flux_Calculation(Degrees),Solar_Zenith_Angle_for_Measurement_Start(Degrees),Sky_Residual(%),Sun_Residual(%),Coincident_AOD440nm,Scattering_Angle_Bin_3.2_to_<6_degrees[440nm],Scattering_Angle_Bin_6_to_<30_degrees[440nm],Scattering_Angle_Bin_30_to_<80_degrees[440nm],Scattering_Angle_Bin_80_degrees_and_over[440nm],Scattering_Angle_Bin_3.2_to_<6_degrees[675nm],Scattering_Angle_Bin_6_to_<30_degrees[675nm],Scattering_Angle_Bin_30_to_<80_degrees[675nm],Scattering_Angle_Bin_80_degrees_and_over[675nm],Scattering_Angle_Bin_3.2_to_<6_degrees[870nm],Scattering_Angle_Bin_6_to_<30_degrees[870nm],Scattering_Angle_Bin_30_to_<80_degrees[870nm],Scattering_Angle_Bin_80_degrees_and_over[870nm],Scattering_Angle_Bin_3.2_to_<6_degrees[1020nm],Scattering_Angle_Bin_6_to_<30_degrees[1020nm],Scattering_Angle_Bin_30_to_<80_degrees[1020nm],Scattering_Angle_Bin_80_degrees_and_over[1020nm],Surface_Albedo[440m],Surface_Albedo[675m],Surface_Albedo[870m],Surface_Albedo[1020m],If_Retrieval_is_L2(without_L2_0.4_AOD_440_threshold),If_AOD_is_L2,Last_Processing_Date(dd:mm:yyyy),Last_Processing_Time(hh:mm:ss),Instrument_Number,Latitude(Degrees),Longitude(Degrees),Elevation(m),Inversion_Data_Quality_Level,Retrieval_Measurement_Scan_Type
% ARM_SGP,05:06:2023,12:37:29,156,156.526030,0.441513,0.220891,0.140405,0.106408,1.679567,74.419067,74.992659,4.714095,0.163579,0.441513,4,10,7,6,4,9,7,5,4,8,6,4,3,4,5,2,0.069980,0.140240,0.398960,0.414510,0,0,08:06:2023,21:25:02,1034,36.605175,-97.485619,319.000000,lev15,Almucantar

% Site,Date(dd:mm:yyyy),Time(hh:mm:ss),Day_of_Year,Day_of_Year(Fraction),Single_Scattering_Albedo[440nm],Single_Scattering_Albedo[675nm],Single_Scattering_Albedo[870nm],Single_Scattering_Albedo[1020nm],Average_Solar_Zenith_Angles_for_Flux_Calculation(Degrees),Solar_Zenith_Angle_for_Measurement_Start(Degrees),Sky_Residual(%),Sun_Residual(%),Coincident_AOD440nm,Scattering_Angle_Bin_3.2_to_<6_degrees[440nm],Scattering_Angle_Bin_6_to_<30_degrees[440nm],Scattering_Angle_Bin_30_to_<80_degrees[440nm],Scattering_Angle_Bin_80_degrees_and_over[440nm],Scattering_Angle_Bin_3.2_to_<6_degrees[675nm],Scattering_Angle_Bin_6_to_<30_degrees[675nm],Scattering_Angle_Bin_30_to_<80_degrees[675nm],Scattering_Angle_Bin_80_degrees_and_over[675nm],Scattering_Angle_Bin_3.2_to_<6_degrees[870nm],Scattering_Angle_Bin_6_to_<30_degrees[870nm],Scattering_Angle_Bin_30_to_<80_degrees[870nm],Scattering_Angle_Bin_80_degrees_and_over[870nm],Scattering_Angle_Bin_3.2_to_<6_degrees[1020nm],Scattering_Angle_Bin_6_to_<30_degrees[1020nm],Scattering_Angle_Bin_30_to_<80_degrees[1020nm],Scattering_Angle_Bin_80_degrees_and_over[1020nm],Surface_Albedo[440m],Surface_Albedo[675m],Surface_Albedo[870m],Surface_Albedo[1020m],If_Retrieval_is_L2(without_L2_0.4_AOD_440_threshold),If_AOD_is_L2,Last_Processing_Date(dd:mm:yyyy),Last_Processing_Time(hh:mm:ss),Instrument_Number,Latitude(Degrees),Longitude(Degrees),Elevation(m),Inversion_Data_Quality_Level,Retrieval_Measurement_Scan_Type
% ARM_SGP,05:06:2023,12:37:29,156,156.526030,0.974200,0.967400,0.961500,0.957500,74.419067,74.992659,4.714095,0.163579,0.441513,4,10,7,6,4,9,7,5,4,8,6,4,3,4,5,2,0.069980,0.140240,0.398960,0.414510,0,

   reseek = ftell(fid); first_line = fgetl(fid);
   fseek(fid,reseek,-1);
   fmt_str = '%s %s %s'; % Two strings in a row for date, time
   for L = 4:length(label)
      bloop = textscan(first_line,[fmt_str, ' %f *[^\n]'],'delimiter',',');
      if isempty(bloop{end})||~isempty(findstr(label{L},':'))
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
newname = strrep(newname,':','_')
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