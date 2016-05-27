function [z,a,it,ord,s,fct] = backcor(n,y,ord,s,fct)

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
N = length(n);
[n,i] = sort(n);
if size(y,1)==1
    y = y(i);
else
    y = y(i,:);
end
maxy = max(y);
dely = (maxy-min(y))/2;
n = 2 * (n-n(N)) / (n(N)-n(1)) + 1;
y = (y-maxy)/dely + 1;

% Vandermonde matrix
p = 0:ord;
T = repmat(n,1,ord+1) .^ repmat(p,N,1);
Tinv = pinv(T'*T) * T';

% Initialisation (least-squares estimation)
a = Tinv*y;
z = T*a;

% Other variables
alpha = 0.99 * 1/2;     % Scale parameter alpha
it = 0;                 % Iteration number
zp = ones(N,1);         % Previous estimation

% LEGEND
while sum((z-zp).^2)/sum(zp.^2) > 1e-9,
    
    it = it + 1;        % Iteration number
    zp = z;             % Previous estimation
    res = y - z;        % Residual
    
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
    a = Tinv * (y+d);   % Polynomial coefficients a
    z = T*a;            % Polynomial
    
end;

% Rescaling
z = (z-1)*dely + maxy;

end

