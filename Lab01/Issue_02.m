clear all;
close all;
clc;

time = 2*pi;
base_frequency = 10;
base_period = 1/base_frequency;

base_time_vector = 0: 1/base_frequency: time;
base_signal = sin(base_time_vector);

rec_frequency = base_frequency * 50;
rec_period = 1/rec_frequency;

rec_time_vector = 0: 1/rec_frequency :time;
rec_signal = zeros(length(rec_time_vector), 1);

for time_interval = 1:length(rec_time_vector)
    sum = 0;
    for sample = 1:length(base_time_vector)
        variable_in_sinc = pi / base_period * ((time_interval-1)*rec_period - (sample-1)*base_period);
        sampling = 1;
        if variable_in_sinc ~= 0
            sampling = sin(variable_in_sinc) / variable_in_sinc;
        end
        sum = sum + base_signal(sample) * sampling;
    end
    rec_signal(time_interval) = sum;
end
hold on;
plot(base_time_vector, base_signal, 'r-o');
plot(rec_time_vector, rec_signal, 'g-x');

