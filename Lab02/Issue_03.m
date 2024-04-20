clear all;
close all;
clc;

% Parametry
N = 100; % Liczba próbek sygnału
fs = 1000; % Częstotliwość próbkowania (Hz)
f1 = 50; % Częstotliwość pierwszej składowej (Hz)
f2 = 100; % Częstotliwość drugiej składowej (Hz)
f3 = 150; % Częstotliwość trzeciej składowej (Hz)
A1 = 50; % Amplituda pierwszej składowej
A2 = 100; % Amplituda drugiej składowej
A3 = 150; % Amplituda trzeciej składowej

% Generowanie sygnału x będącego sumą trzech sinusoid
t = (0:N-1) / fs;
x = A1 * sin(2*pi*f1*t) + A2 * sin(2*pi*f2*t) + A3 * sin(2*pi*f3*t);

% Budowa macierzy A=DCT i S=IDCT dla N=100
A = dct(eye(N));
S = idct(eye(N));

% Wyświetlanie wartości w pętli
figure;
for i = 1:N
    % Wyświetlanie wartości wiersza macierzy A
    subplot(2,1,1);
    plot(A(i,:));
    title(['Wiersz macierzy A: ' num2str(i)]);
    
    % Wyświetlanie kolumny macierzy S
    subplot(2,1,2);
    plot(S(:,i));
    title(['Kolumna macierzy S: ' num2str(i)]);
    
    % Pauza
    pause(0.1);
end

% Analiza y = Ax
y = A * x';

% Porównanie wartości współczynników niezerowych z amplitudami składowych sygnału
disp('Wartości współczynników niezerowych:');
disp(y(1:N));

% Wyskalowanie osi poziomej w częstotliwości
f = (0:N-1) * fs / N;

% Wyświetlanie wartości współczynników niezerowych na wykresie
figure;
plot(f, abs(y));
title('Analiza sygnału - wartości współczynników niezerowych');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');

% Rekonstrukcja sygnału xr = Sy
xr = S * y;

% Sprawdzenie perfekcyjnej rekonstrukcji
if isequal(x, xr')
    disp('Perfekcyjna rekonstrukcja: Tak');
else
    disp('Perfekcyjna rekonstrukcja: Nie');
end

% Obliczenie różnicy między sygnałem pierwotnym a zrekonstruowanym
error = x - xr';

% Obliczenie normy błędu
error_norm = norm(error);

disp(['Norma błędu rekonstrukcji: ', num2str(error_norm)]);

% Zmiana częstotliwości drugiej składowej na f2=105 Hz
f2 = 105;
x = A1 * sin(2*pi*f1*t) + A2 * sin(2*pi*f2*t) + A3 * sin(2*pi*f3*t);

% Analiza y = Ax
y = A * x';

% Wyświetlanie wyskalowanego wykresu y(f)
figure;
plot(f, abs(y));
title('Analiza sygnału z f2=105 Hz');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');

% Rekonstrukcja sygnału xr = Sy
xr = S * y;

% Sprawdzenie perfekcyjnej rekonstrukcji
if isequal(x, xr')
    disp('Perfekcyjna rekonstrukcja (f2=105 Hz): Tak');
else
    disp('Perfekcyjna rekonstrukcja (f2=105 Hz): Nie');
end

% Obliczenie różnicy między sygnałem pierwotnym a zrekonstruowanym
error = x - xr';

% Obliczenie normy błędu
error_norm = norm(error);

disp(['Norma błędu rekonstrukcji (f2=105 Hz): ', num2str(error_norm)]);

% Zwiększenie wszystkich częstotliwości o 2.5 Hz
f1 = f1 + 2.5;
f2 = f2 + 2.5;
f3 = f3 + 2.5;

% Generowanie sygnału x
x = A1 * sin(2*pi*f1*t) + A2 * sin(2*pi*f2*t) + A3 * sin(2*pi*f3*t);

% Analiza y = Ax
y = A * x';

% Wyświetlanie wartości współczynników niezerowych na wykresie
figure;
plot(f, abs(y));
title('Analiza sygnału z przesunięciem częstotliwości');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda');

% Rekonstrukcja sygnału xr = Sy
xr = S * y;

% Sprawdzenie perfekcyjnej rekonstrukcji
if isequal(x, xr')
    disp('Perfekcyjna rekonstrukcja (przesunięcie częstotliwości): Tak');
else
    disp('Perfekcyjna rekonstrukcja (przesunięcie częstotliwości): Nie');
end

% Obliczenie różnicy między sygnałem pierwotnym a zrekonstruowanym
error = x - xr';

% Obliczenie normy błędu
error_norm = norm(error);

disp(['Norma błędu rekonstrukcji (przesunięcie częstotliwości): ', num2str(error_norm)]);
