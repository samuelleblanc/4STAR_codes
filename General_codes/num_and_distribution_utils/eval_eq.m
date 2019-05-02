function [Z] = eval_eq(X,K,eq)
% usual syntax: [Z] = eval_eq(X,K,eq);
% X must be a row-vector 1xN , K is NxO where O is the order of eq
% The equation eq must be given as a string matrix with each row
% being a seperable arithmetic elements. 
% For example "X + X.^2 + ln(X) + 1./X + X.*exp(X)" would be 
% 	eq =
% 	X        
% 	X.^2     
% 	ln(X)    
% 	1./X     
% 	X.*exp(X)
% Also, don't forget the "dots" !
[order] = length(eq);
Z = zeros(size(K,1), size(X,2));
for i = order:-1:1
   if iscell(eq)
      if strcmp(eq{i},'1')
         ee = ones(size(X));
      else
         ee = eval(eq{i});
      end
   else
      if strcmp(eq(i),'1')
         ee = ones(size(X));
      else
         ee = eval(eq(i));
      end      
   end
         Z = Z + K(:,i)*ee;
end
return
