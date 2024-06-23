%{
04_06
Oczywiście, przejdźmy do odpowiedzi na pytania na podstawie dostarczonego kodu MATLAB:

Dlaczego podczas porównywania X1 (niestandardowa DFT) i X2 (FFT w MATLAB) podano błędy?

Wartości błędów (error1) pokazują maksymalną wartość bezwzględną różnicy między X1 a X2, co ilustruje różnice w precyzji numerycznej między niestandardową implementacją DFT (X1) a wbudowaną funkcją FFT w MATLAB (X2). Idealnie błąd powinien być bliski zeru, co oznaczałoby spójność między niestandardową implementacją a funkcją MATLAB dla tego samego sygnału x.

Dlaczego widma DFT sygnałów x1 i x2 różnią się znacznie, gdy używamy okna w=w2?

Okno w2 (okno Czebyszewa) ma inną odpowiedź częstotliwościową w porównaniu do w1 (okno prostokątne). Okno Czebyszewa w2 ma lepsze tłumienie bocznoboczne, ale wprowadza wyciek widma, co powoduje rozpraszanie energii sygnału x1 i x2 na sąsiednie przedziały częstotliwościowe. To rozpraszanie zmienia amplitudę i fazę widm DFT, prowadząc do widocznych różnic między x1 i x2.

Dlaczego sygnał x3 nie jest widoczny w widmach DFT (x1+x3) i (x2+x3) przy użyciu w=w1, ale jest widoczny przy użyciu w=w2?

Używając w=w1 (okno prostokątne): Okno prostokątne w1 ma słabą rozdzielczość częstotliwościową i wysoki wyciek widma, co powoduje, że DFT (x1+x3) i (x2+x3) rozpraszają energię x3 na wiele przedziałów częstotliwościowych, co utrudnia jego odróżnienie od szumu.

Używając w=w2 (okno Czebyszewa): Okno Czebyszewa w2 oferuje lepszą rozdzielczość częstotliwościową i mniejsze boczne łaty, co sprawia, że sygnał o niskiej amplitudzie x3 jest bardziej rozróżnialny w widmach DFT (x1+x3) i (x2+x3).

Czy zrekonstruowany sygnał y jest podobny do oryginalnego sygnału x, gdy x=x1+x3 i w=w1?

Gdy x = x1 + x3 i w = w1, zrekonstruowany sygnał y1 (z X1) może być mniej podobny do x ze względu na słabą rozdzielczość okna w1, co wpływa na dokładność DFT i kolejną syntezę (S * X1). Okno prostokątne w1 wprowadza wyciek widma, co obniża wierność rekonstrukcji w porównaniu do w2.

Dlaczego y jest identyczne z x3 po ustawieniu X(1+10)=0; X(N-10+1)=0;?

Poprzez ustawienie X(1+10)=0; X(N-10+1)=0; przed syntezą y, konkretnie usuwane są składowe częstotliwości (związane z 10*f0) z X1. Ta operacja efektywnie filtruje składowe sygnału x1 z x1+x3. Ponieważ x3 ma inną składową częstotliwościową (20*f0), nie jest ona dotknięta tą modyfikacją. Dlatego y staje się identyczne z x3, ponieważ wkład x1 został selektywnie usunięty.

Te odpowiedzi przedstawiają wpływ różnych funkcji okna na przetwarzanie sygnałów za pomocą DFT, demonstrując, jak okienkowanie wpływa na analizę widmową i rekonstrukcję sygnałów.
%}