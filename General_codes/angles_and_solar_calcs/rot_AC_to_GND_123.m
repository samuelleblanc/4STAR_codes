function [az_gnd, el_gnd] = rot_AC_to_GND_123(az_ac, el_ac, roll, pitch, heading,order)
% [az_gnd, el_gnd] = rot_AC_to_GND_123(az_ac, el_ac, roll, pitch, heading,order)
% Convert Az and El in aircraft frame to Az and El in ground frame.
% Rotations of [heading, pitch, roll] computed in order specified by the 3-element vector "order".
% order = [1 2 3] => heading is applied first, then pitch, then roll.
% order = [3 1 2] => pitch is applied first, roll, then heading.
% convert az_deg (CW relative to N, aka y-hat) into (CCW relative to x-hat, aka right wing)
if ~exist('order','var')
    order = [3,2,1];
end
O = ['D','C','B'];
theta_ac = (90-az_ac); % Azimuthal orientation of head relative to x-axis (right wing)
phi_ac = (el_ac); % Elevation orientation of head relative to aircraft x-y plane

phi = -heading; %Heading is reported in left-hand sense, convert to RH coords
theta = pitch;
psi = roll;
%% Maybe working now...
% Convert theta_ac and phi_ac from spherical to cartesian
[x,y,z] = sph2cart(theta_ac*pi./180, phi_ac*pi./180,ones(size(theta_ac)));
X = [x,y,z]';
if all([1,2,3]==unique(order))||all([1;2;3]==unique(order))
    for i = length(az_ac):-1:1
        R.D = [cosd(phi(i)), -sind(phi(i)), 0; sind(phi(i)), cosd(phi(i)), 0; 0,0,1];% heading about z
        R.C = [cosd(psi(i)), 0, sind(psi(i)); 0,1,0; -sind(psi(i)), 0, cosd(psi(i))]; % roll about y
        R.B = [1, 0, 0; 0, cosd(theta(i)), -sind(theta(i)); 0, sind(theta(i)), cosd(theta(i))]; %pitch about x
        R.A = R.(O(order(3)))*R.(O(order(2)))*R.(O(order(1))) ; 
        X_(:,i) = R.A*X(:,i); % Apply rotation matrix
    end
    % Rotate back to spherical
    [theta_gnd, phi_gnd, r]=cart2sph(X_(1,:),X_(2,:),X_(3,:));
    theta_gnd = 180.* theta_gnd./pi;
    az_gnd = 90-theta_gnd'; % Azimuth measured CW from north
    el_gnd =  180.*  phi_gnd' ./pi;
else
    disp('Bad order supplied: ',order)
end
return