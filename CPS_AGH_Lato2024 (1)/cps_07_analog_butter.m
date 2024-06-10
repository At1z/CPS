% cps_07_analog_butter.m
clear all; close all;

N =5;                                    % liczba biegunow transmitancji
f0 = 100;                                % czestotliwosc 3dB (odciecia) filtra dolnoprzepustowego
alpha = pi/N;                            % kat "kawalka tortu" (okregu)
beta  = pi/2 + alpha/2 + alpha*(0:N-1);  % katy kolejnych biegunow transmitancji
R = 2*pi*f0;                             % promien okregu
p = R*exp(j*beta);                       % bieguny transmitancji lezace na okregu
z = []; wzm = prod(-p);                  % LOW-PASS:  brak zer tramsitancji, wzmocnienie
%z = zeros(1,N); wzm = 1;                % HIGH-PASS: N zer transmitancji, wzmocnienie
b = wzm*poly(z); a=poly(p);              % [z,p] --> [b,a]
b = real(b);      a=real(a);             %

% ... kontynuacja csp_07_analog_intro.m
