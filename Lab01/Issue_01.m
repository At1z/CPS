clear all;
close all;
clc;

%A
%{
A = 230;
f = 50;
w = 2*pi*f;
tA = [10000,500,200]; % częstotliwość próbkowania
colorsA = ["b-","r-o","k-x"];

for i = 1:3
    figure(1)
    TA = linspace(0,0.1,tA(i));
    y = A*sin(w*TA);
    plot(TA,y,colorsA(i));
    hold on;
end

%B

tB = [10000, 51, 50, 49];
colorsB = ["b-","g-o","r-o","k-o"];
for i = 1:4
    figure(2)
    TB = linspace(0,1,tB(i));
    y = A*sin(w*TB);
    plot(TB,y,colorsB(i));
    hold on;
    axis([0 1.1 -235 235]);
end
%}
%C

A = 230;
f = 100;
TC = linspace(0,1,f)
fC = 0;
%{
while fC<=300
    figure(3);
    wC = 2*pi*fC;
    y = A*sin(wC*TC);
    plot(TC,y)
    fC = fC+5;
    pause;
end
%}

pickf = [5,105,205]
pickf_1 = [95,195,295]
pickf_2 = [0,95,105]
colorsC = ["b-","r-o","k-x"];
for i=1:3
    figure(3);
    wC = 2*pi*pickf(i);
    y = A*sin(wC*TC);
    plot(TC,y,colorsC(i));
    hold on;

    figure(4);
    wC = 2*pi*pickf_1(i);
    y = A*sin(wC*TC);
    plot(TC,y,colorsC(i));
    hold on;

    figure(5);
    wC = 2*pi*pickf_2(i);
    y = A*sin(wC*TC);
    plot(TC,y,colorsC(i));
    hold on;
end

while fC<=300
    figure(3);
    wC = 2*pi*fC;
    y = A*cos(wC*TC);
    plot(TC,y)
    fC = fC+5;
    pause;
end
%}

pickf = [5,105,205]
pickf_1 = [95,195,295]
pickf_2 = [0,95,105]
colorsC = ["b-","r-o","k-x"];
for i=1:3
    figure(3);
    wC = 2*pi*pickf(i);
    y = A*cos(wC*TC);
    plot(TC,y,colorsC(i));
    hold on;

    figure(4);
    wC = 2*pi*pickf_1(i);
    y = A*cos(wC*TC);
    plot(TC,y,colorsC(i));
    hold on;

    figure(5);
    wC = 2*pi*pickf_2(i);
    y = A*cos(wC*TC);
    plot(TC,y,colorsC(i));
    hold on;
end

%{

%D

% Parametry sygnału
fs = 10000;         % częstotliwość próbkowania [Hz]
fn = 50;            % częstotliwość nośna [Hz]
fm = 1;             % częstotliwość modulująca [Hz]
df = 5;             % głębokość modulacji [Hz]
t = linspace(0,1,fs);  % wektor czasu

% Sygnał modulujący
modulujacy = sin(2*pi*fm*t);

% Sygnał nośny
nosna = sin(2*pi*fn*t);

% Sygnał zmodulowany
zmodulowany = sin(2*pi*(fn + df*modulujacy).*t);

% Zadanie 1: 
figure(6);
plot(t, zmodulowany);
hold on;
plot(t, modulujacy);
title('Sygnał zmodulowany i modulujący');
xlabel('Czas [s]');
ylabel('Amplituda');
legend('Zmodulowany', 'Modulujący');
grid on;

% Zadanie 2
fs_spr = 25;  % częstotliwość próbkowania dla sygnału spróbkowanego [Hz]
t_spr = linspace(0,1,fs_spr);  % nowy wektor czasu
modulujacy_spr = sin(2*pi*fm*t_spr);
zmodulowany_spr = sin(2*pi*(fn + df*modulujacy_spr).*t_spr);

% Porównanie sygnału spróbkowanego z sygnałem analogowym
figure(7)
plot(t, zmodulowany);
hold on;
plot(t_spr, zmodulowany_spr);
title('Porównanie sygnału analogowego i spróbkowanego');
xlabel('Czas [s]');
ylabel('Amplituda');
legend('Analogowy', 'Spróbkowany');
grid on;

% Błędy spowodowane próbkowaniem
figure(8);
blad = abs(zmodulowany - interp1(t_spr, zmodulowany_spr, t));
plot(t, blad);
title('Błędy spowodowane próbkowaniem');
xlabel('Czas [s]');
ylabel('Błąd');
grid on;


% Zadanie 3: Widma gęstości mocy
% Widmo przed próbkowaniem
figure(9);
N = length(zmodulowany);
widmo_przed = abs(fft(zmodulowany)/N).^2;
f_przed = linspace(0, fs, N);
plot(f_przed, widmo_przed);
title('Widmo gęstości mocy przed próbkowaniem');
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość mocy');
grid on;

% Widmo po próbkowaniu
figure(10);
N_spr = length(zmodulowany_spr);
widmo_po = abs(fft(zmodulowany_spr)/N_spr).^2;
f_po = linspace(0, fs_spr, N_spr);
plot(f_po, widmo_po);
title('Widmo gęstości mocy po próbkowaniu');
xlabel('Częstotliwość [Hz]');
ylabel('Gęstość mocy');
grid on;

%}