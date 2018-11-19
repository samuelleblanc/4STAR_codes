function make_small(s,matname)

% Simple program to load a starsun and save just a few values from it to a
% smaller file

if exist('s','var') && ~isstruct(s)
   matname = s;
   s = load(s,'w','Alt','Lat','Lon','tau_aero','m_aero','t');
elseif exist('s','var') && isstruct(s)
   fld_in= fieldnames(s);
   fld_out = {'w','Alt','Lat','Lon','tau_aero','m_aero','t'};
   for f = length(fld_in):-1:1
      if ~any(strcmp(fld_in{f},fld_out))
         s = rmfield(s,fld_in{f});
      end
   end
end
if ~exist('matname','var')
   matname = uiputfile('*.mat','Save mat file...');
end
matname = strrep(matname,'_small.mat', '.mat');
f_out = strrep(matname,'.mat', '_small.mat');
save([getnamedpath('starsun'),f_out],'-struct','s','-mat','-v7.3');
end