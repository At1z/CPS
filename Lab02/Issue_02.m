% Generowanie macierzy analizy A transformaty DCT-II
clear all;
close all;
clc;

N = 20;
n = 0:N-1;
k = 0:N-1;

s0 = sqrt(1/N);
sk = sqrt(2/N);

A = zeros(N, N);
for k = 0:N-1
    for n = 0:N-1
        A(n+1, k+1) = sk * cos(pi * k * (n + 0.5) / N);
    end
    A(:, k+1) = A(:, k+1) / norm(A(:, k+1)); % Normalizacja wektorów
end

% Generowanie macierzy odwrotnej S
S = A';

% Sprawdzenie, czy SA == I
identity_matrix = eye(N);
if isequal(S * A, identity_matrix)
    disp('Wynik sprawdzenia SA==I: Macierz identycznościowa.');
else
    disp('Wynik sprawdzenia SA==I: Macierz nie jest identycznościowa.');
end

% Analiza i synteza sygnału losowego
x = randn(N, 1);
X = A * x;

% Rekonstrukcja sygnału
xs = S * X;

% Sprawdzenie, czy transformacja posiada właściwość perfekcyjnej rekonstrukcji
if isequal(xs, x)
    disp('Wynik sprawdzenia xs==x: Transformacja posiada właściwość perfekcyjnej rekonstrukcji.');
else
    disp('Wynik sprawdzenia xs==x: Transformacja nie posiada właściwości perfekcyjnej rekonstrukcji.');
end

% Obliczenie błędu rekonstrukcji
reconstruction_error = norm(xs - x);

% Obliczenie błędu transformacji
transformation_error = norm(S * A - eye(N));

disp(['Błąd rekonstrukcji: ', num2str(reconstruction_error)]);
disp(['Błąd transformacji: ', num2str(transformation_error)]);

