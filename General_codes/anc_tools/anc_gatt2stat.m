function [anc] = anc_gatt2stat(anc, gatt_name, long_name);
% anc = anc_gatt2stat(anc, gatt, long_name);
% Attempts to convert a global attribute to static field
% Parses data element of attribute with textscan(str,'%f %s')
% Attributes initial numeric value as data, trailing string as units.
if ~isavar('long_name') 
   long_name = gatt_name;
end

CC = textscan(anc.gatts.(gatt_name),'%f %s');

    if ~isempty(CC{2})
       units = CC{2};
    else
        units = '1';
    end

if ~isempty(CC{1})
    anc.vdata.(gatt_name) = CC{1};

    anc.vatts.(gatt_name).long_name = long_name;
    anc.vatts.(gatt_name).units = units;

    anc.ncdef.vars.(gatt_name).datatype = 5;
    anc.ncdef.vars.(gatt_name).dims = {''};

    anc.ncdef.vars.(gatt_name).atts.long_name.datatype = 2;
    anc.ncdef.vars.(gatt_name).atts.units.datatype = 2;

anc = anc_check(anc);
end
    
end
    
    