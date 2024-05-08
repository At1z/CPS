clc;
% Zadanie 3 - Filtr interpolatora i decymatora cyfrowego, mikser audio
clear all; close all;
% Instrukcja do zadania
figure(1);
Img=imread("Instrukcja31.jpg");
Img=imshow(Img);
figure(2);
Img=imread("Instrukcja32.jpg");
Img=imshow(Img);

%% Dane trzech sygnałów sinusoidalnych
f1 = 1001.2;
f2 = 303.1;
f3 = 2110.4;

fs1 = 8e3;
fs2 = 32e3;
fs3 = 48e3;

t1 = 0:1/fs1:1-1/fs1;
t2 = 0:1/fs2:1-1/fs2;
t3 = 0:1/fs3:1-1/fs3;

%% Tworzenie i plotowanie sygnałów sinusoidalnych
x1 = sin(2*pi*f1*t1);
x2 = sin(2*pi*f2*t2);
x3 = sin(2*pi*f3*t3);

figure('Name','Fragmenty składowych sygnałow sinusoidalnych');
hold on;
plot(t1,x1,'r');
plot(t2,x2,'b');
plot(t3,x3,'g');
title('Fragmenty składowych sygnałow sinusoidalnych');
legend('1001.2Hz','303.1Hz','2110.4Hz');
xlabel('Czas [s]');
ylabel('Amplituda');
hold off;

xlim([0 1/f3]);

%% Suma trzech sygnalow sinusoidalnych analitycznie
x4 = sin(2*pi*f1*t3) + sin(2*pi*f2*t3) + sin(2*pi*f3*t3);

%% upsampling
x1up = upsample(x1,fs3/fs1);            % x1 z 8khz  na 48khz 
x2up = decimate(upsample(x2,3),2);      % x2 z 32khz na 96khz i potem co druga probka ->48khz
x4_upsampling = x1up + x2up + x3;

%% resampling
x1re  = resample(x1,fs3,fs1);           %x1 z 8khz na 48khz 
[P,Q] = rat(fs3/fs2);
x2re  = resample(x2,P,Q);               %x2 z 32khz na 96khz i potem co druga probka ->48khz
x4_resampling = x1re + x2re + x3;

%% Porownanie sygnałów analitycznego i po upsamplingu
figure('Name','Porownanie sygnałów analitycznego i po upsamplingu');
set(figure(4),'units','points','position',[0,0,720,750]);

subplot(3,1,1);
hold all;
plot(x4, 'r');
plot(x4_upsampling, 'b');
title('Sygnal analityczny i po upsamplingu');
legend('analityczny','upsampling');

subplot(3,1,2);
plot(abs(fft(x4)),'b');
title('Widmo - sygnal analityczny');
xlim([0 0.5e4]);

subplot(3,1,3);
plot(abs(fft(x4_upsampling)),'b');
title('Widmo - sygnal po upsamplingu');
xlim([0 0.5e4]);

%{
sound(x4, fs3);
pause(2);
sound(x4_upsampling, fs3);
%}

%% Porownanie sygnałów analitycznego i po resamplingu
figure('Name','Porownanie sygnałów analitycznego i po resamplingu');
set(figure(5),'units','points','position',[720,0,720,750]);

subplot(3,1,1);
hold all;
plot(x4, 'r');
plot(x4_resampling, 'b');
title('Sygnal analityczny i po resamplingu');
legend('analityczny','resampling');

subplot(3,1,2);
plot(abs(fft(x4)),'b');
title('Widmo - sygnal analityczny');
xlim([0 0.5e4]);

subplot(3,1,3);
plot(abs(fft(x4_resampling)),'b');
title('Widmo - sygnal po resamplingu');
xlim([0 0.5e4]);

%{
pause(4);
sound(x4, fs3);
pause(2);
sound(x4_resampling, fs3);
%}

%% MIKS x1 i x2
[x1wav, fs1w] = audioread('x1.wav');
[x2wav, fs2w] = audioread('x2.wav');
x1wav = x1wav(:,1)';
x2wav = x2wav';
f_wav = 48e3;                                               % resampling do 48e3

K = 3;
M = 50;
N = 2*M+1;
Nx=length(x1wav);
xz = zeros(1,K*Nx);
xz(1:K:end) = x1wav;
h = K*fir1(N, 1/K);
x1wav_re = filter(h,1,xz);

L = 2;
M = 50;
N = 2*M+1;
h = K*fir1(N, 1/L - 0.1*(1/L));
x1wav_re = filter(h,1,x1wav_re);
x1wav_re = x1wav_re(1:L:end);

% Resampling sygnału x2
K = 6;
M = 50;
N = 2*M+1;
Nx=length(x2wav);
xz = zeros(1,K*Nx);
xz(1:K:end) = x2wav;
h = K*fir1(N, 1/K);
x2wav_re = filter(h,1,xz);

% Miksowanie sygnałów
miks = x1wav_re;
miks(1:length(x2wav_re)) = miks(1:length(x2wav_re)) + x2wav_re;
%sound(miks,f_wav);
