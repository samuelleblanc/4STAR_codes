%% Simple function to parse out the input varargin and take out a structure
function [s,vout] = parse_struct(varargin)
s = struct();
vout = {};
for i=1:nargin
    argi = varargin{i};
    if isstruct(argi);
        s = argi;
    else
        if ~isempty(who('vout'))
            vout = {vout{:},argi};
        else
            vout = {argi};
        end
    end
end;
end