% cps_04_dft.m
clear all; close all; clc;

% Macierze transformacji DFT
N = 100;                                % wymiar macierzy
k = (0:N-1); n=(0:N-1);                 % wiersze=funkcje/sygnaly bazowe, kolumny=probki
A = exp(-j*2*pi/N*k'*n);                % macierz analizy DFT, z innym skalowaniem niz poprzednio
S = A';                                 % macierz syntezy DFT: sprzezenie + transpozycja
                                        % S = exp(j*2*pi/N*n’*k); A = S’; % z lab. o transformatach ortogonalnych
                                        % diag(S*A), pause % sprawdzenie ortogonalnosci macierzy, N na przekanej

% Signal
fs=1000; dt=1/fs; t=dt*(0:N-1).';       % skalowanie osi czasu, czas pionowo!
T=N*dt; f0=1/T; fk = f0*(0:N-1);        % fskalowanie osi czestotliwosci
x1 = 1*cos(2*pi*(10*f0)*t);             
x2 = 1*cos(2*pi*(10.5*f0)*t);           
x3 = 0.001*cos(2*pi*(20*f0)*t);         
x13 = x1 + x3;
x23 = x2 + x3;
xes = [x1,x2,x3,x13,x23];
x = xes(:,4);                          % wybor: x1, x2, x3, x1+x2, x2+x3
figure;
subplot(211);
plot(x)
title('x');

% Funkcja "okna"
w1 = boxcar(N);                         % okno prostokatne, N - dlugosc
w2 = chebwin(N,100);                    % okno Czebyszewa, liczba - poziom listkow bocznych
w = w1; scale = 1/sum(w);               % wybor: w1, w2 albo inne, dodane okno
    
% Windowing
x = x.*w;                               % "okienkowanie" sygnalu
subplot(212);
plot(x) 
title('x*w');
   
% DFT of the signal
X1 = A*x;                               % nasz kod DFT
X2 = fft(x);                            % funkcja Matlaba DFT (Fast Fourier Transform)
disp("błąd Widma X1(custom) - X2(matlab) ")
error1 = max(abs(X1-X2))                

% Interpretacja widma DFT, skalowanie
X1 = scale * X1;                        % skalowanie amplitudy X1
X2 = scale * X2;                        % skalowanie amplitudy X2
disp("błąd Widma X1(custom) - X2(matlab) po wyskalowaniu ")
error2 = max(abs(X1-X2))                

figure;
subplot(211); 
plot(fk, real(X1), 'o-', fk, real(X2), 'x-'); 
title('real(X(f))'); 
legend('X1 (custom DFT)', 'X2 (MATLAB FFT)');
grid;

subplot(212); 
plot(fk, imag(X1), 'o-', fk, imag(X2), 'x-'); 
title('imag(X(f))'); 
legend('X1 (custom DFT)', 'X2 (MATLAB FFT)');
grid;

figure;
subplot(211); 
plot(fk, 20*log10(abs(X1)), 'o-', fk, 20*log10(abs(X2)), 'x-'); 
title('abs(X(f)) [dB]'); 
legend('X1 (custom DFT)', 'X2 (MATLAB FFT)');
grid;

subplot(212); 
plot(fk, angle(X1), 'o-', fk, angle(X2), 'x-'); 
title('angle(X(f)) [rad]'); 
legend('X1 (custom DFT)', 'X2 (MATLAB FFT)');
grid;

% Modyfikacja widma DFT - przyklad
%X1(1+10)=0; X1(N-10+1)=0; % usuniecie sygnalu x1 o czestotliwosci 10*f0 
%X2(1+10)=0; X2(N-10+1)=0; % usuniecie sygnalu x1 o czestotliwosci 10*f0

% Odwrotne DFT - synteza sygnalu na podstawie jego widma
% Synteza sygnału z X1
y1 = S * X1;                           
disp("błąd odtworzenia sygnału x z X1(custom)")
errorX1 = max(abs(x - y1))            

% Synteza sygnału z X2
y2 = S * X2;                            
disp("błąd odtworzenia sygnału x z X2(matlab)")
errorX2 = max(abs(x - y2))          

figure;                               
subplot(211); plot(real(y1), 'bo-'); hold on; plot(real(y2), 'rx-'); title('Real part of y1(n) and y2(n)'); legend('y1(n)', 'y2(n)'); grid;
subplot(212); plot(imag(y1), 'bo-'); hold on; plot(imag(y2), 'rx-'); title('Imaginary part of y1(n) and y2(n)'); legend('y1(n)', 'y2(n)'); grid;
