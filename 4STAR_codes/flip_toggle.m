function toggle = flip_toggle(toggle,top_line)
% toggle = flip_toggle(toggle)
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
      tog = togs(t);
      if length(toggle.(togs{t}))>2
         togs(t) = [];
         if isavar('tog_str') 
            tog_str(t) = [];
         end
      else
         if ~islogical(toggle.(togs{t}))
            TF = num2str(toggle.(togs{t}));
         else
            if toggle.(togs{t})
               TF = 'true';
            else
               TF = 'false';
            end
         end
         tog_str(t) = {[togs{t}, ': <',TF,'>']};
      end
   end
   ntogs = length(togs);
   tog_str(ntogs+1) = {''}; tog_str(ntogs+2) = {'DONE'};tog_str(ntogs+3) = {'ABORT'};
   mn = menu({top_line;'Select a toggle to change, "DONE" when finished, ';'"ABORT" to revert to original and quit'}, tog_str);
   if mn<=length(togs)
      if islogical(toggle.(togs{mn}))
         toggle.(togs{mn}) = ~(toggle.(togs{mn}));
      else
         tmp = input([togs{mn},'[',num2str(toggle.(togs{mn})),'] ' ]);
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
