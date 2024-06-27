clear all; close all; clc;

% Projektowanie filtra analogowego Butterwortha
[b, a] = butter(4, 100, 's'); % 4-rzędowy filtr Butterwortha o częstotliwości 100 rad/s
[z, p, k] = tf2zp(b, a); % Konwersja do postaci zer, biegunów i wzmocnienia

% Użycie funkcji bilinear i bilinearMY do przekształcenia filtra analogowego na cyfrowy
fpr = 1000; 
[zz_builtin, pp_builtin, ggain_builtin] = bilinear(z, p, k, fpr);
[zz_my, pp_my, ggain_my] = bilinearMY(z, p, k, fpr);


disp('Porównanie zer (analog) :');
disp('Funkcja wbudowana:');
disp(zz_builtin);
disp('Funkcja bilinearMY:');
disp(zz_my);

disp('Porównanie biegunów:');
disp('Funkcja wbudowana:');
disp(pp_builtin);
disp('Funkcja bilinearMY:');
disp(pp_my);

disp('Porównanie wzmocnienia (analog):');
disp('Funkcja wbudowana:');
disp(ggain_builtin);
disp('Funkcja bilinearMY:');
disp(ggain_my);


figure;
subplot(2,2,1);
zplane(z, p ); % zera - O, bieguny - X
title('Zera i bieguny filtra analogowego');


subplot(2,2,2);
zplane(zz_builtin, pp_builtin); % zera - O, bieguny - X
title('Zera i bieguny filtra cyfrowego (bilinear)');


subplot(2,2,3);
zplane(zz_my, pp_my); % zera - O, bieguny - X
title('Zera i bieguny filtra cyfrowego (bilinearMY)');


[h_a, w_a] = freqs(b, a, logspace(1, 4, 1000));
subplot(2,2,4);
semilogx(w_a, 20*log10(abs(h_a)));
grid on;
title('Charakterystyka amplitudowo-częstotliwościowa filtra analogowego');
xlabel('Częstotliwość (rad/s)');
ylabel('Amplituda (dB)');

[b_d_builtin, a_d_builtin] = zp2tf(zz_builtin(:), pp_builtin(:), ggain_builtin); % Konwersja na kolumny
[h_d_builtin, w_d_builtin] = freqz(b_d_builtin, a_d_builtin, 1024, fpr);

[b_d_my, a_d_my] = zp2tf(zz_my(:), pp_my(:), ggain_my); % Konwersja na kolumny
[h_d_my, w_d_my] = freqz(b_d_my, a_d_my, 1024, fpr);

figure;
plot(w_a / (2*pi), 20*log10(abs(h_a)), 'b', 'LineWidth', 1.5); % Analogowy
hold on;
plot(w_d_builtin / (2*pi), 20*log10(abs(h_d_builtin)), 'r--', 'LineWidth', 1.5); % Cyfrowy (bilinear)
plot(w_d_my / (2*pi), 20*log10(abs(h_d_my)), 'g:', 'LineWidth', 1.5); % Cyfrowy (bilinearMY)
grid on;
title('Charakterystyka amplitudowo-częstotliwościowa filtra analogowego i cyfrowego');
xlabel('Częstotliwość (Hz)');
ylabel('Amplituda (dB)');
legend('Analogowy', 'Cyfrowy (bilinear)', 'Cyfrowy (bilinearMY)');