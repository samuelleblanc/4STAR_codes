function extract_tau_aero()

fp = '/nobackup/sleblan2/SEAC4RS/starsun_R2/';
days = ['0806';
        '0808';
        '0812';
        '0814';
        '0816';
        '0819';
        '0821';
        '0823';
        '0826';
        '0827';
        '0830';
        '0902';
        '0904';
        '0906';
        '0909';
        '0911';
        '0913';
        '0916';
        '0918';
        '0921';
        '0923'];

for i=1:length(days);
  r = load([fp '2013' days(i,:) 'starsun_R2.mat']);
  disp(days(i,:))
  tau_aero = r.tau_aero;
  w = r.w;
  t = r.t;
  Alt = r.Alt;
  Lon = r.Lon;
  Lat = r.Lat;
  save([fp '2013' days(i,:) 'starsun_R2_tauaero.mat'],'w','t','tau_aero','Alt','Lon','Lat');
end;
end 
