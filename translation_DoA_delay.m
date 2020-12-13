%% Translate the correspondance between DoA and delay
% Author: Shuai SUN, 13/12/2020

clc; clear all; close all;

% define the four sensors in sephical coordinate (phi, thea, rho)
a1 = 0.:0.1:2*pi;
R = .038;
fi = 0:0.05:pi;
x1 = R*cos(a1(:))*sin(fi(:))';
y1 = R*sin(a1(:))*sin(fi(:))';
z1 = R*ones(size(a1(:)))*cos(fi(:))';

m1 = [45, 35, 0.042];
m2 = [-45, -35, 0.042];
m3 = [135, -35, 0.042];
m4 = [-135, 35, 0.042];

phi = [45, -45, 135, -135];
thea = [35, -35, -35, 35];
r = [0.042, .042, .042, .042];

[X, Y, Z] = sph2cart(deg2rad(phi),deg2rad(thea), r);

figure;
mesh(x1, y1, z1); hold on;
axis equal
for i = 1:4
    plot3(X(i), Y(i), Z(i), 'r.', 'MarkerSize', 40); hold on;
    xt = strcat('M', mat2str(i));
    text(X(i), Y(i), Z(i), xt);
end

%% define the source location (change it to see the difference)
r_s = 2;
phi_s = -60;
thea_s = 10;

azimuth_pertubation = -20:1:20;
elevation_pertubation = -20:1:20;
% store the results
error_azimuth_only = zeros(6, length(azimuth_pertubation));
error_elevation_only = zeros(6, length(elevation_pertubation));
error_both = zeros(length(azimuth_pertubation), length(elevation_pertubation), 6);

% fix elevation
delay_baseline = delay_compute(r_s, phi_s, thea_s);

for k=1:length(azimuth_pertubation)
    delay_current = delay_compute(r_s, phi_s+azimuth_pertubation(k), thea_s);
    error_azimuth_only(:, k) = delay_baseline-delay_current;
end
figure;
for m=1:6
    plot(azimuth_pertubation, error_azimuth_only(m, :), 'o-', 'MarkerSize', 3); hold on;
end
legend('M1-M2', 'M1-M3', 'M1-M4', 'M2-M3', 'M2-M4', 'M3-M4');
xlabel('Azimuth difference (degree)');
ylabel('Delay difference (sample)');
title('Only azimuth is altered');
% fix azimuth
for k=1:length(elevation_pertubation)
    delay_current = delay_compute(r_s, phi_s, thea_s+elevation_pertubation(k));
    error_elevation_only(:, k) = delay_baseline-delay_current;
end
figure;
for m=1:6
    plot(elevation_pertubation, error_elevation_only(m, :), 'o-', 'MarkerSize', 3); hold on;
end
legend('M1-M2', 'M1-M3', 'M1-M4', 'M2-M3', 'M2-M4', 'M3-M4');
xlabel('Elevation difference (degree)');
ylabel('Delay difference (sample)');
title('Only elevation is altered');
% pertube both
for k1=1:length(azimuth_pertubation)
    for k2=1:length(elevation_pertubation)
        delay_current = delay_compute(r_s, phi_s+azimuth_pertubation(k1), thea_s+elevation_pertubation(k2));
        error_both(k1, k2, :) = delay_baseline-delay_current;
    end
end
figure;
surf(azimuth_pertubation, elevation_pertubation, error_both(:, :, 1));
xlabel('Azimuth difference (degree)');
ylabel('Elevation difference (degree)');
zlabel('Delay difference (sample)');
title('M1-M2');

figure;
surf(azimuth_pertubation, elevation_pertubation, error_both(:, :, 2));
xlabel('Azimuth difference (degree)');
ylabel('Elevation difference (degree)');
zlabel('Delay difference (sample)');
title('M1-M3');

figure;
surf(azimuth_pertubation, elevation_pertubation, error_both(:, :, 3));
xlabel('Azimuth difference (degree)');
ylabel('Elevation difference (degree)');
zlabel('Delay difference (sample)');
title('M1-M4');


figure;
surf(azimuth_pertubation, elevation_pertubation, error_both(:, :, 4));
xlabel('Azimuth difference (degree)');
ylabel('Elevation difference (degree)');
zlabel('Delay difference (sample)');
title('M2-M3');


figure;
surf(azimuth_pertubation, elevation_pertubation, error_both(:, :, 5));
xlabel('Azimuth difference (degree)');
ylabel('Elevation difference (degree)');
zlabel('Delay difference (sample)');
title('M2-M4');

figure;
surf(azimuth_pertubation, elevation_pertubation, error_both(:, :, 6));
xlabel('Azimuth difference (degree)');
ylabel('Elevation difference (degree)');
zlabel('Delay difference (sample)');
title('M3-M4');

% Have a look at the max and min of the delay difference
max(reshape(error_both, 1, 41*41*6))
min(reshape(error_both, 1, 41*41*6))






