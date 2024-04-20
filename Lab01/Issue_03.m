clear all;
close all;
clc;

L = load('adsl_x.mat');
x = L.x;
f = abs(fft(x));
figure(1)
plot(f);
f_sort = sort(f, 'descend');
i1 = f_sort(1);
i2 = f_sort(2);
i3 = f_sort(3);
i4 = f_sort(4);
i = max(f);

figure(2)
plot(x(round(i1):round(i1)+32) - x(round(i2):round(i2)+32), 'r-');
hold on;
plot(x(round(i2):round(i2)+32) - x(round(i3):round(i3)+32), 'g-*');
hold on;
plot(x(round(i3):round(i3)+32) - x(round(i1):round(i1)+32), 'b-o');
hold on;

