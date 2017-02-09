function aip = get_all_anet_aip_during(t)
% Concatenates all Aeronet AIP files found in a directory that are between
% the min and max times specified in t
if ~exist('t','var')||isempty(t)
   t = [datenum(2013,6,1), datenum(2013,11,1)];
end
in_time = [min(t), max(t)];
n = 0;
aip_files = {getfullname('*.dubovik','aip','Select aip files')}
aip = []
for f = 1:length(aip_files)
   disp(['File number ',num2str(f)])
   disp(aip_files{f})
   tmp = read_cimel_aip(aip_files{f});
   time_ = tmp.time>in_time(1)&tmp.time<in_time(2);
   if sum(time_)>0
%       disp(aip_files{f})
      disp(['f = ',num2str(f),' lat=', num2str(tmp.lat),' lon=',num2str(tmp.lon)])
      clear tmp2;
      n = n+1;
      tmp2.time = tmp.time(time_);
      tmp2.lat = tmp.lat.*ones(size(tmp2.time));
      tmp2.lon = tmp.lon.*ones(size(tmp2.time));
      fields = fieldnames(tmp);
      for fld = 1:length(fields)
         field = fields{fld};
         if (~isempty(strfind(field,'AOTExt'))&&strfind(field,'AOTExt')==1)
            if ~isempty(findstr(field,'Ext4'))
               field_ = ['AOTExt440',field(end-1:end)];
            elseif ~isempty(findstr(field,'Ext6'))
               field_ = ['AOTExt673',field(end-1:end)];
            elseif ~isempty(findstr(field,'Ext8'))
               field_ = ['AOTExt873',field(end-1:end)];
            elseif ~isempty(findstr(field,'Ext10'))
               field_ = ['AOTExt1020',field(end-1:end)];
            else
               field_ = field;
            end
            tmp2.(field_) = tmp.(field)(time_);
         end
         if (~isempty(strfind(field,'SSA'))&&strfind(field,'SSA')==1)
            if ~isempty(findstr(field,'SSA4'))
               field_ = ['SSA440',field(end-1:end)];
            elseif ~isempty(findstr(field,'SSA6'))
               field_ = ['SSA673',field(end-1:end)];
            elseif ~isempty(findstr(field,'SSA8'))
               field_ = ['SSA873',field(end-1:end)];
            elseif ~isempty(findstr(field,'SSA10'))
               field_ = ['SSA1020',field(end-1:end)];
            else
               field_ = field;
            end
            tmp2.(field_) = tmp.(field)(time_);
         end
      end
      if isempty(aip)
         aip = tmp2;
      else
%          try
           if isfield(aip,'SSA440_T') && isfield(tmp2,'SSA440_T')
              outfields = fieldnames(aip);
              for of = 1:length(outfields)
                 aip.(outfields{of}) = [aip.(outfields{of}); tmp2.(outfields{of})];
              end
             
           end
%          catch
%             disp(['Problem concatenating ',aip_files{f}])
%          end
      end
%       disp([n, length(unique(aip.lat)), length(unique(aip.lon))])
   end
end
pname = [fileparts(aip_files{1}), filesep];
save([pname, filesep,'..',filesep,'aeronet_collocated_lv2_daily.mat'],'-struct','aip')
return
   
