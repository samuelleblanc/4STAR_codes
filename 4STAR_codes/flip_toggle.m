function toggle = flip_toggle(toggle,top_line)
% toggle = flip_toggle(toggle, top_line)
% Manually adjust toggle settings, with an optional title line for the menu

% CJF: v1.2, 2020-05-03, Modified to accept string arrays for "sky_tag"

version_set('1.2');
if ~isavar('top_line')
   top_line = [];
end
toggle_ = toggle;
togs = fieldnames(toggle);
% for t = length(togs):-1:1
%    if toggle.(togs{t})==0
%       toggle.(togs{t}) = false;
%    elseif toggle.(togs{t})==1
%       toggle.(togs{t}) = true;
%    end
%    if ~islogical(toggle.(togs{t}))
%       togs(t)= [];
%    end
% end

done = false;
while ~done
   for t = length(togs):-1:1
      tog = togs{t}; tog_val = toggle.(tog); if iscell(tog_val) tog_val=tog_val{:};end
      if length(toggle.(togs{t}))>2
         togs(t) = [];
         if isavar('tog_str') 
            tog_str(t) = [];
         end
      else
         if isa(tog_val,'function_handle')
            tog_str(t) = {[togs{t}, ': <@',char(tog_val),'>']};
         elseif ischar(tog_val)
             tog_str(t) = {[togs{t}, ': <',tog_val,'>']}; 
         elseif ~islogical(tog_val)
            TF = num2str(tog_val);
            tog_str(t) = {[tog, ': <',TF,'>']};
         else
            if toggle.(tog)
               TF = 'true';
            else
               TF = 'false';
            end
            tog_str(t) = {[tog, ': <',TF,'>']};
         end         
      end
   end
   ntogs = length(togs);
   tog_str(ntogs+1) = {''}; tog_str(ntogs+2) = {'DONE'};tog_str(ntogs+3) = {'ABORT'};
   mn = menu({top_line;'Select a toggle to change, "DONE" when finished, ';'"ABORT" to revert to original and quit'}, tog_str);
   if mn<=length(togs)
       tog_val = toggle.(togs{mn}); if iscell(tog_val) tog_val = tog_val{:}; end
      if islogical(tog_val)
         toggle.(togs{mn}) = ~(toggle.(togs{mn}));
      else
          if ischar(tog_val)
              tmp = {input([togs{mn},' <',tog_val,'> (No quotes, spaces, or specials): '],'s')};
          elseif isnumeric(tog_val) 
              tmp = input([togs{mn},'[',num2str(tog_val),']: ' ]);
          end
         if ~isempty(tmp)
            toggle.(togs{mn}) = tmp;
         end
      end
   elseif mn == ntogs+2
      done = true;
   elseif mn == ntogs+3
      toggle = toggle_;
      done = true;
   end
end
   
return
