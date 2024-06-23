clear all; close all; clc;

% Parametry
fs = 1000;          % Częstotliwość próbkowania
t = linspace(0, 1, fs); % Oś czasu
f = 5;              % Częstotliwość sygnału sinusoidalnego
amplitude = 1;      % Amplituda sygnału sinusoidalnego
noise_level = 0.1;  % Poziom szumu (odchylenie standardowe)

% Generowanie sygnału sinusoidalnego
sine_wave = amplitude * sin(2 * pi * f * t);

% Generowanie szumu Gaussa
noise = noise_level * randn(1, fs);

% Dodanie szumu do sygnału sinusoidalnego
noisy_sine_wave = sine_wave + noise;

% Parametry STFT i PSD
Mwind = 256;
Mstep = 16;
Mfft = 2 * Mwind;
Many = floor((fs - Mwind) / Mstep) + 1;
dt = 1 / fs;
fpr = fs;
w = hamming(Mwind)';  % Wybór okna

% Inicjalizacja STFT i PSD
X1 = zeros(Mfft, Many);
X2 = zeros(1, Mfft);

% Pętla analizy
for m = 1 : Many
    bx = noisy_sine_wave(1 + (m - 1) * Mstep : Mwind + (m - 1) * Mstep);
    bx = bx .* w;
    X = fft(bx, Mfft) / sum(w);
    X1(1:Mfft, m) = X;  % STFT
    X2 = X2 + abs(X) .^ 2;  % Welch PSD
end

X1 = 20 * log10(abs(X1));  % Przeliczenie na decybele
X2 = (1 / Many) * X2 / fpr;  % Normalizacja PSD
f = fpr / Mfft * (0 : Mfft - 1);  % Częstotliwość

% Rysowanie wykresów
figure;
subplot(2, 1, 1);
plot(t, noisy_sine_wave, 'DisplayName', 'Szumiony sygnał sinusoidalny');
hold on;
plot(t, sine_wave, 'DisplayName', 'Oryginalny sygnał sinusoidalny', 'LineWidth', 1.5);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnał sinusoidalny z szumem Gaussa');
legend;
grid on;
hold off;

subplot(2, 1, 2);
plot(f, X2, 'DisplayName', 'Widmo mocy');
xlabel('Częstotliwość [Hz]');
ylabel('Moc [V^2/Hz]');
title('Widmo mocy sygnału');
legend;
grid on;
