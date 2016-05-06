% This is a Matlab code for Gram-Schmidt
% orthogonalization
% ======================================
function [Q,R] = gram_schmidt(A)
[m,n] = size(A);
% m is number of wavelengths
% n is number of components (last is the gas)
% compute QR using Gram-Schmidt
for j = 1:n
   v = A(:,j);
   for i=1:j-1
        R(i,j) = Q(:,i)'*A(:,j);
        v = v - R(i,j)*Q(:,i);
   end
   R(j,j) = norm(v);
   Q(:,j) = v/R(j,j);
end
% =======================================
