function make_small(f_in)


% Simple program to load a starsun and save just a few values from it to a
% smaller file


s = load(f_in,'w','Alt','Lat','Lon','tau_aero','m_aero','t');

f_out = strrep(f_in,'.mat', '_small.mat');

save(f_out,'-struct','s','-mat','-v7.3');
end