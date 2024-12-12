function toggle = merge_toggle(toggle, toggle_new)
% toggle = merge_toggle(toggle, toggle_new)
% Updates an existing set of star toggles with new values, passing existing
% fields thru, replaced with new field values if provided in toggle_new.
% CJF: v1.0, 2020-05-06, Replacing calls of catstruct with this for
% updating toggles to retain original field order.

version_set('1.0');
if nargin==0
    toggle = update_toggle;
elseif nargin==1
    if isavar('toggle_new')
        toggle = toggle_new;
    end
elseif nargin==2        
    either = union(fieldnames(toggle),fieldnames(toggle_new));
    for f = 1:length(either)
        fld = either{f};
        if isfield(toggle_new,fld)
            toggle.(fld) = toggle_new.(fld);
        end
    end
end
return