function [pfn, cimel] = rd_anetpfn_v3(filename);
% cimel = rd_anetpfn_v3(filename);
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
    tmp = fgetl(fid);
    if feof(fid)||~startsWith(tmp, 'AERONET Version 3')
        clear cimel; cimel = struct([]);
    else
        cimel.site = fgetl(fid);
        while ~feof(fid)&&~(startsWith(tmp,'Site,')||startsWith(tmp,'AERONET_Site')||startsWith(tmp,'Date'))
            tmp = fgetl(fid);
        end
        cimel.label_line = tmp;
        labels = textscan(cimel.label_line,'%s','delimiter',',');
        labels_ = unique(labels{:},'rows','stable');
        for lab = length(labels_):-1:1
            tmp = labels_{lab};
            tmp_ = sscanf(tmp,'%f');
            if ~isempty(tmp_)
               [~, last] = textscan(tmp,'%f'); nxt = last+1;
                tmp = sprintf(['%g',tmp(nxt:end)],tmp_);
            end
            tmp = strrep(tmp,'angs','Angs');
            tmp = legalizename(tmp);
            label(lab) = {tmp};
        end
        reseek = ftell(fid); first_line = fgetl(fid);  fseek(fid,reseek,-1);
        fmt(length(labels{1})) = {'%f '};fmt(:) = fmt(end); fmt(1:3) = {'%s '};
        A = textscan(first_line,'%s','delimiter',',');A = A{:};
        for val =4:length(A)
            if isempty(sscanf(A{val},fmt{val}))||~isempty(strfind(A{val},':'))
                fmt{val} = '%s '; 
%                 disp(label{val});
            end
        end
        fmt_str = [fmt{:}];
        txt = textscan(fid,fmt_str ,'delimiter',',','treatAsEmpty','N/A');
        Site = string(txt{1});
        Date = string(txt{2}); Time = string(txt{3}); bip(length(txt{2}),1) = string(' '); bip(:) = bip(end);
        DT = [Date+bip+Time];
        cimel.time = datenum(DT,'dd:mm:yyyy HH:MM:SS');
        for lab = 4:length(label)
            cimel.(label{lab}) = txt{lab};
        end
        if isfield(cimel,'Last_Processing_Date_dd_mm_yyyy_')
            cimel.Last_Processing_Date_dd_mm_yyyy_ = string(cimel.Last_Processing_Date_dd_mm_yyyy_);
            cimel.Last_Processing_Date_dd_mm_yyyy_ = [cimel.Last_Processing_Date_dd_mm_yyyy_ + " "];
            cimel.Last_Processing_Time_hh_mm_ss_ =  string(cimel.Last_Processing_Time_hh_mm_ss_);
            DT = [cimel.Last_Processing_Date_dd_mm_yyyy_ + cimel.Last_Processing_Time_hh_mm_ss_];
            cimel.Last_Processing_DateTime = datenum(DT,'dd:mm:yyyy HH:MM:SS');
            cimel = rmfield(cimel,{'Last_Processing_Date_dd_mm_yyyy_'; 'Last_Processing_Time_hh_mm_ss_'});
        end
    end    
fclose(fid);
pfn = cimel;
flds = fieldnames(cimel);
sfc = flds(foundstr(flds,'Surface_Albedo_'));
for s = length(sfc):-1:1
   pfn.wl(s) = sscanf(sfc{s},'Surface_Albedo_%f');
   fld_ij = find(foundstr(flds,'pos')&foundstr(flds,sprintf('_%dnm_',pfn.wl(s))));
   pfn = rmfield(pfn,flds(fld_ij));
   pf_deg = flds(fld_ij);
   pf_deg = strrep(strrep(pf_deg,'pos',''),'d','.');
   P_str = sprintf('P_%dnm',pfn.wl(s));
   for f = length(fld_ij):-1:1
      pfn.SA(f) = sscanf(pf_deg{f},'%f');
      pfn.(P_str)(:,f) = txt{fld_ij(f)};
   end
end
pfn = rmfield(pfn, flds(foundstr(flds,'_Bin_')));

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
newname = strrep(newname,'/','_');
newname = strrep(newname,'+','_');
newname = strrep(newname,':','_');
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