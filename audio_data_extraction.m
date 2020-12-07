function [audio_data, azimuth, elevation] = audio_data_extraction(filepath, metapath, time_interval, to_plot)

Fs = 24000; % 24KHz
frameresolution = 0.1; % 100msec
audio_data = audioread(filepath);

audio_meta = csvread(metapath);

frame = audio_meta(time_interval, 1);

audio_data_interval = frame(1) * Fs * frameresolution:frame(end) * Fs * frameresolution;

audio_data = audio_data(audio_data_interval, :);
azimuth = audio_meta(time_interval, 4);
elevation = audio_meta(time_interval, 5);
class_active = audio_meta(time_interval, 2);
track_index = audio_meta(time_interval, 3);

real_time = frame * frameresolution;
if to_plot == 1
    figure;
    subplot 221, plot(real_time, frame, 'k'); title('Frame'); xlabel('time (seconds)');
    subplot 222, plot(real_time, class_active, 'm'); title('Class'); xlabel('time (seconds)'); ylim([0, 15]);
    subplot 223, plot(real_time, track_index, 'r'); title('Active track'); xlabel('time (seconds)');
    subplot 224, plot(real_time, azimuth); hold on; plot(real_time, elevation); legend('Azimuth', 'Elevation'); 
    xlabel('time (seconds)'); ylim([-185, 185]); title('DoA');
end

end