% Script for estimating the delay between microphone sound
% The delay is estimated assuming a parametric structure.
% 20/11/2020 Shuai SUN

clc; clear all; close all;

% Class is: 0 alarm, 1 crying baby, 2 crash, 3 barking dog, 4 running engine,
% 5 burning fire, 6 footsteps, 7 knocking on door,
% 8 & 9 female & male speech, 10 &11 female & male scream, 12 ringing phone, 13 piano

%% Extract data: Uncomment each class if you want to test it
% frame index is the row index in the csv file, manually selected 

% Alarm 0  (most close case)
path_audio = 'audio_data\mix017.wav';
path_csv = 'audio_data\mix017.csv';
frame_index = 1:30;

% % Crying 1
% path_audio = 'audio_data\mix022.wav';
% path_csv = 'audio_data\mix022.csv';
% frame_index = 1:10;

% % Crash 2
% path_audio = 'audio_data\mix014.wav';
% path_csv = 'audio_data\mix014.csv';
% frame_index = 1:10;

% % Barking dog 3
% path_audio = 'audio_data\mix158.wav';
% path_csv = 'audio_data\mix158.csv';
% frame_index = 271:281;

% % Running Engin 4
% path_audio = 'audio_data\mix002.wav';
% path_csv = 'audio_data\mix002.csv';
% frame_index = 1:20;
% OR this one below:
% path_audio = 'audio_data\mix012.wav';
% path_csv = 'audio_data\mix012.csv';
% frame_index = 1:10;

% % Burning fire 5
% path_audio = 'audio_data\mix109.wav';
% path_csv = 'audio_data\mix109.csv';
% frame_index = 405:415;

% % FootStep 6
% path_audio = 'audio_data\mix005.wav';
% path_csv = 'audio_data\mix005.csv';
% frame_index = 1:20;

% % Knocking on the door 7
% path_audio = 'audio_data\mix007.wav';
% path_csv = 'audio_data\mix007.csv';
% frame_index = 1:10;

% % Female Speech 9
% path_audio = 'audio_data\mix113.wav';
% path_csv = 'audio_data\mix113.csv';
% frame_index = 154:164;

% % Male Speech 
% path_audio = 'audio_data\mix153.wav';
% path_csv = 'audio_data\mix153.csv';
% frame_index = 369:386;

% % Female scream 10 
% path_audio = 'audio_data\mix025.wav';
% path_csv = 'audio_data\mix025.csv';
% frame_index = 1:7;

% % Scream 11
% path_audio = 'audio_data\mix006.wav';
% path_csv = 'audio_data\mix006.csv';
% frame_index = 1:15;

% % Ring 12
% path_audio = 'audio_data\mix032.wav';
% path_csv = 'audio_data\mix032.csv';
% frame_index = 1:10;

% % Piano class = 13
% path_audio = 'audio_data\mix001.wav';
% path_csv = 'audio_data\mix001.csv';
% frame_index = 1:10;

[y, x_azimuth, x_elevation] = audio_data_extraction(path_audio, path_csv, frame_index, 1);

sound(y(:,1:2), 24000); % use this if want to hear the sound

figure; % plot the first 200 samples to have a check
for i=1:4
    plot(y(1:200, i), '-o', 'Markersize', 3); hold on;
end
legend('M1', 'M2', 'M3', 'M4');
title('The first 200 samples for all the four channels');

%% Microphone array configurations
phi = [45, -45, 135, -135];
thea = [35, -35, -35, 35];
r = [0.042, .042, .042, .042];
[X, Y, Z] = sph2cart(deg2rad(phi),deg2rad(thea), r);

r_s = 2; % this is not provided in the metadata (but they are it is either 1m or 2m, note that it makes neglegible difference for time delay)
phi_s = x_azimuth(1);
thea_s = x_elevation(1);

[x_s, y_s, z_s] = sph2cart(deg2rad(phi_s),deg2rad(thea_s), r_s);
source_cartisan = [x_s, y_s, z_s]';

% compute distance
M = [X; Y; Z];
dis_ms = sqrt(sum((source_cartisan - M) .^ 2, 1));
% compute delay
v_speed = 343;
dt = dis_ms ./ v_speed;
delay_vector = [dt(1) - dt(2), dt(1) - dt(3), dt(1) - dt(4), dt(2) - dt(3), dt(2) - dt(4), dt(3) - dt(4)];
delayBySample = delay_vector .* 24000; % ground truth delay by samples
%% Parameters for delay estimation:
scale = 4;
window = 1000;
orders = 1;

%% --Estimation starts: Load transmitted and received signal:
index_all = [1 2; 1 3; 1 4; 2 3; 2 4; 3 4];

for i=1:size(index_all, 1)
    tx_index = index_all(i, 1);
    rx_index = index_all(i, 2);
    signal_tx = y(:, tx_index)';
    signal_rx = y(:, rx_index)';
    
    [delayEst,Order,~] = MultiScale_LAP_Param(signal_tx, signal_rx, scale,window,orders);
    signalEst = imshift(signal_tx,1i.*delayEst);
    MSE = mean(abs((signal_rx - signalEst)).^2)/mean(signal_rx.^2);
    
    fprintf('\t\t Delay of M%1i-M%2i : Ground truth delay (sample) = %1.1f \t Estimated delay (sample)  = %1.1f\n', tx_index, rx_index, delayBySample(i), mean(delayEst));

end







