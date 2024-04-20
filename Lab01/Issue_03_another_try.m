clear all;
close all;
clc;

% Wczytaj sygnał z pliku adsl_x.mat
adsl = load('adsl_x.mat');
sygnal = adsl.x;

% Parametry sygnału
K = 4;        % Liczba bloków w sygnale
M = 32;       % Długość prefiksu
N = 512;      % Długość bloku

% Okno czasowe zawierające ostatnie M próbek sygnału
prefiks = sygnal(end - M + 1:end);

figure;
plot(sygnal);
hold on;

% Inicjalizacja wektora przechowującego indeksy początków prefiksów
prefix_starts = zeros(1, K);


for k = 1:K
    % Wyznaczanie korelacji wzajemnej między prefiksem a ramką
    start_index = (k-1)*(M+N) + 1;
    end_index = min((k)*(M+N), length(sygnal));
    
    blok = sygnal(start_index:end_index);

    % Prefiks zaczyna się na pierwszej próbce bloku
    prefiks = blok(1:M);
    ramka = blok((M+1):end);
    length(ramka)

    % Inicjalizacja wektora przechowującego korelacje
    correlations = zeros(1, length(ramka)-M+1);

   % Oblicz korelację między prefiksem a każdym 32-elementowym blokiem w ramce
for i = 1:length(ramka)-M+1
    blok_ramki = ramka(i:(i+M-1));
    correlations(i) = max(xcorr(prefiks, blok_ramki, 'coeff'));

end

    % Znajdź indeks maksimum korelacji
    [~, max_index] = max(correlations);

    % Zapisz początek prefiksu
    prefix_starts(k) = start_index + max_index - 1;
end


% Wyświetlenie wyników
disp('Początki prefiksów:');
disp(prefix_starts);