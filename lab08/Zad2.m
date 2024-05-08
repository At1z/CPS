clc;
% Zadanie 2 - Filtr Hilberta, modulacja AM
clear all; close all;

% Instrukcja do zadania
figure(1);
Img=imread("Instrukcja2.jpg");
Img=imshow(Img);

%% Generowanie teoretycznej odpowiedzi impulsowej
fs = 400e3;                         % czestotliwosc probkowania
fc = 100e3;                         % czestotliwosc nosna
M  = 1024;                            % polowa dlugosci filtra odpowiednia szerokość pasma
N  = 2*M+1;
n  = 1:M;
h  = (2/pi)*sin(pi*n/2).^2 ./n;     % połowa odpowiedzi impulsowej (TZ str. 352)
h  = [-h(M:-1:1) 0 h(1:M)];         % cała odpowiedź dla n = ?M,...,0,...,M

%% Wymnażanie przez okno Blackmana
w  = blackman(N); 
w  = w';            
hw = h.*w;                          % wymnożenie odpowiedzi impulsowej z oknem

%% Zaladowanie sygnalow modulowanych
[x1,fs1] = audioread('mowa8000.wav');
x1 = x1';
x2 = fliplr(x1);                    % druga stacja to mowa8000 od tyłu

%% Parametry sygnalow radiowych
fs  = 400e3;                        % czestotliwosc probkowania sygnalu radiowego
fc1 = 100e3;                        % czestotliwosc nosna 1 stacji
fc2 = 110e3;                        % czestotliwosc nosna 2 stacji
dA  = 0.25;                         % glebokosc modulacji obu stacji

%% Resampling w celu uzyskania poprawnej modulacji AM
xr1 = resample(x1, fs, fs1);
xr2 = resample(x2, fs, fs1);        %fs/fsx

xh1 = conv(xr1,hw);
xh2 = conv(xr2,hw);

xh1 = xh1(M+1:length(xr1)+M);
xh2 = xh2(M+1:length(xr2)+M);

t1 = length(x1)/fs1;
t  = 0:1/fs:t1-1/fs;

%% Filtrowanie filterm Hilberta
% xh1 = hilbert(xr1); 
% xh1 = imag(xh1);
% 
% xh2 = hilbert(xr2); 
% xh2 = imag(xh2);

%% Generowanie sygnalow radiowych
%DSB-C
Ydsb_c_a = (1+xr1).*cos(2*pi*fc1*t); %stacja 1
Ydsb_c_b = (1+xr2).*cos(2*pi*fc2*t); %stacja 2
Ydsb_c   = dA*(Ydsb_c_a + Ydsb_c_b);

%DSB-SC nie przenosi nośnej
Ydsb_sc_a = xr1.*(cos(2*pi*fc1*t));
Ydsb_sc_b = xr2.*(cos(2*pi*fc2*t));
Ydsb_sc   = dA*(Ydsb_sc_a + Ydsb_sc_b);

%SSB-SC (+) wstega po lewej Jest to najbardziej efektywny sposób
% modulacji AM pod względem zużycia przepustowości,
% ponieważ transmituje tylko jedno pasmo boczne.
Yssb_sc1_a = 0.5*xr1.*cos(2*pi*fc1*t) + 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc1_b = 0.5*xr2.*cos(2*pi*fc2*t) + 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc1   = dA*(Yssb_sc1_a + Yssb_sc1_b);

%SSB-SC (-) wstega po prawej Jest to najbardziej efektywny sposób
% modulacji AM pod względem zużycia przepustowości,
% ponieważ transmituje tylko jedno pasmo boczne.
Yssb_sc2_a = 0.5*xr1.*cos(2*pi*fc1*t) - 0.5*xh1.*sin(2*pi*fc1*t);
Yssb_sc2_b = 0.5*xr2.*cos(2*pi*fc2*t) - 0.5*xh2.*sin(2*pi*fc2*t);
Yssb_sc2   = dA*(Yssb_sc2_a + Yssb_sc2_b);

%transformaty powyzszych sygnalow AM 
HYdsb_c   = fft(Ydsb_c);
HYdsb_sc  = fft(Ydsb_sc);
HYssb_sc1 = fft(Yssb_sc1);
HYssb_sc2 = fft(Yssb_sc2);

%% Wykresy widm - porównanie typów modulacji AM
f = (0:length(HYdsb_c)-1)/length(HYdsb_c)*fs;
figure('Name','Wykresy widm - porównanie typów modulacji AM');
set(figure(2),'units','points','position',[0,0,1440,750]);

subplot(1,4,1);
plot(f, abs(HYdsb_c));
title('fft DSB-C');
xlim([90e3 120e3]);

subplot(1,4,2);
plot(f, abs(HYdsb_sc));
title('fft DSB-SC');
xlim([90e3 120e3]);

subplot(1,4,3);
plot(f, abs(HYssb_sc1));
title('fft SSB-SC (+)');
xlim([90e3 120e3]);

subplot(1,4,4);
plot(f, abs(HYssb_sc2));
title('fft SSB-SC (-)');
xlim([90e3 120e3]);

%{
DSB-C (Double Side Band with Carrier):
Jest to jeden z najprostszych rodzajów modulacji amplitudy (AM).
W przypadku DSB-C sygnał modulujący (x(t)) jest dodawany do nośnej (cos(2πf_c t)), tworząc dwie boczne pasma widmowe po obu stronach częstotliwości nośnej.
Pasmo nośnej zawiera również oryginalny sygnał nośny. Dlatego nazwa "Double Side Band with Carrier" - podwójne pasmo boczne z nośną.
Sygnał ten ma prostą implementację, ale wykorzystuje więcej energii, ponieważ nośna musi być przesyłana razem z sygnałem modulującym, co powoduje, że jest marnowana pewna część przepustowości pasma.

DSB-SC (Double Side Band - Suppressed Carrier):
W DSB-SC nośna jest usuwana z sygnału DSB-C, pozostawiając tylko dwie boczne pasma widmowe.
W tym przypadku sygnał modulujący jest przemnażany przez nośną, ale bez dodawania, co oznacza, że nośna nie jest transmitowana razem z sygnałem modulującym.
Jest to bardziej efektywny sposób modulacji AM, ponieważ nie marnuje się energii na przesyłanie nośnej. Jednak de-modulacja wymaga odtworzenia nośnej, co może być złożone.

SSB-SC (Single Side Band - Suppressed Carrier):
W SSB-SC usuwane jest jedno z pasm bocznych, pozostawiając tylko jedno pasmo boczne.
Wersja SSB-SC ma dwie warianty, z wstęgą boczną po lewej ((+)) lub prawej ((-)) stronie częstotliwości nośnej. Oznacza to, że tylko jedno pasmo boczne jest transmitowane wraz z nośną, a drugie jest usuwane.
Jest to najbardziej efektywny sposób modulacji AM pod względem zużycia przepustowości, ponieważ transmituje tylko jedno pasmo boczne. Jednak, podobnie jak w przypadku DSB-SC, de-modulacja wymaga odtworzenia nośnej.
%}