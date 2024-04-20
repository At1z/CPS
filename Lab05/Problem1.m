p12 = -0.5 + 9.5j;
p34 = -1 + 10j;
p56 = -0.5 + 10.5j;
z12 = 5j;
z34 = 15j;
p = [p12,p34,p56]; % biegunowe == bardzo małe wartości powodują duże wzmocnienie
p = [p conj(p)]; % biegunowe + uwzględnienie sprzężenia
z = [z12,z34]; % miejsca zerowe == wyzerowanie odpowiedzi częstotliwościowej dla wybranych częstotliwości
z = [z  conj(z)]; % miejsca zerowe + uwzględnienie sprzężenia
wzm=0.42; % wzmocnienie 

% po prostu plot p i z na osi X i Y
hold on;
plot(real(p),imag(p),"o");
plot(real(z),imag(z),"x");
grid on
axis equal
xlabel("Re(z)");
ylabel("Im(z)");

% tworzenie wielomianu 
a = poly(p); 
b = poly(z)*wzm;

w =  4:0.1:16;
s = w*j; % przesunięcie 
Hlinear = abs(polyval(b,s) ./ polyval(a,s)); % obliczenie wartości transmitancji w dziedzinie częstotliwości

figure;
plot(w,Hlinear);
xlabel("Częstotliwość [rad/s]")
ylabel("|H(jw)|");
figure;
Hlog = 20*log10(Hlinear); % wartość w skali logarytmicznej
wlog = logspace(0,1000,40); % zakres częstotliwości
plot(w,Hlog,'r');
xlabel("Częstotliwość [rad/s]")
ylabel("20log10(|H(jw)|)")

% Charakterystyka fazowa-częstotliwościowa
figure;
H_phase = angle(polyval(b,s) ./ polyval(a,s)); % wartości charakterystyki fazowej
plot(w, H_phase, 'g');
xlabel('Częstotliwość [rad/s]');
ylabel('Kąt [rad]');
title('Charakterystyka fazowo-częstotliwościowa');
grid on;
figure;
freqs(b,a,w); % zależność między amplitudą i fazą sygnału wejściowego a sygnałem wyjściowym układu dla różnych częstotliwości.


%{
Czy filtr ten jest pasmowo-przepustowy?
Tak, filtr jest pasmowo-przepustowy, ponieważ ma miejsca zerowe i biegunowe wokół pulsacji przenoszenia.

Pulsacja przenoszenia to częstotliwość, na której układ przenosi sygnał bez zmiany jego amplitudy i fazy, czyli charakteryzuje się on maksymalnym wzmocnieniem w paśmie przepustowym.
Jest to częstotliwość, na której sygnał jest przenoszony przez układ z minimalnym tłumieniem i z minimalnymi zmianami w charakterystyce fazowej.

W kontekście analizy układów filtracyjnych, pulsacja przenoszenia jest częstotliwością, na której filtr przepuszcza sygnał z maksymalną efektywnością, tłumiąc sygnały poza pasmem przepustowym.
W przypadku filtrów pasmowo-przepustowych, pasmo przepustowe obejmuje częstotliwości wokół pulsacji przenoszenia.

W przypadku analizy charakterystyki częstotliwościowej filtru, pulsacja przenoszenia jest częstotliwością, na której transmitancja (wzmocnienie) układu osiąga swoją maksymalną wartość.
Jest to istotne pojęcie zarówno w teorii filtracji sygnałów, jak i w projektowaniu układów filtracyjnych, ponieważ definiuje ono główną charakterystykę działania filtru.


Jakie jest maksymalne i minimalne tłumienie w paśmie zaporowym?
Maksymalne tłumienie w paśmie zaporowym jest określone przez minimalną wartość transmitancji w tym paśmie.
Minimalne tłumienie jest zwykle w bezpośrednim sąsiedztwie pasma przepustowego.
figure 4 :)

Czy wzmocnienie układu w paśmie przepustowym jest równe 1?
W przypadku idealnego filtru pasmowo-przepustowego wzmocnienie w paśmie przepustowym wynosi 1.
Jednakże, w praktyce może być nieco różne od 1 z powodu niedoskonałości elementów filtrujących.
figure 2 i 3 

Czy filtr ten jest zgodny z naszymi oczekiwaniami?
Charakterystyka fazowo-częstotliwościowa powinna być liniowa w paśmie przepustowym, co zapewnia, że 
układ nie zmienia kształtu sygnału zawartego w tym paśmie.
Jeśli charakterystyka fazowa jest liniowa w pasmie przepustowym, to filtr jest zgodny z oczekiwaniami.
%}