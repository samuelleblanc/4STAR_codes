function [J, grad] = costFunctionH2O(theta, X, y)
% COSTFUNCTIONH2O Compute cost and gradient for linear regression
% J is the cost of using
% theta as the parameter for linear regression and the
% gradient of the cost w.r.t. to the parameters. 
% theta = [theta0 (intercept parameter);theta1 - slope parameter)]
% X is cross section array (normalized) with ones on first column
% y is total OD values (no Rayleigh) per time


% Initialize some useful values
m = length(y); % number of training examples (==number of wavelengths)
 
J = 0;                      % cost
grad = zeros(size(theta));  % gradient

% ====================== CODE HERE ==========================
% Compute the partial derivatives and set grad to the partial
% derivatives of the cost w.r.t. each parameter in theta

% cost function
%--------------%
for i = 1:m
    J = J + (theta'*X(i,:)'-y(i))^2;        % 
end

J = J/(2*m);

% gradient
%---------%
% theta0 (j=0)
grad = ((X*theta)-y')'*X;
grad = grad/m;
% theta  (j>=1)
% grad(2:end) = ((theta'*X')-y')*X(:,2:end) +lambda*theta(2:end)';
% grad(2:end) = grad(2:end)/m;
% =============================================================

end
