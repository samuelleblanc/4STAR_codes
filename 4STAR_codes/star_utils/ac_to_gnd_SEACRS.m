function [az_gnd, el_gnd] = ac_to_gnd_SEACRS(az_deg, el_deg, heading_deg, pitch_deg, roll_deg)
% [az_gnd, el_gnd] = ac_to_gnd_SEACRS(az_deg, el_deg, heading_deg, pitch_deg, roll_deg)
% Apply Euler rotation to convert aircraft az and el to ground reference
% using 4STAR Az & El plus aircraft telemetry heading, pitch, roll.
% Offsets were determined iteratively using "test_angle_rotations_for_SEACRS
el_miss = -.3;
az_miss = -.7;
pitch_miss = 0.11;
head_miss = -0.15;
az_deg = az_deg +az_miss;
el_deg = el_deg + el_miss;
pitch_deg = pitch_deg + pitch_miss;
heading_deg =heading_deg + head_miss;

% Determined to be the best rotation based on "test_angle_rotations_for_SEACRS"
[az_gnd, el_gnd] = rot_AC_to_GND_123(az_deg, el_deg, roll_deg, pitch_deg, heading_deg,[2,3,1]);

return
