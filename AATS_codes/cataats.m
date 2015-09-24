function aats = cataats(aats,aat) ;
% Concatenate two AATS mat files along time

time = [aats.t; aat.t];
[time, ij] = unique(time);
len_t = length(aats.t);
fields = fieldnames(aats);

for fld = 1:length(fields)
   field = fields{fld};
   dim  = find(size(aats.(field))==len_t);
   if dim==2
     tmp = [aats.(field),aat.(field)];
     aats.(field) = tmp(:,ij);
   elseif dim==1
     tmp = [aats.(field);aat.(field)];
     aats.(field) = tmp(ij,:);      
   end
end

















return