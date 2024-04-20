clear all; 
close all;
clc;

N = 20; % Rozmiar macierzy
A = zeros(N); % Inicjalizacja macierzy A

for k = 0:N-1
    for n = 0:N-1
        if k == 0
            sk = sqrt(1/N);
        else
            sk = sqrt(2/N);
        end
        A(k+1, n+1) = sk * cos((pi * k * (2 * n + 1)) / (2 * N));
    end
end

% Sprawdzenie, czy wektory są ortonormalne
is_ortonormal = true; % Założenie, że wektory są ortonormalne

for i = 1:N
    for j = 1:N
        dot_product = dot(A(i,:), A(j,:));
        if i == j
            if abs(dot_product - 1) ~= 0 % Sprawdzenie czy iloczyn skalarny wektora z samym sobą jest równy 1
                is_ortonormal = false;
                break;
            end
        end
    end
    if ~is_ortonormal
        break;
    end
end

if is_ortonormal
    disp('Wszystkie wektory (wiersze macierzy) są ortonormalne.');
else
    disp('Nie wszystkie wektory (wiersze macierzy) są ortonormalne.');
end

% Obliczenie odwrotnej transformaty kosinusowej (IDCT)
reconstructed_A = zeros(N);
for k = 0:N-1
    for n = 0:N-1
        for i = 0:N-1
            for j = 0:N-1
                if i == 0
                    ci = sqrt(1/N);
                else
                    ci = sqrt(2/N);
                end
                if j == 0
                    cj = sqrt(1/N);
                else
                    cj = sqrt(2/N);
                end
                reconstructed_A(k+1, n+1) = reconstructed_A(k+1, n+1) + ci * cj * A(i+1, j+1) * cos((pi * i * (2 * k + 1)) / (2 * N)) * cos((pi * j * (2 * n + 1)) / (2 * N));
            end
        end
    end
end

% Obliczenie błędu
error = norm(A - reconstructed_A);
disp(['Błąd: ', num2str(error)]);


