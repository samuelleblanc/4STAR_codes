function nc = anc_subsample(nc,N)
% nc = anc_subsample(nc,N);
% N is an integer indicating the number of regular records per day
% to output 1-hr = 24, 1-min = 1440, 1-sec = 86400
% Closest original temporal values to N grid are returned, no interpolation 


if ~isavar('N')
   N = 1440; % Default to minutely
end
Ntime = linspace(floor(nc.time(1)), ceil(nc.time(2)), N+1); 
Ntime(end) = [];
[ainn, nina] = nearest(nc.time, Ntime,(Ntime(2)-Ntime(2)./2.001));
nc = anc_sift(nc, ainn);

return
