function gxs = get_GlobalCrossSections(t,instrumentname)

if nargin<1
    disp('**** Caution using global cross sections that have no time or instrument specifications ****')
    loadCrossSections_global
    if ~isafile([fileparts(which('get_GlobalCrossSections')),filesep,'gxs.mat'])
       save([fileparts(which('get_GlobalCrossSections')),filesep,'gxs.mat']);
    end
    gxs = load(which('gxs.mat'));
elseif t>datenum([2016 1 09 0 0 0]) %for timing after KORUS-AQ
    switch instrumentname
        case {'4STAR'}
            disp(['...using the newer cross sections from file : ' which('4STAR_20220830_gxs.mat')])
            gxs = load(which('4STAR_20220830_gxs.mat'));
        case {'4STARB'}
            gxs = load(which('4STARB_20220830_gxs.mat'));
    end
    fn_gxs = fieldnames(gxs);
    for n=1:length(fn_gxs)
        so = size(gxs.(fn_gxs{n}));
       if so(1) ==1
          gxs.(fn_gxs{n}) = reshape(gxs.(fn_gxs{n}),[],1); 
       end
    end
    
end
return
