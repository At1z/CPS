clear all; 
close all; 
clc;

% Parametry
fs = 1000;          % Zmniejszona częstotliwość próbkowania
t = linspace(-5, 5, fs*10); % Zmiana zakresu czasu
f = 2;              % Nowa częstotliwość sygnału sinusoidalnego
amplitude = 1;      % Amplituda sygnału sinusoidalnego

% Generowanie nowego sygnału sinusoidalnego
sine_wave = amplitude * sin(2 * pi * f * t);

% Parametry szumu
noise_levels = [1];  % Różne poziomy szumu
num_levels = length(noise_levels);

% Parametry STFT i PSD
Mwind = 256;
Mstep = 16;
Mfft = 2 * Mwind;
Many = floor((fs - Mwind) / Mstep) + 1;
dt = 1 / fs;
fpr = fs;
w = hamming(Mwind)';  % Wybór okna

figure;

for i = 1:num_levels
    noise_level = noise_levels(i);
    
    % Generowanie szumu Gaussa
    noise = noise_level * randn(1, length(t));
    
    % Dodanie szumu do sygnału sinusoidalnego
    noisy_sine_wave = sine_wave + noise;
    
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
    subplot(2, 1, 1);
    plot(t, noisy_sine_wave, 'DisplayName', ['Szumiony sygnał sinusoidalny (noise\_level = ' num2str(noise_level) ')']);
    hold on;
    
    subplot(2, 1, 2);
    plot(f, X2, 'DisplayName', ['Widmo mocy (noise\_level = ' num2str(noise_level) ')']);
    hold on;
end

% Oryginalny sygnał sinusoidalny
subplot(2, 1, 1);
plot(t, sine_wave, 'k--', 'DisplayName', 'Oryginalny sygnał sinusoidalny', 'LineWidth', 1.5);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Sygnały sinusoidalne z różnym poziomem szumu Gaussa');
legend;
grid on;
hold off;

subplot(2, 1, 2);
xlabel('Częstotliwość [Hz]');
ylabel('Moc [V^2/Hz]');
title('Widma mocy sygnałów');
legend;
grid on;
hold off;

% Podział sygnału na 10 fragmentów
num_fragments = 10;
fragment_length = floor(length(t) / num_fragments);
fragment_psd = zeros(num_fragments, Mfft);

% Podział sygnału na 10 fragmentów
num_fragments = 10;
fragment_length = floor(length(t) / num_fragments);
fragment_sum = zeros(num_fragments, 1);

for i = 1:num_fragments
    fragment_start = (i - 1) * fragment_length + 1;
    fragment_end = i * fragment_length;
    fragment_signal = noisy_sine_wave(fragment_start:fragment_end);
    
    % Obliczenie PSD dla każdego fragmentu
    [pxx, f] = pwelch(fragment_signal, w, 0, Mfft, fs);
    fragment_sum(i) = sum(pxx); % Obliczenie sumy wartości PSD
    
    % Wyświetlenie sumy wartości PSD dla każdego fragmentu
    disp(['Suma wartości PSD dla fragmentu ' num2str(i) ': ' num2str(fragment_sum(i))]);
end

