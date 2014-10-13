function [ng, flag_name, flag_tag] = cnvt_flags2ng(time, flags,good)
if ~exist('good','var')
    good = true(size(time));
end
flag_name = fieldnames(flags);
for fld = length(flag_name):-1:1
    if isstruct(flags.(flag_name{fld}))
        flags = rmfield(flags,flag_name{fld});
    end
end
flag_name = fieldnames(flags);
tag = 3;
ng = [];
for fld = 1:length(flag_name)
    switch flag_name{fld}
        case 'unknown'
            flag_tag(fld) = 1;
        case 'before_or_after_flight'
            flag_tag(fld) = 2;
        case 'unspecified_clouds'
            flag_tag(fld) = 10;
        case 'cirrus'
            flag_tag(fld) = 90;
        case 'inst_trouble'
            flag_tag(fld) = 100;
        case 'inst_tests'
            flag_tag(fld) = 200;
        case 'frost'
            flag_tag(fld) = 300;
        case 'low_cloud'
            flag_tag(fld) = 400;
        case 'hor_legs'
            flag_tag(fld) = 500;
        case 'vert_legs'
            flag_tag(fld) = 600;
        case 'bad_aod'
            flag_tag(fld) = 700;
        case 'smoke'
            flag_tag(fld) = 800;
        case 'dust'
            flag_tag(fld) = 900;
        case 'unspecified_aerosol'
            flag_tag(fld) = 1000;
        otherwise
            while any(flag_tag==tag)
                tag = tag+1;
            end
            flag_tag(fld) = tag;
    end
    tmp = flags.(flag_name{fld}).*(good);
    starts = find(diff([false,tmp])>0);
    ends = find(diff([tmp,false])<0);
    if length(starts)>0
        ng_ = [];
        ng_(1,:) = time(starts); ng_(2,:) = time(ends); ng_(3,:) = flag_tag(fld);
        ng = [ng,ng_];
    end
end

return