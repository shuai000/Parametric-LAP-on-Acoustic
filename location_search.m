
function [rx, phi_x, thea_x, min_error] = location_search(delay_vector, X, Y, Z)

min_error = inf;
error_array = [];
rx = 0; phi_x = 0; thea_x = 0;
for r=0.5:0.5:2
    for phi = -180:179
        for thea = -45:45
            [x_s, y_s, z_s] = sph2cart(deg2rad(phi),deg2rad(thea), r);
            source_cartisan = [x_s, y_s, z_s]';
            % compute distance
            M = [X; Y; Z];
            dis_ms = sqrt(sum((source_cartisan - M) .^ 2, 1));
            
            % compute delay
            v_speed = 343;
            dt = dis_ms ./ v_speed;
            
            delay_anticipate = [dt(1) - dt(2), dt(1) - dt(3), dt(1) - dt(4), dt(2) - dt(3), dt(2) - dt(4), dt(3) - dt(4)];
            
            error_delay = sqrt(sum((delay_vector - delay_anticipate) .^ 2));
            
            if error_delay < min_error
                rx = r; phi_x = phi; thea_x = thea;
                min_error = error_delay;
            end
            
            error_array = [error_array, error_delay];
            
        end
    end
end

figure;
plot(error_array);
end