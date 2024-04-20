clear all;
close all;
clc;

% Wczytaj sygnał audio
[x, fs] = audioread('mowa.wav');

% Wybierz M=10 różnych fragmentów
M = 10;
N = 256; % Długość fragmentu

% Macierz analizy (DCT)
A = zeros(N, N);
for k = 0:N-1
    for n = 0:N-1
        if n == 0
            A(n+1, k+1) = sqrt(1/N) * cos(pi * k * (n + 0.5) / N);
        else
            A(n+1, k+1) = sqrt(2/N) * cos(pi * k * (n + 0.5) / N);
        end
    end
end

% Wykonaj analizę dla każdego fragmentu
for k = 1:M
    n1 = (k-1)*N + 1;
    n2 = k*N;
    xk = x(n1:n2);
    
    % Oblicz wynik analizy
    yk = A * xk;
    
    % Wyświetl fragment sygnału i jego analizę
    figure;
    subplot(2,1,1);
    plot(xk);
    title(['Fragment sygnału x_k nr ', num2str(k)]);
    xlabel('Numer próbki');
    ylabel('Amplituda');
    
    subplot(2,1,2);
    freq = (0:N-1) * (fs/N); % Skala częstotliwości
    plot(freq, abs(yk));
    title('Wynik analizy y_k w dziedzinie częstotliwości');
    xlabel('Częstotliwość (Hz)');
    ylabel('Amplituda');
end
