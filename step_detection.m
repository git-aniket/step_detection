%% Step detection using chest based accelerometer and gyroscope data
% This code detects steps using accelerometer and gyroscope data from a
% chest mounted sensor.
% The data is filtered using a Butterworth bandpass filter, and the
% derivative of the filtered data is calculated. The angle traced by the
% accelerometer is computed, and steps are detected based on the angle
% crossing a threshold of 100 degrees.
%% Author: Aniket Mazumder
% Vrije Universiteit Amsterdam
% contact: a.mazumder@vu.nl
%%
clear; clc; close all;
data = importdata('combined_data.mat');

%% design a butterworth bandpass filter with a cutoff frequency of 0.5-20 Hz
fs = 1000; % sampling frequency
low_cutoff = 0.1; % low cutoff frequency
high_cutoff = 4; % high cutoff frequency
order = 2; % filter order
[b, a] = butter(order, [low_cutoff high_cutoff] / (fs / 2), 'bandpass');

accel_data = data(:, 2:4); % assuming the first three columns are accelerometer
gyro_data = data(:, 5:7); % assuming the next three columns are gyroscope

% apply the filter to the accel-gyro data
filtered_accel_data = filtfilt(b, a, accel_data);
filtered_gyro_data = filtfilt(b, a, gyro_data);

%get the derivative of the filtered data
filtered_accel_data_diff = diff(filtered_accel_data);
filtered_gyro_data_diff = diff(filtered_gyro_data);


%% plot the filtered data and its derivative
% Define the variable
%n_samples = 325610;

% Accelerometer data
begin = 13660;
end_sample = 42516;

figure;
subplot(3,2,1);
plot(filtered_accel_data(begin:end_sample, 1), filtered_accel_data_diff(begin:end_sample, 1),'r');
xlabel('X-axis Accel');
ylabel('X-axis Accel Derivative');
grid on;

subplot(3,2,2);
plot(filtered_accel_data(begin:end_sample, 2), filtered_accel_data_diff(begin:end_sample, 2),'g');
xlabel('Y-axis Accel');
ylabel('Y-axis Accel Derivative');
grid on;

subplot(3,2,3);
plot(filtered_accel_data(begin:end_sample, 3), filtered_accel_data_diff(begin:end_sample, 3),'b');
xlabel('Z-axis Accel');
ylabel('Z-axis Accel Derivative');
grid on;

subplot(3,2,4);
plot(filtered_accel_data(begin:end_sample, 1), filtered_accel_data_diff(begin:end_sample, 2),'r');
xlabel('X-axis Accel');
ylabel('Y-axis Accel Derivative');
grid on;

subplot(3,2,5);
plot(filtered_accel_data(begin:end_sample, 2), filtered_accel_data_diff(begin:end_sample, 3),'g');
xlabel('Y-axis Accel');
ylabel('Z-axis Accel Derivative');
grid on;

subplot(3,2,6);
plot(filtered_accel_data(begin:end_sample, 3), filtered_accel_data_diff(begin:end_sample, 2),'b');
xlabel('Z-axis Accel');
ylabel('Y-axis Accel Derivative');
grid on;

% Gyroscope data
figure;
subplot(3,2,1);
plot(filtered_gyro_data(begin:end_sample, 1), filtered_gyro_data_diff(begin:end_sample, 1),'r');
xlabel('X-axis Gyro');
ylabel('X-axis Gyro Derivative');
grid on;

subplot(3,2,2);
plot(filtered_gyro_data(begin:end_sample, 2), filtered_gyro_data_diff(begin:end_sample, 2),'g');
xlabel('Y-axis Gyro');
ylabel('Y-axis Gyro Derivative');
grid on;

subplot(3,2,3);
plot(filtered_gyro_data(begin:end_sample, 3), filtered_gyro_data_diff(begin:end_sample, 3),'b');
xlabel('Z-axis Gyro');
ylabel('Z-axis Gyro Derivative');
grid on;

subplot(3,2,4);
plot(filtered_gyro_data(begin:end_sample, 1), filtered_gyro_data_diff(begin:end_sample, 2),'r');
xlabel('X-axis Gyro');
ylabel('Y-axis Gyro Derivative');
grid on;

subplot(3,2,5);
plot(filtered_gyro_data(begin:end_sample, 2), filtered_gyro_data_diff(begin:end_sample, 3),'g');
xlabel('Y-axis Gyro');
ylabel('Z-axis Gyro Derivative');
grid on;

subplot(3,2,6);
plot(filtered_gyro_data(begin:end_sample, 3), filtered_gyro_data_diff(begin:end_sample, 1),'b');
xlabel('Z-axis Gyro');
ylabel('X-axis Gyro Derivative');
grid on;

%% Get the angle traced by the accelerometer
angle_accel = atan2d(filtered_accel_data(1:end-1, 1) + filtered_accel_data(1:end-1, 3) , filtered_accel_data_diff(:, 1) + filtered_accel_data_diff(:, 3));

%% Now consider the points where the angle just crossed 100 degrees from below to be a step

% find the points where the angle crosses 100 degrees
threshold = 100;
crossings = find(diff(angle_accel > threshold) == 1);
% find the time interval between the crossings
crossing_intervals = diff(crossings);


%% plot the crossings along with the angle in a subplot
figure;

% Subplot for X-axis Accelerometer data
subplot(2, 1, 1);
plot(filtered_accel_data(:, 3), 'b');
xlabel('Sample Number');
ylabel('X-axis Accel');
title('Accelerometer X-axis Data');
grid on;

% Subplot for Angle and Step Crossings
subplot(2, 1, 2);
plot(angle_accel, 'r');
hold on;
plot(crossings, angle_accel(crossings), 'bo');
xlabel('Sample Number');
ylabel('Angle (degrees)');
title('Step Detection using Angle Crossings');
legend('Angle', 'Step Crossings');
hold off;
grid on;

