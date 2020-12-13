function delay_vector = delay_compute(r, azimuth, elevation)
% compute the time delay between all the possible 6 configurations among 
% the four sensors
[x_s, y_s, z_s] = sph2cart(deg2rad(azimuth),deg2rad(elevation), r);
source_cartisan = [x_s, y_s, z_s]';

phi = [45, -45, 135, -135];
thea = [35, -35, -35, 35];
r_s = [0.042, .042, .042, .042];
[X, Y, Z] = sph2cart(deg2rad(phi),deg2rad(thea), r_s);

% compute distance
M = [X; Y; Z];
dis_ms = sqrt(sum((source_cartisan - M) .^ 2, 1));

% compute delay
v_speed = 343;
dt = dis_ms ./ v_speed;

Fs = 24000;
delay_vector = [dt(1) - dt(2), dt(1) - dt(3), dt(1) - dt(4), dt(2) - dt(3), dt(2) - dt(4), dt(3) - dt(4)] .* Fs;

end