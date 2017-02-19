function [az_gnd, el_gnd] = ac_to_gnd_oracles(Az_deg, El_deg, Heading_deg, Pitch_deg, roll_deg)
% [az_gnd, el_gnd] = ac_to_gnd_oracles(az_deg, el_deg, heading_deg, pitch_deg, roll_deg)
% Apply Euler rotation to convert aircraft az and el to ground reference
% using 4STAR Az & El plus aircraft telemetry heading, pitch, roll.
% Offsets were determined iteratively using test_angle_rotations_for_oracles


% for 213
pitch_miss = .75;
% pitch_miss = .25;
el_miss = -1.15 - pitch_miss;%  positive lowers SEL - rotated
head_miss = 0;
az_miss = -0.15 - head_miss; %  positive lowers SAZ - rotated
az_deg = Az_deg +az_miss;
el_deg = El_deg + el_miss;
pitch_deg = Pitch_deg + pitch_miss;
heading_deg =Heading_deg+head_miss;

%deviation in ephemeris SEL- rotated looks like pitch trace when EL is low
%deviation in ephemeris SAZ- rotated looks like pitch trace when EL is high

% Determined to be the best rotation based on "test_angle_rotations_for_SEACRS"
% This is a different order than was used in SEACRS
[az_gnd, el_gnd] = rot_AC_to_GND_123(az_deg, el_deg, roll_deg, pitch_deg, heading_deg,[2,1,3]);

return
