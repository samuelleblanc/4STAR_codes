function K = fit_it(X,Y,eq)
% usual syntax: K = fit_it(X,Y,eq);
% X must be a row vector, size 1xN
% Y must be size MxN
% Equation eq must be given as a string matrix in terms of X 
% being a seperable arithmetic elements. 
% For example "X + X.^2 + ln(X) + 1./X + X.*exp(X)" would be 
% 	eq =
% 	X        
% 	X.^2     
% 	ln(X)    
% 	1./X     
% 	X.*exp(X)
% Also, don't forget the "dots" !

[order,str_len] = size(eq);
base_e = zeros([order,length(X)]);
for i = order:-1:1
  base_e(i,:) = eval(eq{i,:});
end 
% size(Y);
% size(base_e);
K = Y/base_e;
% Z = eval_eq(X,K,eq);
%for i = 1:order
%  Z = Z + K(i).*eval(eq(i,:));
%end;
return