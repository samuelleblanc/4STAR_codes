% I ran starsun or starwrapper and stopped mid-way to grab this
% What I want to test is whether adding a tau (from another source) as
% input to a Nakayama-style Langley helps or biases the result.  To
% determine, I'll use a tau derived from the same Langley but introduce a
% calibration error in tau corresponding to a span of errors in Io and see
% what Io values are retrieved. 

[s.solzen, s.solaz, s.soldst, ~, ~, s.solel, s.am] = sunae(s.Lat, s.Lon, s.t);
s.w(450) % 534.3 nm
suns = s.Str==1;
[tau_ray]=rayleighez(s.w(450),unique(679),mean(s.t),unique(s.Lat))


figure; semilogy(s.am(suns), s.rate(suns,450),'.'); % standard Langley plot
xl = xlim;
xl_ = s.am>xl(1)&s.am<xl(2);
P = polyfit(s.am(suns&xl_), log(s.rate(suns&xl_,450)),1); % standard Langley
Io = exp(P(2)); % Io from standard Langley
tau = log((Io./s.rate(:,450)))./s.am; % Computed total OD
figure; plot(s.t(suns&xl_),tau(suns&xl_)-tau_ray,'ro'); %AOD = TOD - tau_ray;

P_new = polyfit(tau(suns&xl_).*s.am(suns&xl_), log(s.rate(suns&xl_,450)),1); % Nakayama Langley
% No difference, unless screen is applied, or other tau (sky retrieval)
 [Vo,tau_uw,P] = lang_uw(s.am(suns&xl_), s.rate(suns&xl_,450));
tau_uw = log((Vo./s.rate(:,450)))./s.am; % Computed total OD

figure; plot(1./s.am(suns&xl_), log( s.rate(suns&xl_,450))./s.am(suns&xl_),'.')

figure; plot(s.t(suns&xl_), tau(suns&xl_)-tau_ray, '.', s.t(suns&xl_), tau_uw(suns&xl_)-tau_ray, 'r.');
legend('standard AOD','unweighted AOD');
dynamicDateTicks

 [Vo_N,tau_N,P_N] = lang_uw(tau_uw(suns&xl_).*s.am(suns&xl_), s.rate(suns&xl_,450));
 
figure; plot(s.t(suns&xl_), s.Tbox(suns&xl_), '.', s.t(suns&xl_), s.Tprecon(suns&xl_), '.', s.t(suns&xl_), s.Tst(suns&xl_), '.'); legend('Tbox','Tprecon','Tst'); dynamicDateTicks
dynamicDateTicks

 
 