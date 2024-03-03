close all
clear 
clc

%% Definizione dei valori per il parametro time
T_sim = 25;
tau = 0.02;

max_iterations = round(T_sim / tau);
time = linspace(0, T_sim, max_iterations); % Puoi modificare il numero di punti per avere una maggiore risoluzione

%% Traiettoria da seguire --> figura di Lissajous
% Definizione dei parametri
A = 3; % Amplitude per l'asse x
B = 1; % Amplitude per l'asse y
freq_x = 1; % Frequenza per l'asse x
freq_y = 2; % Frequenza per l'asse y
phase = 0; % Fase iniziale (puoi modificare questo valore)

% Creazione di una struct vuota
reference = struct();

% Calcolo delle coordinate x e y della figura di Lissajous
reference.Xdes = A * sin(freq_x * time);
reference.Ydes = B * sin(freq_y * time + phase);

reference.Xdes_dot = A * freq_x * cos(freq_x * time);
reference.Ydes_dot = B * freq_y * cos(freq_y * time + phase);

reference.Xdes_2dot = - A * freq_x^2 * sin(freq_x * time);
reference.Ydes_2dot = - B * freq_y^2 * sin(freq_y * time + phase);

% Disegno della figura di Lissajous
plot(reference.Xdes, reference.Ydes);
title('Figura di Lissajous');
xlabel('Asse x');
ylabel('Asse y');
axis equal; % Imposta gli assi con la stessa scala per una migliore visualizzazione
grid on; % Mostra la griglia

%% Inizio a scrivermi la dinamica
x0 = [1;
      1;
      1;
      1];

u0 = [1;
      1];

x_nl = zeros(4, max_iterations);

x_nl(:,1) = x0;
% keyboard;

for k = 1:max_iterations - 1
    
    txt = sprintf('Iterazione n°: %d / %d', k, max_iterations);
    disp(txt);

    U = computeControls(x_nl(:,k), reference,k);
    
    tspan = [time(k), time(k+1)];
   
    % options = odeset('RelTol', 1e-4); % Modifica la tolleranza relativa secondo necessità
    [t, x] = ode45(@(t, x) NL_System(x,u), tspan, x0, options);
    
    
    x0 = x(end, :).';
    x_nl(:, k+1) = x0;

end

figure(1);
plot(z_nl(1,:),z_nl(2,:));
grid on;



