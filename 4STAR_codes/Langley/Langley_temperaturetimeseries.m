%%Langley_temperaturetimeseries.m
%a really clunky but functional way to plot airmass vs temperature for
%diagnostic purposes.  The beginning part also plots temperature vs time.
%replace the various s files with whichever day instead.  Created at MLO,
%Nov 2016.

clear all; s=load('4STAR_20161115star.mat')
s2=load('4STAR_20161113star.mat')
figure; plot(serial2hs(s.track.t),smooth(s.track.T3,600),'.k')
hold on; plot(serial2hs(s2.track.t),smooth(s2.track.T3,600),'.b')
s4=load('4STAR_20161110star.mat')
s4b=load('4STAR_20161110starsun_small.mat')
figure; plot(s4b.m_aero,smooth(s4.track.T3,600),'.c')
[ainb, bina] = nearest(s4b.t, s4.track.t);
figure; plot(s4b.m_aero(ainb),smooth(s4.track.T3(bina),600),'.c')
s2b=load('4STAR_20161113starsun_small.mat')
[ainb, bina] = nearest(s2b.t, s2.track.t);
hold on; plot(s2b.m_aero(ainb),smooth(s2.track.T3(bina),600),'.b')
sb=load('4STAR_20161115starsun_small.mat')
[ainb, bina] = nearest(sb.t, s.track.t);
hold on; plot(sb.m_aero(ainb),smooth(s.track.T3(bina),600),'.m')
s3=load('4STAR_20161112star.mat')
s3b=load('4STAR_20161112starsun_small.mat')
[ainb, bina] = nearest(s3b.t, s3.track.t);
hold on; plot(s3b.m_aero(ainb),smooth(s3.track.T3(bina),600),'.g')
legend('20161110','20161113','20161115','20161112')