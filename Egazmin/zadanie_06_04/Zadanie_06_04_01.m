clear all; close all; clc;

% Parametry
fs = 1000;                   % Częstotliwość próbkowania
total_time = 10;             % Całkowity czas sygnału w sekundach
t = linspace(0, total_time, fs * total_time); % Oś czasu
f = 5;                       % Częstotliwość sygnału sinusoidalnego
amplitude = 1;               % Amplituda sygnału sinusoidalnego
fragment_length = 1;         % Długość fragmentu w sekundach
noise_level = 1;             % Poziom szumu Gaussowskiego

% Generowanie sygnału sinusoidalnego
sine_wave = amplitude * sin(2 * pi * f * t);

% Generowanie szumu Gaussa
noise = noise_level * randn(1, length(t));

% Dodanie szumu do sygnału sinusoidalnego
noisy_sine_wave = sine_wave + noise;

figure
% Parametry fragmentów
fragment_samples = fragment_length * fs; % Liczba próbek w fragmencie
num_fragments = floor(length(t) / fragment_samples);

% Parametry STFT i PSD
Mwind = 256;
Mstep = 16;
Mfft = 2 * Mwind;
dt = 1 / fs;
fpr = fs;
w = hamming(Mwind)';  % Wybór okna

% Inicjalizacja zmiennych do przechowywania wyników
all_psd = zeros(Mfft, num_fragments);
psd_fragments = zeros(Mfft, num_fragments);

% Przetwarzanie fragmentów
for frag = 1:num_fragments
    % Wybór fragmentu
    fragment = noisy_sine_wave((frag-1)*fragment_samples+1 : frag*fragment_samples);
    
    % Inicjalizacja STFT i PSD dla fragmentu
    X2 = zeros(1, Mfft);
    Many = floor((length(fragment) - Mwind) / Mstep) + 1;
    
    % Pętla analizy
    for m = 1:Many
        bx = fragment(1 + (m - 1) * Mstep : Mwind + (m - 1) * Mstep);
        bx = bx .* w;
        X = fft(bx, Mfft) / sum(w);
        X2 = X2 + abs(X) .^ 2;  % Welch PSD
    end
    
    % Normalizacja PSD
    X2 = (1 / Many) * X2 / fpr;
    all_psd(:, frag) = X2;
    psd_fragments(:, frag) = X2;
end

% Obliczanie średniej wartości widma mocy
average_psd = mean(all_psd, 2);
frequencies = fpr / Mfft * (0 : Mfft - 1);  % Częstotliwości dla widma

% Rysowanie wykresów
figure;
subplot(3, 1, 1);
plot(t, noisy_sine_wave);
xlabel('Czas [s]');
ylabel('Amplituda');
title('Długi sygnał sinusoidalny z szumem Gaussowskim');
grid on;

subplot(3, 1, 2);
for frag = 1:num_fragments
    plot(frequencies, psd_fragments(:, frag), 'DisplayName', ['Fragment ' num2str(frag)]);
    hold on;
end
xlabel('Częstotliwość [Hz]');
ylabel('Moc [V^2/Hz]');
title('Widma mocy fragmentów');
legend show;
grid on;
hold off;

subplot(3, 1, 3);
plot(frequencies, average_psd);
xlabel('Częstotliwość [Hz]');
ylabel('Moc [V^2/Hz]');
title('Średnie widmo mocy fragmentów');
grid on;

