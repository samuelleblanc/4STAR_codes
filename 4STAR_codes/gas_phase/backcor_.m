function [z,a,it,ord,s,fct] = backcor_(n,y,ord,s,fct)

% BACKCOR   Background estimation by minimizing a non-quadratic cost function.
%
%   [EST,COEFS,IT] = BACKCOR(N,Y,ORDER,THRESHOLD,FUNCTION) computes and estimation EST
%   of the background (aka. baseline) in a spectroscopic signal Y with wavelength N.
%   The background is estimated by a polynomial with order ORDER using a cost-function
%   FUNCTION with parameter THRESHOLD. FUNCTION can have the four following values:
%       'sh'  - symmetric Huber function :  f(x) = { x^2  if abs(x) &lt; THRESHOLD,
%                                                  { 2*THRESHOLD*abs(x)-THRESHOLD^2  otherwise.
%       'ah'  - asymmetric Huber function :  f(x) = { x^2  if x &lt; THRESHOLD,
%                                                   { 2*THRESHOLD*x-THRESHOLD^2  otherwise.
%       'stq' - symmetric truncated quadratic :  f(x) = { x^2  if abs(x) &lt; THRESHOLD,
%                                                       { THRESHOLD^2  otherwise.
%       'atq' - asymmetric truncated quadratic :  f(x) = { x^2  if x &lt; THRESHOLD,
%                                                        { THRESHOLD^2  otherwise.
%   COEFS returns the ORDER+1 vector of the estimated polynomial coefficients.
%   IT returns the number of iterations.
%
%   [EST,COEFS,IT] = BACKCOR(N,Y) does the same, but run a graphical user interface
%   to help setting ORDER, THRESHOLD and FCT.
%
% For more informations, see:
% - V. Mazet, C. Carteret, D. Brie, J. Idier, B. Humbert. Chemom. Intell. Lab. Syst. 76 (2), 2005.
% - V. Mazet, D. Brie, J. Idier. Proceedings of EUSIPCO, pp. 305-308, 2004.
% - V. Mazet. PhD Thesis, University Henri Poincaré Nancy 1, 2005.
% 
% 22-June-2004, Revised 19-June-2006, Revised 30-April-2010
% Comments and questions to: vincent.mazet@unistra.fr.


% Check arguments
if nargin < 2, error('backcor:NotEnoughInputArguments','Not enough input arguments'); end;
if nargin < 5, [z,a,it,ord,s,fct] = backcorgui(n,y); return; end; % delete this line if you do not need GUI
if ~isequal(fct,'sh') && ~isequal(fct,'ah') && ~isequal(fct,'stq') && ~isequal(fct,'atq'),
    error('backcor:UnknownFunction','Unknown function.');
end;

% Rescaling
N = size(n,2);
% [n,i] = sort(n);
% y = y(i);
maxy = max(y,[],2); miny = min(y,[],2);
dely = (maxy-miny)./2;
n = 2 * (n-n(:,N)*ones([1,N])) ./ ((n(:,N)-n(:,1))*ones([1,N])) + 1;
y = (y-maxy*ones([1,N]))./(dely*ones([1,N]))+ 1;

% Vandermonde matrix(
p = 0:ord;

% The challenge to vectorizing this would be to find a representation for
% T, Tinv, and so on that would retain dimensionality for time, wln, and p.
% and then to loop over a decreasing population of time indices that have
% yet to converge, until they all have. This might be possible by defining
% N-dimensional arrays where time operations are all element-wise and
% others are matrix operations.  

for ii = size(n,1):-1:1
T = repmat(n(ii,:)',1,ord+1) .^ repmat(p,N,1);
Tinv = pinv(T'*T) * T';

% Initialisation (least-squares estimation)
aii = Tinv*(y(ii,:)');
zii = T*aii;

% Other variables
alpha = 0.99 * 1/2;     % Scale parameter alpha
it = 0;                 % Iteration number
it = 0;                 % Iteration number
zp = ones(N,1);          % Previous estimation

% LEGEND
% Oh heck, not sure how to handle this while statement since each of the
% sums and residuals for different times will be independent.  
% Maybe have to loop, but what does this do to our Tinv

while sum((zii-zp).^2)./sum(zp.^2) > 1e-9,
    
    it = it + 1;        % Iteration number
    zp = zii;      % Previous estimation
    res = y(ii,:)' - zii;        % Residual
    
    % Estimate d
    if isequal(fct,'sh'),
        d = (res*(2*alpha-1)) .* (abs(res)<s) + (-alpha*2*s-res) .* (res<=-s) + (alpha*2*s-res) .* (res>=s);
    elseif isequal(fct,'ah'),
        d = (res*(2*alpha-1)) .* (res<s) + (alpha*2*s-res) .* (res>=s);
    elseif isequal(fct,'stq'),
        d = (res*(2*alpha-1)) .* (abs(res)<s) - res .* (abs(res)>=s);
    elseif isequal(fct,'atq'),
        d = (res*(2*alpha-1)) .* (res<s) - res .* (res>=s);
    end;
    
    % Estimate z
    aii = Tinv * (y(ii,:)'+d);   % Polynomial coefficients a
    zii = T*aii;            % Polynomial
    
end;
z(:,ii) = zii;
a(:,ii) = aii;
end
% we want a to have size [2,t] to yield z with size [t,wln]
% Rescaling
z = (z-1).*(dely*ones([1,N]))' + (maxy*ones([1,N]))';
% [poly3_,poly3_c_,iter,order_lin,thresh,fn]= backcor_(ones(pp,1)*w(wln),tau_ODmodc0slant(:,wln),order_in2,thresh_in2,'atq');
%[z,a,it,ord,s,fct] = backcor_(n,y,ord,s,fct)
end

