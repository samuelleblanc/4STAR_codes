function [aero, eps] = eps2_screen(time, tau, window, eps_thresh, aot_base)
%function [aero, eps] = eps2_screen(time, tau, window, eps_thresh, aot_base)
% Required: time and time-series of optical depth values
% Optional: aot_base, tau_min, tau_max, eps_thresh
% time is in units of day, so Matlab serial dates work as do jd.
% If specified, window in minutes

% Attempts iterative outlier rejection along with eps_screen to attempt to tighten up
% the borders under broken skies, rejecting the clouds while preserving the aerosol
% adjacent to the clouds. 



if ~exist('aot_base','var')
    aot_base = .2;
end
if ~exist('window','var')
    window = 5;
end
if ~exist('eps_thresh','var')
    eps_thresh = 1e-5;
end
%Compute tau prime, a renormalized tau
tau_bar = zeros(size(tau));
tau_prime = tau_bar;
eps = ones(size(tau)); min_eps = eps;
aero = (eps<eps_thresh);
%moved pos_tau specification way upstream.
pos_tau = find(tau);
if length(pos_tau)>0
    for t = fliplr(pos_tau)
%         bar = find(abs(time(t)-time(pos_tau))<=(window/(24*60))); %look for data within 5 minute span
        bar = (abs(time(t)-time(pos_tau))<=(window/(24*60)));
        if sum(bar)>5 % used to be if length(bar)
            tau_bar(t) = mean(tau(pos_tau(bar)));
            tau_prime(t) = tau(t)- tau_bar(t)+aot_base;
        end
    end
    % disp('Done with first for')
    %Now compute tau_prime_bar, the average of tau_prime
    tau_prime_bar = ones(size(tau));
    bar_log_tau_prime = tau_prime_bar;

    pos_tau_prime = find(tau_prime>0);
    for tt = length(pos_tau_prime):-1:1
        t = pos_tau_prime(tt);
%         bar = find(abs(time(t)-time(pos_tau_prime))<=(window/(24*60)));
        bar = (abs(time(t)-time(pos_tau_prime))<=(window/(24*60)));

%         if length(bar)>5
        if sum(bar)>5

           tau_prime_bar(t) = mean(tau_prime(pos_tau_prime(bar)));
            % Tests alternate definitions of "mean", arithmetic, geometric, harmonic...
            %       abar(t)= tau_prime_bar(t);
            %       gbar(t) = exp(sum(log(tau_prime(pos_tau_prime(bar))))/length(bar));
            %       hbar(t) = length(bar)/sum(1./tau_prime(pos_tau_prime(bar)));
            bar_log_tau_prime(t) = mean(log(tau_prime(pos_tau_prime(bar))));
            %       elogbar(t) = exp(bar_log_tau_prime(t));
            %       logebar(t) = log(mean(exp(tau_prime(pos_tau_prime(bar)))));
            eps(t) = 1 - exp(bar_log_tau_prime(t))./tau_prime_bar(t);
        end
    end

    for tt = length(pos_tau_prime):-1:1
        t = pos_tau_prime(tt);
%         bar = find(abs(time(t)-time(pos_tau_prime))<=(window/(24*60)));
        bar = (abs(time(t)-time(pos_tau_prime))<=(window/(24*60)));
        min_eps(tt) = min(eps(bar));
        aero(tt) = min_eps(tt)<eps_thresh;
%         bar_ii = find(bar);
%         aero(t) = (eps(bar_ii(1))<eps_thresh)|(eps(bar_ii(end))<eps_thresh)
    end
end

aero = aero&(tau>0);
figure_(12);ss(1) = subplot(2,1,1); plot(1:length(time), tau,'x', find(aero), tau(aero),'o');
ss(2) = subplot(2,1,2); plot(1:length(time), eps, 'x',find(aero), eps(aero),'o', 1:length(time), min_eps,'.'); logy; 
linkaxes(ss,'x');
return